import 'package:collection/collection.dart';
import 'package:finject_generator/src/json_schema/injector_Info.dart';
import 'package:source_gen/source_gen.dart';

class DependencyBag {
  Map<DependencyCache, GraphNode> bagCache =
      EqualityMap<DependencyCache, GraphNode>(DefaultEquality());
  final duplicateDetector = EqualitySet<DependencyCache>(DefaultEquality());

  EqualitySet<DependencyCache> duplicates =
      EqualitySet<DependencyCache>(DefaultEquality());

  EqualityMap<DependencyCache, InjectorDs> cacheOfInjectors =
      EqualityMap<DependencyCache, InjectorDs>(DefaultEquality());

  void addType(InjectorDs injectorDs) {
    final type = injectorDs.typeName;

    final cache = DependencyCache()
      ..name = injectorDs.name
      ..typeName = type;

    if (!duplicateDetector.add(cache)) {
      duplicates.add(cache);
      throw InvalidGenerationSourceError(
          'Duplicate dependency detected ${cache}'); //if was not added we have duplicate so We need Error
    }

    cacheOfInjectors[cache] = injectorDs;
  }

  void process() {
    for (final entry in cacheOfInjectors.entries) {
      final node = GraphNode();
      node.cache = entry.key;
      node.scopeName = entry.value.scopeName;
      node.visited = true;
      bagCache[entry.key] = node;
      processDependencies(entry.value, node);
      node.procesed = true;
      node.visited = false;
    }
  }

  void processDependencies(InjectorDs injectorDs, GraphNode parentNode) {
    if (injectorDs.factoryTypeName != null) {
      processFactoryMethodInjection(injectorDs, parentNode);
    } else {
      processConstructorInjection(injectorDs, parentNode);
      processFieldInjection(injectorDs, parentNode);
    }
  }

  void processFactoryMethodInjection(
      InjectorDs injectorDs, GraphNode parentNode) {
    final method = injectorDs.methodInjections[0];
    for (var index = 0; index < method.orderedParameters.length; index++) {
      final typeInfo = method.orderedParameters[index];
      final name = method.orderedNames[index];
      processTypeWithName(typeInfo, name, parentNode);
    }
    for (var paramName in method.namedParameters.keys) {
      final typeInfo = method.namedParameters[paramName];
      final name = method.namedNames[paramName];
      processTypeWithName(typeInfo, name, parentNode);
    }
  }

  void processConstructorInjection(
      InjectorDs injectorDs, GraphNode parentNode) {
    final method = injectorDs.constructorInjection;
    for (var index = 0; index < method.orderedParameters.length; index++) {
      final typeInfo = method.orderedParameters[index];
      final name = method.orderedNames[index];
      processTypeWithName(typeInfo, name, parentNode);
    }
    for (var paramName in method.namedParameters.keys) {
      final typeInfo = method.namedParameters[paramName];
      final name = method.namedNames[paramName];
      processTypeWithName(typeInfo, name, parentNode);
    }
  }

  void processFieldInjection(InjectorDs injectorDs, GraphNode parentNode) {
    final method = injectorDs.fieldInjection;
    for (var paramName in method.namedParameter.keys) {
      final typeInfo = method.namedParameter[paramName];
      final name = method.namedNames[paramName];
      processTypeWithName(typeInfo, name, parentNode);
    }
  }

  void processTypeWithName(
      TypeInfo typeInfo, String name, GraphNode parentNode) {
    final cache = DependencyCache()
      ..typeName = typeInfo
      ..name = name;

    var cacheForType = bagCache[cache];

    if (cacheForType == null) {
      final node = GraphNode();
      node.cache = cache;
      node.visited = true;
      node.scopeName = getSubDependency(cache).scopeName;

      checkConflictedScopes(parentNode, node);
      bagCache[cache] = node;
      processDependencies(getSubDependency(cache), node);
      node.procesed = true;
      node.visited = false;
      cacheForType = node;
    } else {
      checkConflictedScopes(parentNode, cacheForType);
    }

    if (cacheForType.visited) {
      throw InvalidGenerationSourceError(
          'circular dependency in graph in ${cacheForType.cache}');
    }

    parentNode.dependencies.add(cache);
  }

  void checkConflictedScopes(GraphNode parentNode, GraphNode node) {
    if (parentNode.scopeName != null && hasConflict(parentNode, node)) {
      throw InvalidGenerationSourceError(
          'scoped dependency of ${parentNode.cache} can depends on \'${parentNode.scopeName}\' scope or ROOT_SCOPE but is dependent on ${node.cache} with scope \'${node.scopeName}\'');
    }
  }

  bool hasConflict(GraphNode parentNode, GraphNode node) =>
      !(parentNode.scopeName == node.scopeName || node.scopeName == null);

  InjectorDs getSubDependency(DependencyCache cache) {
    final injector = cacheOfInjectors[cache];

    if (injector == null) {
      throw InvalidGenerationSourceError(
          'Injection for ${cache} can\'t be found');
    }

    return injector;
  }
}

class CircularDependencyException {}
