import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Registers mock method-channel handlers so widgets that touch
/// `audioplayers` or `flutter_tts` don't throw MissingPluginException in tests.
void mockAudioAndTtsChannels() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final messenger = TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  messenger.setMockMethodCallHandler(
    const MethodChannel('xyz.luan/audioplayers'),
    (call) async => null,
  );

  messenger.setMockMethodCallHandler(
    const MethodChannel('xyz.luan/audioplayers/events'),
    (call) async => null,
  );

  messenger.setMockMethodCallHandler(
    const MethodChannel('flutter_tts'),
    (call) async => 1,
  );
}

/// Sets a phone-sized test viewport so tall pager layouts don't overflow.
void usePhoneViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 3.0;
  addTearDown(tester.view.reset);
}
