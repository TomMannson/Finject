import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';

import '../../builders/code_info_extraction.dart';
import '../../json_schema/injector_Info.dart';

class Analizer {
  InjectorDs prepareInjectionDefinition(ClassElement classInfo) {
    var injectionDefinition = InjectorDs();

    if (classInfo.isPrivate) {
      throw throw InvalidGenerationSourceError(
          'Class which is @Injectable can\'t be  private',
          todo: 'Consider deleting one or more @Inject annotation:\n\n',
          element: classInfo);
    }

    injectionDefinition.typeName = convert(classInfo);

    _attachConstructorInjection(injectionDefinition, classInfo.constructors);
    _attachFieldsInjections(
        injectionDefinition, classInfo.fields, classInfo.accessors);
    _attachSuperClassInjections(injectionDefinition, classInfo);
    _attachMethodsInjection(injectionDefinition, classInfo.methods);
    injectionDefinition.prunRedundantInjections();
    injectionDefinition.margeDependencies();
    return injectionDefinition;
  }

  void _attachConstructorInjection(
      InjectorDs injection, List<ConstructorElement> constructors) {
    _validateInjectConstructor(constructors);
    for (var element in constructors) {
      var constructorInjection =
          _processParemetersOfCostructor(element.parameters);
      if (element.name.isNotEmpty) {
        constructorInjection.name = element.name;
      }
      injection.constructorInjection = constructorInjection;
      break;
    }
  }

  MethodInjection _processParemetersOfCostructor(
      List<ParameterElement> parameters) {
    var constructorInjection = MethodInjection();
    for (var element in parameters) {
      var classInfo = getType(element.type);
      if (element.isPositional) {
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
    var numberOfInjection = 0;
    for (var element in constructors) {
      if (hasAnnotation(element.metadata, 'Inject')) {
        numberOfInjection++;
      }
      if (element.isDefaultConstructor) {
        return;
      }
      if (numberOfInjection > 1) {
        throw InvalidGenerationSourceError(
            'Class should have exacly one constructor with inject annotation',
            todo: 'Consider deleting one or more @Inject annotation:\n\n',
            element: constructors[0].enclosingElement);
      }
    }
    if (numberOfInjection < 1 && constructors.length > 1) {
      throw InvalidGenerationSourceError(
          'No constructor found with annotation @Inject',
          todo: 'Consider adding one to existing constructor:\n\n',
          element: constructors[0].enclosingElement);
    }
  }

  void _attachFieldsInjections(InjectorDs injection, List<FieldElement> fields,
      List<PropertyAccessorElement> accessors) {
    for (var element in fields) {
      if (hasAnnotation(element.metadata, 'Inject')) {
        var classInfo = element.type.element as ClassElement;
        injection.fieldInjection.addNamedParameter(
            element.name, convert(classInfo), findName(element.metadata));
      }
    }
    for (var element in accessors) {
      if (element.isSetter && hasAnnotation(element.metadata, 'Inject')) {
        var function = element.type.element as PropertyAccessorElement;
        var classInfo = function.parameters[0].type.element as ClassElement;
        injection.fieldInjection.addNamedParameter(
            element.name, convert(classInfo), findName(element.metadata));
      }
    }
  }

  void _attachSuperClassInjections(InjectorDs injection, ClassElement element) {
    if (element.supertype == null) {
      return;
    }

    var superTypeElement = element.supertype.element;

    for (var element in superTypeElement.fields) {
      if (hasAnnotation(element.metadata, 'Inject')) {
        var classInfo = element.type.element as ClassElement;
        injection.fieldInjection.addNamedParameter(
            element.name, convert(classInfo), findName(element.metadata));
      }
    }

    _attachSuperClassInjections(injection, superTypeElement);
  }

  void _attachMethodsInjection(
      InjectorDs injector, List<MethodElement> methods) {}
}
