import 'package:flutter/widgets.dart';

import 'pgn_app_lifecycle_flutter_api.g.dart';

class PgnAppLifecycleFlutterApiImpl implements PgnAppLifecycleFlutterApi {
  void Function(PgnAppLifecycleState state)? _onAppLifecycleStateChangedCallback;

  PgnAppLifecycleFlutterApiImpl({
    void Function(PgnAppLifecycleState state)? onAppLifecycleStateChangedCallback,
  }) : _onAppLifecycleStateChangedCallback = onAppLifecycleStateChangedCallback;

  @override
  String getFlutterLanguage() {
    // エラーの例
    //throw UnimplementedError('getFlutterLanguageは、まだ実装してないんですよ。');

    // 正常系
    return 'Dart';
  }

  @override
  void onAppLifecycleStateChanged(PgnAppLifecycleState state) {
    // エラーの例
    //throw UnimplementedError('onAppLifecycleStateChangedは、まだ実装してないんですよ。');

    // 正常系
    _onAppLifecycleStateChangedCallback?.call(state);
  }
}
