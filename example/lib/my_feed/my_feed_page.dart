import 'package:example/my_feed/my_feed_bloc.dart';
import 'package:finject_flutter/finject_flutter.dart';
import 'package:flutter/material.dart';

class MyFeedPage extends StatefulWidget {
  @override
  MyFeedPageState createState() => MyFeedPageState();
}

@Injectable()
class MyFeedPageState extends DiState<MyFeedPage> {
  @Inject()
  late MyFeedBloc bloc;

  MyFeedPageState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Feed"),
      ),
      body: StreamBuilder<List>(
        initialData: null,
        stream: bloc.feedStream,
        builder: (_, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            var data = snapshot.data!;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (_, __) => Text("sdfsfd"),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
