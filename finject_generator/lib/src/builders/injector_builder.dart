import 'dart:convert';

import 'package:build/build.dart';
import 'package:dartpoet/dartpoet.dart';


import '../json_schema/injector_Info.dart';
import 'build_utils.dart';

class InjectorBuilder extends Builder {
  InjectorBuilder();

  @override
  Map<String, List<String>> get buildExtensions {
    return const {
      ".summary.json": const ['.injector.dart'],
    };
  }

  @override
  Future<void> build(BuildStep buildStep) async {
//    AssetId output = changeExtension(buildStep.inputId, '.injector.dart');
////    AssetId output = buildStep.inputId.changeExtension('.injector.dart');
//    String injectorJson = await buildStep.readAsString(buildStep.inputId);
//
//    List<InjectorDs> input = (jsonDecode(injectorJson) as Iterable)
//        .map((value) => InjectorDs.fromJson(value))
//        .toList();
//
//    InjectorDs readData = input[0];
//
//    FileSpec fileSpec = FileSpec.build(
//      dependencies: [...generateImportSpec(readData)],
//      classes: [
//        ClassSpec.build(
//          readData.typeName.className + "_Injector",
//          superClass: TypeToken.ofFullName(
//            "Injector<${readData.typeName.className}>",
//          ),
//          doc: DocSpec.text(
//              'this is injector for ' + readData.typeName.className + ' class'),
//          methods: [
//            MethodSpec.build(
//              'inject',
//              parameters: [
//                ParameterSpec.build(
//                  "instance",
//                  type: TypeToken.ofFullName(
//                    readData.typeName.className,
//                  ),
//                ),
//                ParameterSpec.normal("injectionProvider",
//                    type: TypeToken.ofFullName("InjectionProvider")),
//              ],
//              codeBlock: generateCodeForInjector(readData),
//            ),
//          ],
//        ),
//        ClassSpec.build(
//          readData.typeName.className + "_Factory",
////          metas: [MetaSpec.of('Object()')],
//          doc: DocSpec.text(
//              'this is factory for ' + readData.typeName.className + ' class'),
//          superClass:
//          TypeToken.ofFullName("Factory<${readData.typeName.className}>"),
//          methods: [
//            MethodSpec.build(
//              'create',
//              returnType: TypeToken.ofFullName(readData.typeName.className),
//              parameters: [
//                ParameterSpec.normal("injectionProvider",
//                    type: TypeToken.ofFullName("InjectionProvider")),
//              ],
//              codeBlock: generateCodeForFactory(readData),
//            ),
//          ],
//        ),
//      ],
//    );
//
//    DartFile dartFile = DartFile.fromFileSpec(fileSpec);
//
////    final output = _allFileOutput(buildStep);
//    return buildStep.writeAsString(output, dartFile.outputContent());
  }

  CodeBlockSpec generateCodeForFactory(InjectorDs ds) {
    var lines = List<String>();
    lines.add("return " + ds.typeName.className + "(");

    for (TypeInfo type in ds.constructorInjection.orderedParameters) {
      lines.add("injectionProvider.get(),");
    }

    ds.constructorInjection.namedParameters.forEach((key, value) {
      lines.add(key + ": injectionProvider.get(),");
    });

    lines.add(");");

    return CodeBlockSpec.lines(lines);
  }

  CodeBlockSpec generateCodeForInjector(InjectorDs ds) {
    var lines = List<String>();

    ds.fieldInjection.namedParameter.forEach((key, value) {
      lines.add("instance." + key + " = injectionProvider.get();");
    });

    if (lines.length == 0) {
      return CodeBlockSpec.lines(["//no injection", "//no injection"]);
    }

    return CodeBlockSpec.lines(lines);
  }
}