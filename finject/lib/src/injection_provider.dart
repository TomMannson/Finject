//import 'package:get_it/get_it.dart';

abstract class InjectionProvider {

  T get<T>([String name]);

  inject(Object target, [String name]);
}

class InjectionContext {

  Object context;

  InjectionContext(this.context);
}