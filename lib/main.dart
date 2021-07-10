import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:state_notifier/state_notifier.dart';

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
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('BPM Checker')),
        body: Center(
          child: Text(formatBPM(diff)),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => handlePress(context),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void handlePress(BuildContext context) {
    context.read(bpmProvider.notifier).update();
  }

  String formatBPM(int diff) {
    if (diff == 0) {
      return "";
    }
    return "BPM" + (60000 / diff).toInt().toString();
  }
}
