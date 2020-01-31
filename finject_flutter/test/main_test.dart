import 'package:finject_flutter/finject_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock.dart';
import 'widget_test_util.dart';

void main() {
  group("simple test for counting coverage", () {
    init();
    testWidgets('flat inject host', (WidgetTester tester) async {
      final sut = WidgetTestUtils.prepareWidget(
        FInjectHost.flat(
          child: InjectableWidget(),
        ),
      );
      await tester.pumpWidget(sut);

      testInjection();
    });
    testWidgets('inject_host', (WidgetTester tester) async {
      final sut = WidgetTestUtils.prepareWidget(
        FInjectHost.inject(
          child: InjectableWidget(),
        ),
      );
      await tester.pumpWidget(sut);

      testInjection();
    });
    testWidgets('inject_host builder', (WidgetTester tester) async {
      final sut = WidgetTestUtils.prepareWidget(
        FInjectHost.builder(
          builder: (BuildContext context, InjectionProvider finjector) =>
              InjectableWidget(),
        ),
      );
      await tester.pumpWidget(sut);

      testInjection();
    });
    testWidgets('inject_host', (WidgetTester tester) async {
      final sut = WidgetTestUtils.prepareWidget(
        FInjectHost.scoped(
          scopeName: null,
          child: InjectableWidget(),
        ),
      );
      await tester.pumpWidget(sut);

      testInjection();
    });
  });
}

testInjection() {
  Element found = find.byType(InjectableWidget).evaluate().toList().first;
  var value = found.widget as InjectableWidget;
  expect(value.value, isInstanceOf<Test>());
}

// ignore: must_be_immutable
class InjectableWidget extends StatelessWidget {
  Test value;

  @override
  Widget build(BuildContext context) {
    return Text("text");
  }
}
