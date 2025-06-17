import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(PigeonOptions(
  dartOut: 'lib/pigeons/pgn_app_lifecycle_flutter_api.g.dart',
  dartOptions: DartOptions(),
  kotlinOut:
      'android/app/src/main/kotlin/com/example/pigeon_example/pigeons/PgnAppLifecycleFlutterApi.g.kt',
  kotlinOptions: KotlinOptions(
    includeErrorClass: false,
  ),
  swiftOut: 'ios/Runner/pigeons/PgnAppLifecycleFlutterApi.g.swift',
  swiftOptions: SwiftOptions(
    includeErrorClass: false,
  ),
))

/// アプリのライフサイクル状態
enum PgnAppLifecycleState {
  enterForeground,
  enterBackground,
}

@FlutterApi()
abstract class PgnAppLifecycleFlutterApi {
  /// Flutter側の言語を取得する
  String getFlutterLanguage();

  /// アプリのライフサイクル状態が変化したときに呼び出される
  ///
  /// [state] アプリのライフサイクル状態
  void onAppLifecycleStateChanged(PgnAppLifecycleState state);
}
