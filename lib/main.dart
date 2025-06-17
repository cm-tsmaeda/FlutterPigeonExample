import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pigeon_example/pigeons/pgn_app_lifecycle_flutter_api_impl.dart';
import 'pigeons/pgn_greeting_host_api.g.dart';
import 'pigeons/pgn_app_lifecycle_flutter_api.g.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Pigeon Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  bool _isBottomSheetShowing = false;

  // PgnGreetingHostApi関連 ===

  final PgnGreetingHostApi _greetingHostApi = PgnGreetingHostApi();
  String? _hostLanguage;
  bool _hasHostLanguageLoadError = false;
  String? _greetingMessage;
  bool _hasGreetingMessageLoadError = false;

  void updateHostLanguage() async {
    setState((){
      _hasHostLanguageLoadError = false;
    });
    _greetingHostApi.getHostLanguage().then((language) {
      print('Host language: $language');
      setState(() {
        _hostLanguage = language;
        _hasHostLanguageLoadError = false;
      });
    }).onError<PlatformException>((PlatformException error, StackTrace _) {
      print('Error getting host language: $error');
      setState(() {
        _hasHostLanguageLoadError = true;
      });
    });
  }

  void onGetMessageButtonPressed() async {
    print('Button pressed');
    try {
      setState(() {
        _hasGreetingMessageLoadError = false;
        _greetingMessage = null;
      });
      //final person = PgnPerson();
      final person = PgnPerson(name: 'サンプル 太郎', age: 30);
      final result = await _greetingHostApi.getMessage(person);
      setState(() => _greetingMessage = result);
    } catch (error) {
      print('Error getting message: $error');
      setState(() => _hasGreetingMessageLoadError = true);
    }
  }

  // PgnGreetingHostApi関連 ここまで ===

  void onAppLifecycleStateChanged(PgnAppLifecycleState state) {
    // アプリのライフサイクル状態が変化したときの処理
    switch (state) {
      case PgnAppLifecycleState.enterForeground:
        print('App entered foreground');
        _showBottomSheet(context, 'App State Changed', 'App entered foreground');
      case PgnAppLifecycleState.enterBackground:
        print('App entered background');
        break;
    }
  }

  @override
  void initState() {
    super.initState();

    // 初期化時にホスト側の言語を取得
    updateHostLanguage();

    // PgnAppLifecycleFlutterApiの初期化
    final flutterApi = PgnAppLifecycleFlutterApiImpl(
      onAppLifecycleStateChangedCallback: onAppLifecycleStateChanged,
    );
    PgnAppLifecycleFlutterApi.setUp(flutterApi);
  }

  @override
  void dispose() {
    // PgnAppLifecycleFlutterApiのクリーンアップ
    PgnAppLifecycleFlutterApi.setUp(null);
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            // PgnGreetingHostApiImpl関連の呼び出し === 

            if (_hasHostLanguageLoadError)
              const Text('Error loading host language')
            else
              Text('Host language: $_hostLanguage'),

            SizedBox(height: 30),

            if (_greetingMessage != null)
              Text('$_greetingMessage')
            else if (_hasGreetingMessageLoadError)
              const Text('Error loading greeting message')
            else
              const CircularProgressIndicator(),

            SizedBox(height: 10),

            ElevatedButton(
              onPressed: onGetMessageButtonPressed, 
              child: const Text('getMessage')),

            // PgnGreetingHostApiImpl関連の呼び出し ここまで ===  
          ],
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context, String? title, String? message) {
    if (_isBottomSheetShowing) return;
    _isBottomSheetShowing = true;

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // メッセージ部分
              if (title != null && title.isNotEmpty)
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
              if (message != null && message.isNotEmpty)
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 24),
              // OKボタン
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('OK'),
                ),
              ),
              SizedBox(height: 8),
            ],
          ),
        );
      },
    ).whenComplete(() {
      print('Bottom sheet closed');
      _isBottomSheetShowing = false;
    });
  }
}
