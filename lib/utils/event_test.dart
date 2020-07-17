import 'dart:async';

class EventBusTest {
  static EventBusTest _instance;
  StreamController _streamController;

  factory EventBusTest.getDefault() {
    return _instance ??= EventBusTest._internal();
  }

  EventBusTest._internal() {
    _streamController = StreamController.broadcast();
  }

  StreamSubscription<T> regiest<T>(void onData(T event)) {
    //如果没有指定类型，全类型注册
    if (T == dynamic) {
      return _streamController.stream.listen(onData);
    }else{
      //筛选类型为T的数据，获得只包含为T的stream
      Stream<T> stream = _streamController.stream.where((type) => type is T).cast<T>();
      stream.listen(onData);
    }
    void post(event){
      _streamController.add(event);
    }

    void destroy(){
      _streamController.close();

    }

  }
}
