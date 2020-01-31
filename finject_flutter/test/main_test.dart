
import 'package:finject_flutter/finject_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock.dart';
import 'widget_test_util.dart';

void main() {
  group("simple test for counting coverage", (){
    init();
    testWidgets('has an icon', (WidgetTester tester) async {
      final screen = JustInjectHost(
        child: InjectableWidget(),
      );
      final sut = WidgetTestUtils.prepareWidget(screen);
      await tester.pumpWidget(sut);

      Element found = find.byType(InjectableWidget).evaluate().toList().first;
      var value = found.widget as InjectableWidget;
      expect(value.value, isInstanceOf<Test>());
    });
  });
}


// ignore: must_be_immutable
class InjectableWidget extends StatelessWidget{

  Test value;

  @override
  Widget build(BuildContext context) {
    return Text("text");
  }



}