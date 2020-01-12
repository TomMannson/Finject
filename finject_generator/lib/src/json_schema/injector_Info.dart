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
      : typeName =
            getFromJson(json['typeName'], (value) => TypeInfo.fromJson(value)),
        scopeName = json['scopeName'],
        singleton = json['singleton'],
        name = json['name'],
        profiles = (json["profiles"] as Iterable)
            .map<String>((dynamic item) => item as String)
            .toSet(),
        factoryTypeName = getFromJson(
          json['factoryTypeName'],
          (value) => TypeInfo.fromJson(value),
        ),
        constructorInjection = getFromJson(
          json['constructorInjection'],
          (value) => MethodInjection.fromJson(value),
        ),
        fieldInjection = FieldInjection.fromJson(json['fieldInjection']),
        methodInjections = (json['methodInjections'] as Iterable)
            .map((item) => MethodInjection.fromJson(item))
            .toList(),
        dependencies = (json["dependencies"] as Iterable)
            .map<TypeInfo>((dynamic item) => TypeInfo.fromJson(item))
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
    for (String itemFromBlackList in this.constructorInjection.blackList) {
      this.fieldInjection.namedParameter.remove(itemFromBlackList);
    }
  }

  void margeDependencies() {
    this.dependencies
      ..addAll(this.constructorInjection.orderedParameters)
      ..addAll(this.constructorInjection.namedParameters.values.toList())
      ..addAll(this.setterInjection.namedParameter.values)
      ..addAll(this.fieldInjection.namedParameter.values);

    this.methodInjections.forEach((value) {
      this.dependencies.addAll(value.orderedParameters);
      this.dependencies.addAll(value.namedParameters.values);
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
      : name = json["name"],
        orderedParameters = (json['orderedParameters'] as Iterable)
            .map((item) => TypeInfo.fromJson(item))
            .toList(),
        namedParameters = (json['namedParameters'] as Map<String, dynamic>).map(
            (String key, dynamic value) =>
                MapEntry(key, TypeInfo.fromJson(value))),
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

  addOrderedParameter(TypeInfo type, [String name]) {
    orderedParameters.add(type);
    orderedNames.add(name);
  }

  addNamedParameter(String name, TypeInfo type, [String namedDependency]) {
    namedParameters[name] = type;
    namedNames[name] = namedDependency;
  }
}

class SetterInjection {
  Map<String, TypeInfo> namedParameter = {};
  Map<String, String> namedName = {};

  SetterInjection();

  SetterInjection.fromJson(Map<String, dynamic> json)
      : namedParameter = (json['namedParameters'] as Map<String, dynamic>)
            .map((key, value) => MapEntry(key, TypeInfo.fromJson(value))),
        namedName = (json['namedName'] as Map<String, dynamic>)
            .map((String key, dynamic value) => MapEntry(key, value as String));

  Map<String, dynamic> toJson() => {
        'namedParameter': namedParameter,
      };

  addNamedParameter(String name, TypeInfo type, [String namedDependency]) {
    namedParameter[name] = type;
    namedName[name] = namedDependency;
  }
}

class FieldInjection {
  Map<String, TypeInfo> namedParameter = {};
  Map<String, String> namedNames = {};

  FieldInjection();

  FieldInjection.fromJson(Map<String, dynamic> json)
      : namedParameter = (json['namedParameter'] as Map<String, dynamic>).map(
            (String key, dynamic value) =>
                MapEntry(key, TypeInfo.fromJson(value))),
        namedNames = (json['namedNames'] as Map<String, dynamic>)
            .map((String key, dynamic value) => MapEntry(key, value as String));

  addNamedParameter(String name, TypeInfo type, [String namedDependency]) {
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
  String libraryId;

  TypeInfo(this.packageName, this.libraryName, this.className, this.libraryId);

  TypeInfo.fromJson(Map<String, dynamic> json)
      : packageName = json['packageName'],
        libraryName = json['libraryName'],
        className = json["className"],
        libraryId = json["libraryId"];

  Map<String, dynamic> toJson() => {
        'packageName': packageName,
        'libraryName': libraryName,
        'className': className,
        'libraryId': libraryId
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TypeInfo &&
          runtimeType == other.runtimeType &&
          packageName == other.packageName &&
          libraryName == other.libraryName &&
          className == other.className &&
          libraryId == other.libraryId;

  @override
  int get hashCode =>
      packageName.hashCode ^
      libraryName.hashCode ^
      className.hashCode ^
      libraryId.hashCode;
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

typedef T Extractor<T>(dynamic value);
