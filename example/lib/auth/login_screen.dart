

import 'package:example/auth/auth_bloc.dart';
import 'package:finject_flutter/finject_flutter.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginScreenState();
  }
}

@Injectable()
class LoginScreenState extends DiState<LoginScreen> {

  @Inject()
  AuthBloc bloc;

  TextEditingController _loginControler;
  TextEditingController _passwordControler;

  @override
  void initState() {
    super.initState();
    _loginControler = TextEditingController();
    _passwordControler = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Column(
            children: [
              TextField(controller: _loginControler,
                  decoration: InputDecoration(
                    labelText: "Login"
                  )
              ),
              TextField(controller: _loginControler,
                  decoration: InputDecoration(
                      labelText: "Password"
                  )
              ),
              RaisedButton(
                child: Text("Login"),
                onPressed: () async {
                  await bloc.performLogin();
                  Navigator.pushReplacementNamed(context, "route");
                },
              ),
              StreamBuilder<bool>(
                initialData: false,
                stream: bloc.progress,
                builder: (_, snapshot) {
                  if(snapshot.hasData && snapshot.data){
                    return CircularProgressIndicator();
                  }
                  return Container();
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _loginControler.dispose();
    _passwordControler.dispose();
    super.dispose();
  }
}
