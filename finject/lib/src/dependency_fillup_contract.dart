import '../finject.dart';

Map<String, Map> rootDependencyResolver = {};
late ScopeFactory defaultScopeFactory;

abstract class Injector<T> {
  void inject(T instance, InjectionProvider provider);
}

abstract class Factory<T> {
  T create(InjectionProvider provider);
}

class Scope {
  final _injectors = <Qualifier, Injector>{};
  final _factories = <Qualifier, Factory>{};

  Scope(List<ScopeEntry> list) {
    for (var entry in list) {
      if (entry is ScopeEntry<Injector>) {
        _injectors[entry.qualifier] = entry.element;
      } else if (entry is ScopeEntry<Factory>) {
        _factories[entry.qualifier] = entry.element;
      }
    }
  }

  Injector? injector(Qualifier type) {
    return _injectors[type];
  }

  Factory? factory(Qualifier type) {
    return _factories[type];
  }
}

abstract class ScopeFactory {
  Scope? createScope(String scopeName);
}

class ScopeEntry<T> {
  final Qualifier qualifier;
  final T element;

  ScopeEntry(this.qualifier, this.element);
}
