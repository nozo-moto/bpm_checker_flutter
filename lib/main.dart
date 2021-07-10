import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:state_notifier/state_notifier.dart';

final counterProvider = StateNotifierProvider((ref) {
  return Counter();
});

class Counter extends StateNotifier<int> {
  Counter() : super(0);
  void increment() => state++;
  void decrement() => state--;
}

void main() {
  runApp(
    const ProviderScope(
      child: CounterApp(),
    ),
  );
}

class CounterApp extends HookWidget {
  const CounterApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final count = useProvider(counterProvider);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('CounterApp')),
        body: Center(
          child: Text(count.toString()),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => handlePress(context),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void handlePress(BuildContext context) {
    context.read(counterProvider.notifier).increment();
  }
}
