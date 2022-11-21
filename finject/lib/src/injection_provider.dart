//import 'package:get_it/get_it.dart';

abstract class InjectionProvider {
  T get<T>([String? name]);

  void inject(Object target, [String? name]);
}

class ScopedObject {}

abstract class DisposableScopedObject implements ScopedObject {
  void onDispose();
}
