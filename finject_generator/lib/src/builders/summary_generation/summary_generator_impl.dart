import 'package:analyzer/dart/element/element.dart';
import 'package:finject_generator/src/builders/annotation_analize/finject_configuration_analizer.dart';
import 'package:finject_generator/src/builders/annotation_analize/finject_injectable_analizer.dart';
import 'package:finject_generator/src/json_schema/injector_Info.dart';

import 'summary_generator.dart';

class SummaryGeneratorImpl extends SummaryGenerator {
  FinjectConfigurationAnalizer configurationAnalyzer =
      FinjectConfigurationAnalizer();
  FinjectInjectableAnalizer injectorAnalyzer = FinjectInjectableAnalizer();

  @override
  Iterable<InjectorDs> processConfiguration(Element element) {
    return configurationAnalyzer.analize(element);
  }

  @override
  Iterable<InjectorDs> processInjectable(Element element) {
    // TODO: implement processInjectable
    return injectorAnalyzer.analize(element);
  }
}
