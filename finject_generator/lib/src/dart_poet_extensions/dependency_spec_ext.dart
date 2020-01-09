import 'package:dartpoet/dartpoet.dart';

class DependencySpecExt extends DependencySpec {
  String libraryId;

  DependencySpecExt.import(String route, this.libraryId)
      : super.import(route);

  @override
  String code({Map<String, dynamic> args = const {}}) {
    String result = super.code(args: args).replaceAll(";", "");
    return "$result as ${libraryId};";
  }
}
