import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:magazineworld24/data_connection_check.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Magazine World',
      theme: ThemeData(
        primaryColor: Colors.black,
        accentColor: Colors.black,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  final flutterWebviewPlugin = new FlutterWebviewPlugin();

  bool isLoading = false;
  bool isNetworkConnected = true;


  @override
  void initState() {
    super.initState();

    isInternetConnected().then((value){
      setState(() {
        isNetworkConnected = value;
      });
    });

    flutterWebviewPlugin.onUrlChanged.listen((String url) {
      print(url);
    });

    flutterWebviewPlugin.onProgressChanged.listen((value) {

      print(value);

      if(value<1.0 && !isLoading){

        setState(() {
          isLoading = true;
        });
      }

      if(value == 1.0 && isLoading){

        setState(() {
          isLoading = false;
        });
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: isNetworkConnected? Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [

          if(isLoading) Center(child: LinearProgressIndicator(color: Colors.white,backgroundColor: Colors.black,)),

          Expanded(
            child: WebviewScaffold(
              url: "https://magazineworld24.com/home",
              withZoom: true,
              withLocalUrl: true,
              initialChild: Container(
                color: Colors.black,
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white,),
                ),
              ),
            ),
          ),
        ],
      ): Center(child: Text("No Internet Connected!!",style: TextStyle(fontStyle: FontStyle.normal,decoration:TextDecoration.none,fontSize: 16),),),
    );
  }
}
