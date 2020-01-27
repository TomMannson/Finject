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

      injections.add(injectionDefinition);
    }

    return injections;
  }
}
