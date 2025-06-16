import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(PigeonOptions(
  dartOut: 'lib/pigeons/pgn_greeting_host_api.g.dart',
  dartOptions: DartOptions(),
  kotlinOut:
      'android/app/src/main/kotlin/com/example/pigeon_example/pigeons/PgnGreetingHostApi.g.kt',
  kotlinOptions: KotlinOptions(),
  swiftOut: 'ios/Runner/pigeons/PgnGreetingHostApi.g.swift',
  swiftOptions: SwiftOptions(),
))

/// あいさつ対象の人
class PgnPerson {
  PgnPerson({
    this.name,
    this.age,
  });
  String? name;
  int? age;
}

/// ホスト側のあいさつAPI
@HostApi()
abstract class PgnGreetingHostApi {
  /// ホスト側の言語を取得する
  String getHostLanguage();

  /// あいさつのメッセージを取得する
  /// [person] あいさつ対象の人
  ///
  /// Returns: あいさつのメッセージ
  @SwiftFunction('getMessage(person:)')
  @async
  String getMessage(PgnPerson person);
}
