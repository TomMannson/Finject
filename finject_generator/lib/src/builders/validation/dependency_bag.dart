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
    TypeInfo type = injectorDs.typeName;

    final cache = DependencyCache()
      ..name = injectorDs.name
      ..typeName = type;

    if (!duplicateDetector.add(cache)) {
      duplicates.add(cache);
      throw InvalidGenerationSourceError(
          "circular dependency in graph in ${cache}"); //if was not added we have duplicate so We need Error
    }

    cacheOfInjectors[cache] = injectorDs;
  }

  void process() {
    for (MapEntry<DependencyCache, InjectorDs> entry
        in cacheOfInjectors.entries) {
      GraphNode node = GraphNode();
      node.cache = entry.key;
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
    MethodInjection method = injectorDs.methodInjections[0];
    for (var index = 0; index < method.orderedParameters.length; index++) {
      TypeInfo typeInfo = method.orderedParameters[index];
      String name = method.orderedNames[index];
      processTypeWithName(typeInfo, name, parentNode);
    }
    for (var paramName in method.namedParameters.keys) {
      TypeInfo typeInfo = method.namedParameters[paramName];
      String name = method.namedNames[paramName];
      processTypeWithName(typeInfo, name, parentNode);
    }
  }

  void processConstructorInjection(
      InjectorDs injectorDs, GraphNode parentNode) {
    MethodInjection method = injectorDs.constructorInjection;
    for (var index = 0; index < method.orderedParameters.length; index++) {
      TypeInfo typeInfo = method.orderedParameters[index];
      String name = method.orderedNames[index];
      processTypeWithName(typeInfo, name, parentNode);
    }
    for (var paramName in method.namedParameters.keys) {
      TypeInfo typeInfo = method.namedParameters[paramName];
      String name = method.namedNames[paramName];
      processTypeWithName(typeInfo, name, parentNode);
    }
  }

  void processFieldInjection(InjectorDs injectorDs, GraphNode parentNode) {
    FieldInjection method = injectorDs.fieldInjection;
    for (var paramName in method.namedParameter.keys) {
      TypeInfo typeInfo = method.namedParameter[paramName];
      String name = method.namedNames[paramName];
      processTypeWithName(typeInfo, name, parentNode);
    }
  }

  void processTypeWithName(
      TypeInfo typeInfo, String name, GraphNode parentNode) {
    final cache = DependencyCache()
      ..typeName = typeInfo
      ..name = name;

    GraphNode cacheForType = bagCache[cache];

    if (cacheForType == null) {
      GraphNode node = GraphNode();
      node.cache = cache;
      node.visited = true;
      bagCache[cache] = node;
      processDependencies(getSubDependency(cache), node);
      node.procesed = true;
      node.visited = false;
      cacheForType = node;
    }

    if (cacheForType.visited) {
      throw InvalidGenerationSourceError(
          "circular dependency in graph in ${cacheForType.cache}");
    }

    parentNode.dependencies.add(cache);
  }

  InjectorDs getSubDependency(DependencyCache cache) {
    InjectorDs injector = cacheOfInjectors[cache];

    if (injector == null) {
      throw InvalidGenerationSourceError(
          'Injection for ${cache} can\'t be found');
    }

    return injector;
  }
}

class CircularDependencyException {}
