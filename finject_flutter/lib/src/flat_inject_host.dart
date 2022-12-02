import 'package:finject/finject.dart';
import 'package:flutter/material.dart';

class JustInjectHost extends StatelessWidget {
  final Widget child;
  final JustInjectionProviderImpl _provider;

  @protected
  JustInjectHost({required this.child})
      : _provider = JustInjectionProviderImpl();

  @override
  Widget build(BuildContext context) {
    _provider.inject(child);
    return child;
  }
}

class JustInjectionProviderImpl extends InjectionProvider {
  JustInjectionProviderImpl();

  @override
  T get<T>([String? name]) {
    T value;
    var qualifier = QualifierFactory.create(T, name);

    var factory = rootDependencyResolver['factory']![qualifier] as Factory?;
    if (factory != null) {
      value = factory.create(this) as T;
      rootDependencyResolver['injector']![qualifier].inject(value, this);
      return value;
    }

    throw "value not found";
    // return null;
  }

  @override
  void inject(Object target, [String? name]) {
    var qualifier = QualifierFactory.create(target.runtimeType, name);

    var injector = rootDependencyResolver['injector']![qualifier] as Injector?;
    if (injector != null) {
      injector.inject(target, this);
    }
  }
}
