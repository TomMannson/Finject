import 'package:analyzer/dart/element/element.dart';

import '../../builders/code_info_extraction.dart';
import '../../json_schema/injector_Info.dart';
import 'finject_analizer.dart';

class FinjectConfigurationAnalizer extends Analizer {
  Iterable<InjectorDs> analize(Element element) {
    List<InjectorDs> injections = [];
    if (element is ClassElement) {
      ClassElement classInfo = element;
      InjectorDs injectionDefinition = prepareInjectionDefinition(classInfo);

      injectionDefinition.singleton = true;

      injections.add(injectionDefinition);

      for (MethodElement method in classInfo.methods) {
        if (method.isPrivate) {
          continue;
        }

        injectionDefinition = InjectorDs();
        injectionDefinition.typeName = convert(method.returnType.element as ClassElement);
        injectionDefinition.factoryTypeName = convert(classInfo);

        attachFactoryMethod(injectionDefinition, method);

        injectionDefinition.singleton =
            hasAnnotation(method.metadata, 'Singleton');

        for (ElementAnnotation annotation in method.metadata) {
          ConstructorElement annotationInfo = annotation.element as ConstructorElement;
          ClassElement annotationType = annotationInfo.enclosingElement;

          if (annotationType.name == 'Scoped') {
            var result = annotation.computeConstantValue();
            injectionDefinition.scopeName =
                result.getField('name').toStringValue();
          }
          if (annotationType.name == 'Named') {
            var result = annotation.computeConstantValue();
            injectionDefinition.name = result.getField('name').toStringValue();
          }
        }

        injections.add(injectionDefinition);
      }
    }

    return injections;
  }

  void attachFactoryMethod(InjectorDs injection, MethodElement method) {
    var methodInjection = MethodInjection();
    methodInjection.name = method.name;
    for (ParameterElement element in method.parameters) {
      ClassElement classInfo = getType(element.type);
      if (element.isPositional) {
        methodInjection.addOrderedParameter(
            convert(classInfo), findName(method.metadata));
      } else if (element.isOptionalPositional) {
        methodInjection.addOrderedParameter(
            convert(classInfo), findName(method.metadata));
      } else if (element.isNamed) {
        methodInjection.addNamedParameter(
            element.name, convert(classInfo), findName(method.metadata));
      }
      if (element.isInitializingFormal) {
        methodInjection.blackList.add(element.name);
      }
    }
    injection.methodInjections.add(methodInjection);
  }
}
