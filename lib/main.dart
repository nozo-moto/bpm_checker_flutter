import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:state_notifier/state_notifier.dart';
import "dart:math";

final bpmProvider = StateNotifierProvider((ref) {
  return BPMChecker();
});

class BPMChecker extends StateNotifier<int> {
  BPMChecker() : super(0);
  static DateTime date = DateTime.now();
  void update() {
    var now = DateTime.now();
    var tmp = date;
    date = now;
    state =
        now.toUtc().millisecondsSinceEpoch - tmp.toUtc().millisecondsSinceEpoch;
  }
}

final backgroundColorProvider = StateNotifierProvider((ref) {
  return BackgroundColor();
});

class BackgroundColor extends StateNotifier<MaterialColor> {
  BackgroundColor() : super(Colors.grey);
  final _random = new Random();
  final colorList = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.grey,
    Colors.pink,
    Colors.purple
  ];
  void update() {
    state = colorList[_random.nextInt(colorList.length)];
  }
}

void main() {
  runApp(
    const ProviderScope(
      child: BpmCheckerApp(),
    ),
  );
}

class BpmCheckerApp extends HookWidget {
  const BpmCheckerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final diff = useProvider(bpmProvider);
    final backgroundColor = useProvider(backgroundColorProvider);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('BPM Checker')),
        body: GestureDetector(
          onTap: () {
            handlePress(context);
          },
          child: Container(
            child: Center(
              child: Text(
                formatBPM(diff),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 48),
              ),
            ),
            color: backgroundColor,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      ),
    );
  }

  void handlePress(BuildContext context) {
    context.read(bpmProvider.notifier).update();
    context.read(backgroundColorProvider.notifier).update();
  }

  String formatBPM(int diff) {
    if (diff == 0) {
      return "Let's click!";
    }
    return "BPM " + (60000 / diff).toInt().toString();
  }
}
