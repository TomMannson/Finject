/// Support for doing something awesome.
///
/// More dartdocs go here.
library dartpoet;

import 'package:dart_style/dart_style.dart';

export 'poet/class_spec.dart';
export 'poet/code_block_spec.dart';
export 'poet/dart_file.dart';
export 'poet/doc_spec.dart';
export 'poet/file_spec.dart';
export 'poet/meta_spec.dart';
export 'poet/method_spec.dart';
export 'poet/operator_spec.dart';
export 'poet/parameter_spec.dart';
export 'poet/property_spec.dart';
export 'poet/setter_getter_spec.dart';
export 'poet/spec.dart';
export 'package:type_token/type_token.dart';

const String KEY_WITH_BLOCK = 'with_block';
const String KEY_WITH_LAMBDA = 'with_lambda';
const String KEY_WITH_DEF_VALUE = 'with_def_value';
const String KEY_REVERSE_CLASSES = 'reverse_classes';

DartFormatter _formatter = DartFormatter();

String format(String source) => _formatter.format(source);
