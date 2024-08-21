import 'dart:js_interop';

@JS()
external JSBigInt bigInt;

@JS('BigInt')
external JSBigInt createBigInt(String value);

extension on JSBigInt {
  @JS('toString')
  external String toStringExternal();
}
