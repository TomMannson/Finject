import 'package:finject/finject.dart';
import 'package:example/my_feed/my_feed_page.dart' as id1;
import 'package:example/my_feed/my_feed_bloc.dart' as id2;
import 'package:example/auth/login_screen.dart' as id3;
import 'package:example/auth/auth_bloc.dart' as id4;
import 'package:example/infrastructure/auth_service.dart' as id5;
import 'package:example/infrastructure/auth_service.dart' as id5;
import 'package:example/infrastructure/auth_service.dart' as id5;
import 'package:example/auth/auth_cache.dart' as id6;

Map<Qualifier, Injector> injectorMapper = {};
Map<Qualifier, Factory> factoryMapper = {};

class ScopeFactoryImpl extends ScopeFactory {
  Scope createScope(String scopeName) {
    if (scopeName == 'screen') {
      return Scope([
        ScopeEntry<Injector>(const TypeQualifier(id6.AuthCache),
            AuthCache_id6SCOPE$screen_Injector()),
        ScopeEntry<Factory>(const TypeQualifier(id6.AuthCache),
            AuthCache_id6SCOPE$screen_Factory()),
      ]);
    }
//default value
    return null;
  }
}

/// this is factory for id6.AuthCache class
class AuthCache_id6SCOPE$screen_Factory extends Factory<id6.AuthCache> {
  id6.AuthCache create(InjectionProvider injectionProvider) {
    id5.AuthConfiguration factory = injectionProvider.get();
    var value = factory.createAuthCache(
      injectionProvider.get(),
    );
    return value;
  }
}

/// this is injector for AuthCache class
class AuthCache_id6SCOPE$screen_Injector extends Injector<id6.AuthCache> {
  void inject(id6.AuthCache instance, InjectionProvider injectionProvider) {
//no injection
//no injection
  }
}

/// this is factory for id5.AuthService class
class AuthService_id5_Factory extends Factory<id5.AuthService> {
  id5.AuthService create(InjectionProvider injectionProvider) {
    id5.AuthConfiguration factory = injectionProvider.get();
    var value = factory.createAuthTest(
      injectionProvider.get(),
    );
    return value;
  }
}

/// this is injector for AuthService class
class AuthService_id5_Injector extends Injector<id5.AuthService> {
  void inject(id5.AuthService instance, InjectionProvider injectionProvider) {
//no injection
//no injection
  }
}

/// this is factory for id5.AuthConfiguration class
class AuthConfiguration_id5_Factory extends Factory<id5.AuthConfiguration> {
  id5.AuthConfiguration cache;

  id5.AuthConfiguration create(InjectionProvider injectionProvider) {
    if (cache != null) {
      return cache;
    }
    var value = id5.AuthConfiguration();
    cache = value;
    return value;
  }
}

/// this is injector for AuthConfiguration class
class AuthConfiguration_id5_Injector extends Injector<id5.AuthConfiguration> {
  bool cache = false;

  void inject(
      id5.AuthConfiguration instance, InjectionProvider injectionProvider) {
    if (cache) {
      return;
    }
    cache = true;
  }
}

/// this is factory for id5.SessionService class
class SessionService_id5_Factory extends Factory<id5.SessionService> {
  id5.SessionService cache;

  id5.SessionService create(InjectionProvider injectionProvider) {
    if (cache != null) {
      return cache;
    }
    var value = id5.SessionService();
    cache = value;
    return value;
  }
}

/// this is injector for SessionService class
class SessionService_id5_Injector extends Injector<id5.SessionService> {
  bool cache = false;

  void inject(
      id5.SessionService instance, InjectionProvider injectionProvider) {
    if (cache) {
      return;
    }
    cache = true;
  }
}

/// this is factory for id4.AuthBloc class
class AuthBloc_id4_Factory extends Factory<id4.AuthBloc> {
  id4.AuthBloc create(InjectionProvider injectionProvider) {
    var value = id4.AuthBloc(
      injectionProvider.get(),
    );
    return value;
  }
}

/// this is injector for AuthBloc class
class AuthBloc_id4_Injector extends Injector<id4.AuthBloc> {
  void inject(id4.AuthBloc instance, InjectionProvider injectionProvider) {
//no injection
//no injection
  }
}

/// this is factory for id3.LoginScreenState class
class LoginScreenState_id3_Factory extends Factory<id3.LoginScreenState> {
  id3.LoginScreenState create(InjectionProvider injectionProvider) {
    var value = id3.LoginScreenState();
    return value;
  }
}

/// this is injector for LoginScreenState class
class LoginScreenState_id3_Injector extends Injector<id3.LoginScreenState> {
  void inject(
          id3.LoginScreenState instance, InjectionProvider injectionProvider) =>
      instance.bloc = injectionProvider.get();
}

/// this is factory for id2.MyFeedBloc class
class MyFeedBloc_id2_Factory extends Factory<id2.MyFeedBloc> {
  id2.MyFeedBloc create(InjectionProvider injectionProvider) {
    var value = id2.MyFeedBloc();
    return value;
  }
}

/// this is injector for MyFeedBloc class
class MyFeedBloc_id2_Injector extends Injector<id2.MyFeedBloc> {
  void inject(id2.MyFeedBloc instance, InjectionProvider injectionProvider) {
//no injection
//no injection
  }
}

/// this is factory for id1.MyFeedPageState class
class MyFeedPageState_id1_Factory extends Factory<id1.MyFeedPageState> {
  id1.MyFeedPageState create(InjectionProvider injectionProvider) {
    var value = id1.MyFeedPageState();
    return value;
  }
}

/// this is injector for MyFeedPageState class
class MyFeedPageState_id1_Injector extends Injector<id1.MyFeedPageState> {
  void inject(
          id1.MyFeedPageState instance, InjectionProvider injectionProvider) =>
      instance.bloc = injectionProvider.get();
}

init() {
  defaultScopeFactory = ScopeFactoryImpl();
  injectorMapper.clear();
  factoryMapper.clear();
  injectorMapper[TypeQualifier(id1.MyFeedPageState)] =
      MyFeedPageState_id1_Injector();
  factoryMapper[TypeQualifier(id1.MyFeedPageState)] =
      MyFeedPageState_id1_Factory();
  injectorMapper[TypeQualifier(id2.MyFeedBloc)] = MyFeedBloc_id2_Injector();
  factoryMapper[TypeQualifier(id2.MyFeedBloc)] = MyFeedBloc_id2_Factory();
  injectorMapper[TypeQualifier(id3.LoginScreenState)] =
      LoginScreenState_id3_Injector();
  factoryMapper[TypeQualifier(id3.LoginScreenState)] =
      LoginScreenState_id3_Factory();
  injectorMapper[TypeQualifier(id4.AuthBloc)] = AuthBloc_id4_Injector();
  factoryMapper[TypeQualifier(id4.AuthBloc)] = AuthBloc_id4_Factory();
  injectorMapper[TypeQualifier(id5.SessionService)] =
      SessionService_id5_Injector();
  factoryMapper[TypeQualifier(id5.SessionService)] =
      SessionService_id5_Factory();
  injectorMapper[TypeQualifier(id5.AuthConfiguration)] =
      AuthConfiguration_id5_Injector();
  factoryMapper[TypeQualifier(id5.AuthConfiguration)] =
      AuthConfiguration_id5_Factory();
  injectorMapper[TypeQualifier(id5.AuthService)] = AuthService_id5_Injector();
  factoryMapper[TypeQualifier(id5.AuthService)] = AuthService_id5_Factory();
  rootDependencyResolver = {
    "injector": injectorMapper,
    "factory": factoryMapper
  };
}
