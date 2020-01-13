import 'dart:async';
import 'dart:convert';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:finject/finject.dart';
import 'package:source_gen/source_gen.dart';

import '../../json_schema/injector_Info.dart';

abstract class SummaryGenerator extends Generator {
  const SummaryGenerator();

  TypeChecker get injectableChecker => TypeChecker.fromRuntime(Injectable);

  TypeChecker get configurationChecker =>
      TypeChecker.fromRuntime(Configuration);

  Iterable<InjectorDs> processInjectable(Element element);

  Iterable<InjectorDs> processConfiguration(Element element);

  @override
  FutureOr<String> generate(LibraryReader library, BuildStep buildStep) async {
    final values = <InjectorDs>[];

    for (var annotatedElement in library.annotatedWith(injectableChecker)) {
      values.addAll(processInjectable(annotatedElement.element));
    }

    for (var annotatedElement in library.annotatedWith(configurationChecker)) {
      values.addAll(processConfiguration(annotatedElement.element));
    }

    if (values.isNotEmpty) {
      return jsonEncode(values);
    }
    return "";
  }
}
