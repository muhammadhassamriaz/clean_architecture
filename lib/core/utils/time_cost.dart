import 'dart:convert';
import 'dart:isolate';

mainThreadHeavyTaskTimeCost(){
      final N = 1000;
  String content = '';
  for (var i = 0; i < N; i++) {
    content += '"content$i": $i';
    if (i != N - 1) content += ',';
  }
  final jsonStr = '{$content}';

  Future asyncRun<Q>(Function(Q) function, Q message) async {
    function(message);
  }

  final stopwatchA = Stopwatch()..start();
  jsonDecode(jsonStr);
  print('$N content sync run     : ${stopwatchA.elapsed}');

  final stopwatchB = Stopwatch()..start();
  await asyncRun(jsonDecode, jsonStr);
  print('$N content async run    : ${stopwatchA.elapsed}');

  final stopwatchC = Stopwatch()..start();
  await Isolate.spawn(jsonDecode, jsonStr);
  print('$N content isolate run  : ${stopwatchC.elapsed}');
}