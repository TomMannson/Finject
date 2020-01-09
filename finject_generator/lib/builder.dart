import 'package:build/build.dart';
import 'package:finject_generator/src/builders/code_info_extraction.dart';
import 'package:finject_generator/src/builders/summary_builder.dart';

import 'src/builders/di_code_builder.dart';
import 'src/builders/summary_generation/summary_generator_impl.dart';

Builder summaryBuilder(BuilderOptions options) {
  knownLibraries = {};
  currentLibraryNumber = 0;
  return BuildSummary([SummaryGeneratorImpl()]);
}

Builder mapperBuilder(BuilderOptions options) {
  return DiCodeBuilder();
}
