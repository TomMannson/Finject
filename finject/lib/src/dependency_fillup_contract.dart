
import '../finject.dart';

abstract class Injector<T> {

  inject(T instance, InjectionProvider provider);
}

abstract class Factory<T> {

  T create(InjectionProvider provider);

}

class Scope {

  Map<Qualifier, Injector> injectors = {};
  Map<Qualifier, Factory> factories = {};


  Scope(List<ScopeEntry> list){
    for(ScopeEntry entry in list){
      if(entry is ScopeEntry<Injector>){
        injectors[entry.qualifier] = entry.element;
      }
      else if(entry is ScopeEntry<Factory>){
        factories[entry.qualifier] = entry.element;
      }
    }
  }

  Injector injector(Type type){
    return injectors[type];
  }

  Factory factory(Type type){
    return factories[type];
  }
}

abstract class ScopeFactory {

  Scope createScope(String scopeName);

}

class ScopeEntry<T> {

  final Qualifier qualifier;
  final T element;

  ScopeEntry(this.qualifier, this.element);
}





