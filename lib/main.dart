import 'dart:js_interop';
import 'package:flutter/material.dart';

@JS()
external JSWindow get window;

@JS()
extension type JSWindow(JSObject _) implements JSObject {
  external void openModal();
  external void closeModal();
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  void openModal() {
    window.openModal();
  }

  void closeModal() {
    window.closeModal();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Flutter Web3Modal')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  openModal(); // Call the function to connect wallet
                },
                child: const Text('Connect Wallet'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
