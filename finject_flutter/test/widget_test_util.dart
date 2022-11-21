import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class WidgetTestUtils {
  static Widget prepareWidget(Widget widget) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Container(
            key: const Key('mockContainer'),
            child: widget,
          ),
        ),
      ),
    );
  }

  static Widget prepareWidgetWithFlex(Widget widget) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Column(
            key: const Key('mockContainer'),
            children: <Widget>[widget],
          ),
        ),
      ),
    );
  }

  static Future performAsyncPump(
      {required WidgetTester tester, required Widget widget}) async {
    await tester.runAsync(() async {
      final sut = WidgetTestUtils.prepareWidget(widget);
      await tester.pumpWidget(sut);
      await tester.idle();
      await tester.pump(Duration.zero);
    });
  }
}
