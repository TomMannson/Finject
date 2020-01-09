class Qualifier{}

class NamedQualifier implements Qualifier{

  final Type type;
  final String name;

  const NamedQualifier(this.type, this.name);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is NamedQualifier &&
              runtimeType == other.runtimeType &&
              type == other.type &&
              name == other.name;

  @override
  int get hashCode =>
      type.hashCode ^
      name.hashCode;
}

class TypeQualifier implements Qualifier{

  final Type type;

  const TypeQualifier(this.type);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is TypeQualifier &&
              runtimeType == other.runtimeType &&
              type == other.type;

  @override
  int get hashCode => type.hashCode;
}

class QualifierFactory{

  static Qualifier create(Type type, String name){
    if(name != null){
      return NamedQualifier(type, name);
    }
    else{
      return TypeQualifier(type);
    }
  }

}
