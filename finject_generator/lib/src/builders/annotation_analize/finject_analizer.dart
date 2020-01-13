import 'package:analyzer/dart/element/element.dart';

import '../../builders/code_info_extraction.dart';
import '../../json_schema/injector_Info.dart';

class Analizer {
  InjectorDs prepareInjectionDefinition(ClassElement classInfo) {
    InjectorDs injectionDefinition = InjectorDs();
    injectionDefinition.typeName = convert(classInfo);

    _attachConstructorInjection(injectionDefinition, classInfo.constructors);
    _attachFieldsInjections(injectionDefinition, classInfo.fields);
    _attachSuperClassInjections(injectionDefinition, classInfo);
    _attachMethodsInjection(injectionDefinition, classInfo.methods);
    injectionDefinition.prunRedundantInjections();
    injectionDefinition.margeDependencies();
    return injectionDefinition;
  }

  _attachConstructorInjection(
      InjectorDs injection, List<ConstructorElement> constructors) {
    _validateInjectConstructor(constructors);
    for (ConstructorElement element in constructors) {
      MethodInjection constructorInjection =
          _processParemetersOfCostructor(element.parameters);
      injection.constructorInjection = constructorInjection;
      break;
    }
  }

  MethodInjection _processParemetersOfCostructor(
      List<ParameterElement> parameters) {
    var constructorInjection = MethodInjection();
    for (ParameterElement element in parameters) {
      ClassElement classInfo = getType(element.type);
      if (element.isPositional) {
        constructorInjection.addOrderedParameter(
            convert(classInfo), findName(element.metadata));
      } else if (element.isOptionalPositional) {
        constructorInjection.addOrderedParameter(
            convert(classInfo), findName(element.metadata));
      } else if (element.isNamed) {
        constructorInjection.addNamedParameter(
            element.name, convert(classInfo), findName(element.metadata));
      }
      if (element.isInitializingFormal) {
        constructorInjection.blackList.add(element.name);
      }
    }
    return constructorInjection;
  }

  void _validateInjectConstructor(List<ConstructorElement> constructors) {
    int numberOfInjection = 0;
    for (ConstructorElement element in constructors) {
      if (hasAnnotation(element.metadata, "Inject")) {
        numberOfInjection++;
      }
      if (element.isDefaultConstructor) {
        return;
      }
      if (numberOfInjection > 1) {
        throw InjectorValidationError();
      }
    }
    if (numberOfInjection < 1 && constructors.length > 0) {
      throw InjectorValidationError();
    }
  }

  void _attachFieldsInjections(
      InjectorDs injection, List<FieldElement> fields) {
    for (FieldElement element in fields) {
      if (hasAnnotation(element.metadata, "Inject")) {
        ClassElement classInfo = element.type.element;
        injection.fieldInjection.addNamedParameter(
            element.name, convert(classInfo), findName(element.metadata));
      }
    }
  }

  void _attachSuperClassInjections(InjectorDs injection, ClassElement element) {
    if (element.supertype == null) {
      return;
    }

    ClassElement superTypeElement = element.supertype.element;

    for (FieldElement element in superTypeElement.fields) {
      if (hasAnnotation(element.metadata, "Inject")) {
        ClassElement classInfo = element.type.element;
        injection.fieldInjection.addNamedParameter(
            element.name, convert(classInfo), findName(element.metadata));
      }
    }

    _attachSuperClassInjections(injection, superTypeElement);
  }

  void _attachMethodsInjection(
      InjectorDs injector, List<MethodElement> methods) {}
}
