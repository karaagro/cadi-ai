import 'dart:async';

void Function(S) debounce<S>(void Function(S) fn, {int duration = 300}) {
  Timer? timer;

  return (S params) {
    if (timer != null) {
      timer!.cancel();
    }
    timer = Timer(Duration(milliseconds: duration), () {
      fn(params);
    });
  };
}
