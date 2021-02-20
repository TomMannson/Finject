
import 'package:example/infrastructure/auth_service.dart';
import 'package:finject_flutter/finject_flutter.dart';


class AuthCache implements DisposableScopedObject{

  bool loaded = false;
  bool loggedIn;

  SessionService service;

  AuthCache(this.service);

  @override
  void onDispose() {
    1.toString();
  }

}