import '../dartpoet.dart';

class DocSpec implements Spec {
  String content;

  DocSpec.text(this.content);

  @override
  String code({Map<String, Object> args = const {}}) {
    return '/// $content';
  }
}

String collectWithDoc(DocSpec doc, String raw) {
  if (doc == null) return raw;
  return '${doc.code()}\n$raw';
}
