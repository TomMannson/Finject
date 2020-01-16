import 'package:analyzer/dart/element/element.dart';

import '../../builders/code_info_extraction.dart';
import '../../json_schema/injector_Info.dart';
import 'finject_analizer.dart';

class FinjectInjectableAnalizer extends Analizer {
  Iterable<InjectorDs> analize(Element element) {
    var injections = <InjectorDs>[];

    if (element is ClassElement) {
      var classInfo = element;
      var injectionDefinition = prepareInjectionDefinition(classInfo);

      injectionDefinition.singleton =
          hasAnnotation(classInfo.metadata, 'Singleton');

      for (var annotation in classInfo.metadata) {
        var annotationInfo = annotation.element as ConstructorElement;
        var annotationType = annotationInfo.enclosingElement;
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

    return injections;
  }

  void processMethod(List<MethodElement> methods) {}
}
