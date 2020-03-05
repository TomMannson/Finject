import 'dart:core';

import 'package:collection/collection.dart';

class GraphInfo {
  List<GraphInfo> nodeList;
}

class GraphNode {
  DependencyCache cache;
  bool visited;
  bool procesed;

  EqualitySet<DependencyCache> dependencies = EqualitySet(DefaultEquality());
}

class DependencyCache {
  TypeInfo typeName;
  String name;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DependencyCache &&
          runtimeType == other.runtimeType &&
          typeName == other.typeName &&
          name == other.name;

  @override
  int get hashCode => 0;

  @override
  String toString() {
    return 'DependencyCache{typeName: $typeName, name: ${name ?? '<no_name>'}';
  }
}

class InjectorDs {
  TypeInfo typeName;
  TypeInfo factoryTypeName;
  SubGenericInfo subGenericInfo;
  bool singleton = false;
  String scopeName;
  String name;
  Set<String> profiles = {};
  MethodInjection constructorInjection;
  SetterInjection setterInjection = SetterInjection();
  FieldInjection fieldInjection = FieldInjection();
  List<MethodInjection> methodInjections = [];

//  MethodInjection methodInjection = MethodInjection();
  Set<TypeInfo> dependencies = {};

  InjectorDs();

  InjectorDs.fromJson(Map<String, dynamic> json)
      : typeName = getFromJson(
            json['typeName'],
            (dynamic value) =>
                TypeInfo.fromJson(value as Map<String, dynamic>)),
        scopeName = json['scopeName'] as String,
        singleton = json['singleton'] as bool,
        name = json['name'] as String,
        profiles = (json['profiles'] as Iterable)
            .map<String>((dynamic item) => item as String)
            .toSet(),
        factoryTypeName = getFromJson(
          json['factoryTypeName'],
          (value) => TypeInfo.fromJson(value as Map<String, dynamic>),
        ),
        constructorInjection = getFromJson(
          json['constructorInjection'],
          (value) => MethodInjection.fromJson(value as Map<String, dynamic>),
        ),
        fieldInjection = FieldInjection.fromJson(
            json['fieldInjection'] as Map<String, dynamic>),
        methodInjections = (json['methodInjections'] as Iterable)
            .map((item) =>
                MethodInjection.fromJson(item as Map<String, dynamic>))
            .toList(),
        dependencies = (json['dependencies'] as Iterable)
            .map<TypeInfo>((dynamic item) =>
                TypeInfo.fromJson(item as Map<String, dynamic>))
            .toSet();

  Map<String, dynamic> toJson() => {
        'typeName': typeName?.toJson(),
        'singleton': singleton,
        'scopeName': scopeName,
        'name': name,
        'profiles': profiles.toList(),
        'factoryTypeName': factoryTypeName?.toJson(),
        'constructorInjection': constructorInjection?.toJson(),
        'setterInjection': setterInjection?.toJson(),
        'fieldInjection': fieldInjection?.toJson(),
        'methodInjections': methodInjections,
        'dependencies': dependencies.toList()
      };

  void prunRedundantInjections() {
    for (var itemFromBlackList in constructorInjection.blackList) {
      fieldInjection.namedParameter.remove(itemFromBlackList);
    }
  }

  void margeDependencies() {
    if (factoryTypeName == null) {
      dependencies
        ..addAll(constructorInjection.orderedParameters)
        ..addAll(constructorInjection.namedParameters.values.toList());
    }
    dependencies..addAll(fieldInjection.namedParameter.values);

    methodInjections.forEach((value) {
      dependencies.addAll(value.orderedParameters);
      dependencies.addAll(value.namedParameters.values);
    });
  }
}

class SubGenericInfo {
  List<GenericType> genericityInfo = [];
}

class GenericType {
  TypeInfo typeInfo;
  SubGenericInfo subGenericInfo;
}

class MethodInjection {
  String name;
  List<TypeInfo> orderedParameters = [];
  Map<String, TypeInfo> namedParameters = {};
  List<String> blackList = [];
  List<String> orderedNames = [];
  Map<String, String> namedNames = {};

  MethodInjection();

  MethodInjection.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String,
        orderedParameters = (json['orderedParameters'] as Iterable)
            .map((item) => TypeInfo.fromJson(item as Map<String, dynamic>))
            .toList(),
        namedParameters = (json['namedParameters'] as Map<String, dynamic>).map(
            (String key, dynamic value) => MapEntry(
                key, TypeInfo.fromJson(value as Map<String, dynamic>))),
        blackList = (json['blackList'] as Iterable)
            .map((dynamic value) => value as String)
            .toList(),
        orderedNames = (json['orderedNames'] as Iterable)
            .map((dynamic value) => value as String)
            .toList(),
        namedNames = (json['namedNames'] as Map<String, dynamic>)
            .map((String key, dynamic value) => MapEntry(key, value as String));

  Map<String, dynamic> toJson() => {
        'name': name,
        'orderedParameters': orderedParameters,
        'namedParameters': namedParameters,
        'blackList': blackList,
        'orderedNames': orderedNames,
        'namedNames': namedNames,
      };

  void addOrderedParameter(TypeInfo type, [String name]) {
    orderedParameters.add(type);
    orderedNames.add(name);
  }

  void addNamedParameter(String name, TypeInfo type, [String namedDependency]) {
    namedParameters[name] = type;
    namedNames[name] = namedDependency;
  }
}

class SetterInjection {
  Map<String, TypeInfo> namedParameter = {};
  Map<String, String> namedName = {};

  Map<String, dynamic> toJson() => {
        'namedParameter': namedParameter,
      };
}

class FieldInjection {
  Map<String, TypeInfo> namedParameter = {};
  Map<String, String> namedNames = {};

  FieldInjection();

  FieldInjection.fromJson(Map<String, dynamic> json)
      : namedParameter = (json['namedParameter'] as Map<String, dynamic>).map(
            (String key, dynamic value) => MapEntry(
                key, TypeInfo.fromJson(value as Map<String, dynamic>))),
        namedNames = (json['namedNames'] as Map<String, dynamic>)
            .map((String key, dynamic value) => MapEntry(key, value as String));

  void addNamedParameter(String name, TypeInfo type, [String namedDependency]) {
    namedParameter[name] = type;
    namedNames[name] = namedDependency;
  }

  Map<String, dynamic> toJson() => {
        'namedParameter': namedParameter,
        'namedNames': namedNames,
      };
}

class TypeInfo {
  String packageName;
  String libraryName;
  String className;

  TypeInfo(this.packageName, this.libraryName, this.className);

  TypeInfo.fromJson(Map<String, dynamic> json)
      : packageName = json['packageName'] as String,
        libraryName = json['libraryName'] as String,
        className = json['className'] as String;

  Map<String, dynamic> toJson() => {
        'packageName': packageName,
        'libraryName': libraryName,
        'className': className,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TypeInfo &&
          runtimeType == other.runtimeType &&
          packageName == other.packageName &&
          libraryName == other.libraryName &&
          className == other.className;

  @override
  int get hashCode =>
      packageName.hashCode ^ libraryName.hashCode ^ className.hashCode;

  @override
  String toString() {
    return '$packageName:$libraryName/$className}';
  }
}

class DependencyInfo {
  TypeInfo info;
}

T getFromJson<T>(dynamic input, Extractor<T> extractor) {
  if (input == null) {
    return null;
  } else {
    return extractor(input);
  }
}

typedef Extractor<T> = T Function(dynamic value);
