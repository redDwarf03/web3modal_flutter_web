import 'dart:developer';
import 'dart:js_interop';

import 'package:flutter_web_application_1/domain/actions/sign_message.dart';
import 'package:flutter_web_application_1/domain/window.dart';

Future<SignMessageReturnType> signMessage(
  SignMessageParameters signMessageParameters,
) async {
  try {
    final toto = await window.signMessage(signMessageParameters).toDart;

    print('toto $toto');
    return toto;
  } catch (e) {
    log('Error signMessage dart: $e');
    rethrow;
  }
}
