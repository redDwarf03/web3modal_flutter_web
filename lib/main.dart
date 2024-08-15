// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:js_util' as js_util;
import 'dart:html' as html;

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  void openModal() {
    js_util.callMethod(html.window, 'openModal', []);
  }

  void closeModal() {
    js_util.callMethod(html.window, 'closeModal', []);
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
