import 'dart:async';

import 'package:finject_flutter/finject_flutter.dart';

@Injectable()
class MyFeedBloc {
  StreamController<List> _feedStream = StreamController.broadcast();
  StreamController<bool> _loadingStream = StreamController.broadcast();

  Stream<List> get feedStream => _feedStream.stream;


  MyFeedBloc(){
    loadData();
  }

  Future loadData() async {
    await Future.delayed(Duration(seconds: 3));
    _feedStream.sink.add([1, 2, 3, 4, 5, 6, 7, 8, 9]);
  }
}
