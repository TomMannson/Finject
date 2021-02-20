
import 'dart:async';

import 'package:example/infrastructure/auth_service.dart';
import 'package:finject_flutter/finject_flutter.dart';

@Injectable()
class AuthBloc {

  AuthService authService;
  StreamController<bool> _logged = StreamController.broadcast();
  StreamController<bool> _progress = StreamController.broadcast();

  Stream<bool> get logged => _logged.stream;
  Stream<bool> get progress => _progress.stream;

  AuthBloc(this.authService);

  Future performLogin() async{
    _progress.sink.add(true);
    final result = await authService.login();
    _progress.sink.add(false);
    _logged.sink.add(result);
  }


}