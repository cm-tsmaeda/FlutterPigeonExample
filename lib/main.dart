import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pigeons/pgn_greeting_host_api.g.dart';

void main() {
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

  // PgnGreetingHostApiImpl関連 ===

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

  // PgnGreetingHostApiImpl関連 ここまで ===

  @override
  void initState() {
    super.initState();
    // 初期化時にホスト側の言語を取得
    updateHostLanguage();
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
}
