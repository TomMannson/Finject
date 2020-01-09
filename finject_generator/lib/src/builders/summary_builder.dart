import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

class BuildSummary extends Builder {
  final List<Generator> _generators;
  final String _extension;

  BuildSummary(this._generators, [this._extension = '.summary.json']);

  @override
  Map<String, List<String>> get buildExtensions {
    return {
      ".dart": [_extension],
    };
  }

  @override
  Future<void> build(BuildStep buildStep) async {
    AssetId output = buildStep.inputId.changeExtension(_extension);
    final lib = await buildStep.inputLibrary;

    var createdUnit =
        await _generators[0].generate(LibraryReader(lib), buildStep);

    if (createdUnit.isNotEmpty) {
      buildStep.writeAsString(output, createdUnit);
    }
  }
}
