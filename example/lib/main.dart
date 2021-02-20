import 'package:example/my_feed/my_feed_page.dart';
import 'package:finject_flutter/finject_flutter.dart';
import 'package:flutter/material.dart';

import 'auth/login_screen.dart';
import 'finject_config.dart' as finject;

void main() {
  finject.init();
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FInjectHost.scoped(
      scopeName: "session",
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: "root",
        routes: {
          "root": (context) => FInjectHost.scoped(
                scopeName: "screen",
                child: LoginScreen(),
              ),
          'route': (context) => new MyFeedPage(),
        },
      ),
    );
  }
}