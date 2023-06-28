import 'package:android_pip/android_pip.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const MethodChannel channel = MethodChannel('puntito.simple_pip_mode');

  TestWidgetsFlutterBinding.ensureInitialized();

  bool activated = false;
  bool enterCallbackCalled = false;
  bool exitCallbackCalled = false;
  AndroidPIP pip = AndroidPIP(
    onPipEntered: () => enterCallbackCalled = true,
    onPipExited: () => exitCallbackCalled = true,
  );

  setUp(() {
    enterCallbackCalled = false;
    exitCallbackCalled = false;
    TestDefaultBinaryMessengerBinding.instance!.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'isPipAvailable':
          return true;
        case 'isPipActivated':
          return activated;
        case 'enterPipMode':
          activated = true;
          channel.invokeMethod('onPipEntered');
          return activated;
        case 'testExitPipMode':
          activated = false;
          channel.invokeMethod('onPipExited');
          break;
        // This handler overrides the AndroidPIP handler, so we add cases here.
        case 'onPipEntered':
          pip.onPipEntered?.call();
          break;
        case 'onPipExited':
          pip.onPipExited?.call();
          break;
      }
      return null;
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance!.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('isPipAvailable', () async {
    expect(await AndroidPIP.isPipAvailable, true);
  });

  test('isPipActivated', () async {
    expect(await AndroidPIP.isPipActivated, false);
  });

  test('enterPipMode', () async {
    expect(await AndroidPIP().enterPipMode(), true);
  });

  test('callbacks', () async {
    expect(await pip.enterPipMode(), true);
    expect(await AndroidPIP.isPipActivated, true);
    expect(enterCallbackCalled, true);
    await channel.invokeMethod('testExitPipMode');
    expect(await AndroidPIP.isPipActivated, false);
    expect(exitCallbackCalled, true);
  });
}
