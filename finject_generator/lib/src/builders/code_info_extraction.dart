import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:finject_generator/src/json_schema/injector_Info.dart';
import 'package:source_gen/source_gen.dart';

Map<String, int> knownLibraries = {};
int currentLibraryNumber = 0;

String findName(List<ElementAnnotation> annotations) {
  for (var annotation in annotations) {
    var annotationInfo = annotation.element as ConstructorElement;
    var annotationType = annotationInfo.enclosingElement;
    if (annotationType.name == 'Named') {
      var result = annotation.computeConstantValue();
      return result.getField('name').toStringValue();
    }
  }
  return null;
}

String generateIdForLibrary(TypeInfo typeInfo) {
  var libraryId = 0;
  if (!knownLibraries.containsKey(typeInfo.libraryName)) {
    currentLibraryNumber++;
    knownLibraries[typeInfo.libraryName] = currentLibraryNumber;
  }
  libraryId = knownLibraries[typeInfo.libraryName];
  return 'id$libraryId';
}

TypeInfo convert(ClassElement element) {
  if (element == null) {
    throw InvalidGenerationSourceError(
        'Unknown type found, no import or something. Find compilation error',
        todo:
            'Unknown type found, no import or something. Find compilation error');
  }
  final uriOfClass = element.librarySource.uri;
  return TypeInfo(uriOfClass.scheme, uriOfClass.path, element.name);
}

ClassElement getType(DartType type) {
  final element = type.element;
  if (element is ClassElement) {
    return element;
  }
  return null;
}

bool hasAnnotation(List<ElementAnnotation> metadata, String type) {
  for (var annotation in metadata) {
    var annotationInfo = annotation.element as ConstructorElement;
    var classInfo = annotationInfo.enclosingElement;
    if (classInfo.name == type) {
      return true;
    }
  }
  return false;
}

class InjectorValidationError extends Error {}
