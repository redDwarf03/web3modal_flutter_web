import 'dart:developer';
import 'dart:js_interop';

import 'package:flutter_web_application_1/domain/actions/write_contract.dart';
import 'package:flutter_web_application_1/domain/window.dart';

Future<WriteContractReturnType> writeContract(
  WriteContractParameters writeContractParameters,
) async {
  try {
    return await window.writeContract(writeContractParameters).toDart;
  } catch (e) {
    log('Error writeContract: $e');
    throw WriteContractErrorType;
  }
}
