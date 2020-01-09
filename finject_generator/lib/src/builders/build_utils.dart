import 'package:build/build.dart';
import 'package:dartpoet/dartpoet.dart';
import 'package:finject_generator/src/dart_poet_extensions/dependency_spec_ext.dart';
import 'package:path/path.dart' as p;

import '../json_schema/injector_Info.dart';

Iterable<DependencySpec> generateImportSpec(InjectorDs ds) sync* {
  yield DependencySpec.import(
      ds.typeName.packageName + ":" + ds.typeName.libraryName);
  yield DependencySpec.import("package:finject/finject.dart");

  for (TypeInfo info in ds.dependencies) {
    yield DependencySpecExt.import(libraryPath(info), info.libraryId);
  }
}

Iterable<DependencySpec> generateImport(List<InjectorDs> allTypes) sync* {
  yield DependencySpec.import("package:finject/finject.dart");
  for (InjectorDs injectable in allTypes) {
    TypeInfo info = injectable.typeName;
    yield DependencySpecExt.import(libraryPath(info), info.libraryId);
  }
}

AssetId changeExtension(AssetId assetId, String newExtension) => AssetId(
    assetId.package,
    p.withoutExtension(p.withoutExtension(assetId.path)) + newExtension);

CodeBlockSpec generateCodeForFactory(InjectorDs ds) {
  var lines = List<String>();

  if (ds.singleton) {
    lines.add("if(cache != null){");
    lines.add("return cache;");
    lines.add("}");
  }

  if (ds.factoryTypeName != null) {
    lines.add(
        "${generateTypeFromTypeInfo(ds.factoryTypeName)} factory = injectionProvider.get();");
    lines.add("var value = factory.${ds.methodInjections[0].name}(");

    for (int i = 0; i < ds.methodInjections[0].orderedParameters.length; i++) {
      lines.add(
          "injectionProvider.get(${injectNamedIndicator(ds.methodInjections[0].orderedNames[i])}),");
    }

    ds.methodInjections[0].namedParameters.forEach((key, value) {
      lines.add(key +
          ": injectionProvider.get(${injectNamedIndicator(ds.methodInjections[0].namedNames[key])}),");
    });

    lines.add(");");
  } else {
    lines.add("var value = " + generateTypeFromTypeInfo(ds.typeName) + "(");

    for (int i = 0; i < ds.constructorInjection.orderedParameters.length; i++) {
      lines.add(
          "injectionProvider.get(${injectNamedIndicator(ds.constructorInjection.orderedNames[i])}),");
    }

    ds.constructorInjection.namedParameters.forEach((key, value) {
      lines.add(key +
          ": injectionProvider.get(${injectNamedIndicator(ds.methodInjections[0].namedNames[key])}),");
    });

    lines.add(");");
  }

  if (ds.singleton) {
    lines.add("cache = value;");
  }

  lines.add("return value;");

  return CodeBlockSpec.lines(lines);
}

CodeBlockSpec generateCodeForInjector(InjectorDs ds) {
  var lines = List<String>();

  if (ds.singleton) {
    lines.add("if(cache){");
    lines.add("return;");
    lines.add("}");
  }

  ds.fieldInjection.namedParameter.forEach((key, value) {
    lines.add(
        "instance.$key = injectionProvider.get(${injectNamedIndicator(ds.fieldInjection.namedNames[key])});");
  });

  if (ds.singleton) {
    lines.add("cache = true;");
  }

  if (lines.length == 0) {
    return CodeBlockSpec.lines(["//no injection", "//no injection"]);
  }

  return CodeBlockSpec.lines(lines);
}

String injectNamedIndicator(String name) {
  if (name == null) {
    return "";
  } else {
    return "\"$name\"";
  }
}

CodeBlockSpec generateCodeForMappers(List<InjectorDs> allTypes) {
  var lines = List<String>();

  lines.add("defaultScopeFactory = ScopeFactoryImpl();");
  lines.add("injectorMapper.clear();");
  lines.add("factoryMapper.clear();");

  for (InjectorDs injector in allTypes) {
    if (injector.scopeName != null) {
      continue;
    }
    TypeInfo type = injector.typeName;
    lines.add(
        "injectorMapper[${generateKeyForInjector(injector)}] = ${generatePrefixClassName(injector)}_Injector();");
    lines.add(
        "factoryMapper[${generateKeyForInjector(injector)}] = ${generatePrefixClassName(injector)}_Factory();");
  }

  lines.add(
      "rootDependencyResolver = {\"injector\": injectorMapper, \"factory\": factoryMapper};");

  return CodeBlockSpec.lines(lines);
}

String generatePrefixClassName(InjectorDs data) {
  StringBuffer buffer = new StringBuffer(data.typeName.className);

  buffer.write("_${data.typeName.libraryId}");

  if (data.name != null) {
    buffer
        .write("NAME\$${Uri.encodeComponent(data.name).replaceAll("%", "__")}");
  }

  if (data.scopeName != null) {
    buffer.write(
        "SCOPE\$${Uri.encodeComponent(data.scopeName).replaceAll("%", "__")}");
  }
  return buffer.toString();
}

String generateKeyForInjector(InjectorDs data) {
  if (data.name != null) {
    return "NamedQualifier(${generateTypeFromTypeInfo(data.typeName)}, \"${data.name}\")";
  } else {
    return "TypeQualifier(${generateTypeFromTypeInfo(data.typeName)})";
  }
}

String libraryPath(TypeInfo typeInfo) {
  return "${typeInfo.packageName}:${typeInfo.libraryName}";
}

String generateTypeFromTypeInfo(TypeInfo typeInfo) {
  return "${typeInfo.libraryId}.${typeInfo.className}";
}
