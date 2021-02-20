

import 'package:example/auth/auth_cache.dart';
import 'package:finject_flutter/finject_flutter.dart';

abstract class AuthService {
  Future<bool> login();
}

class ProductionAuthService extends AuthService {
  @override
  Future<bool> login() {
    throw UnimplementedError();
  }

}

class TestAuthService extends AuthService {

  final AuthCache cache;

  TestAuthService(this.cache);

  @override
  Future<bool> login() async {
    if(!cache.loaded) {
      await Future.delayed(Duration(seconds: 1));
    }
    cache.loaded = true;
    return true;
  }
}

@Configuration()
class AuthConfiguration {

  @Profile(["dev"])
  AuthService createAuth() {
    return ProductionAuthService();
  }

  @Profile(["test"])
  AuthService createAuthTest(AuthCache cache) {
    return TestAuthService(cache);
  }

  @Scoped("screen")
  AuthCache createAuthCache(SessionService service) {
    return AuthCache(service);
  }
}

@Singleton()
@Injectable()
class SessionService {

}
