import 'package:example/test.dart';
import 'package:example/test2.dart' as a;
import 'package:finject/finject.dart';
import 'package:finject_flutter/finject_flutter.dart';
import 'package:flutter/material.dart';

import 'finject_config.dart' as finject;

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    finject.init();

    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

//  HelloWorld hh = new HelloWorld();
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              'You have pushed the button this many times:',
            ),
            new Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
            FInjectHost.scoped(
              scopeName: "test",
              child: Test(),
            ),
            FInjectHost.scoped(
              scopeName: "test",
              child: Column(
                children: <Widget>[
                  FInjectHost.inject(
                    child: Test(),
                  ),
                  FInjectHost.inject(
                    child: Test(),
                  ),
                  FInjectHost.builder(
                      builder: (BuildContext ctx, InjectionProvider provider) =>
                          Test2(
                            provider.get('one'),
                            provider.get('two'),
                            provider.get(),
                          )),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

@Injectable()
// ignore: must_be_immutable
class Test extends StatelessWidget {
  @Inject()
  @Named("one")
  TestClass one;

  @Inject()
  @Named("two")
  TestClass two;

  @Inject()
  a.TestClass three;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[Text(one.value), Text(two.value), Text(three.value)],
    );
  }
}

class Test2 extends StatelessWidget {
  final TestClass one;
  final TestClass two;
  final a.TestClass three;

  Test2(this.one, this.two, this.three);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text("Test2"),
        Text(one.value),
        Text(two.value),
        Text(three.value)
      ],
    );
  }
}
