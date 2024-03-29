// import 'dart_poet.dart';
import '../dartpoet.dart';

class DependencySpecExt extends DependencySpec {
  String libraryId;

  DependencySpecExt.import(String route, this.libraryId) : super.import(route);

  @override
  String code({Map<String, Object> args = const {}}) {
    if (!route.contains('dart:core')) {
      var result = super.code(args: args).replaceAll(';', '');
      return '$result as $libraryId;';
    } else {
      return super.code(args: args);
    }
  }
}
