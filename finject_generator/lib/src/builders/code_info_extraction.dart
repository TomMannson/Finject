import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:finject_generator/src/json_schema/injector_Info.dart';

Map<String, int> knownLibraries = {};
int currentLibraryNumber = 0;

String findName(List<ElementAnnotation> annotations) {
  for (ElementAnnotation annotation in annotations) {
    ConstructorElement annotationInfo = annotation.element as ConstructorElement;
    ClassElement annotationType = annotationInfo.enclosingElement;
    if (annotationType.name == 'Named') {
      var result = annotation.computeConstantValue();
      return result.getField('name').toStringValue();
    }
  }
  return null;
}

TypeInfo convert(ClassElement element) {
  if (element == null) {
    throw InjectorValidationError();
  }
  Uri uriOfClass = element.librarySource.uri;
  int libraryId = 0;
  if (!knownLibraries.containsKey(uriOfClass.path)) {
    currentLibraryNumber++;
    knownLibraries[uriOfClass.path] = currentLibraryNumber;
  }
  libraryId = knownLibraries[uriOfClass.path];

  return TypeInfo(
      uriOfClass.scheme, uriOfClass.path, element.name, 'id$libraryId');
}

ClassElement getType(DartType type) {
  final element = type.element;
  if (element is ClassElement) {
    return element;
  }
  return null;
}

bool hasAnnotation(List<ElementAnnotation> metadata, String type) {
  for (ElementAnnotation annotation in metadata) {
    ConstructorElement annotationInfo = annotation.element as ConstructorElement;
    ClassElement classInfo = annotationInfo.enclosingElement;
    if (classInfo.name == type) {
      return true;
    }
  }
  return false;
}

class InjectorValidationError extends Error {}
