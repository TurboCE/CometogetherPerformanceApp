import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '컴투게더 공연 안내',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: '컴투게더 공연 안내 - 2019.12.06'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  TabController ctr;
  @override void initState() {
    super.initState();
    ctr = new TabController(vsync: this, length: 4);
  }
  @override void dispose() {
    ctr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.blueGrey,
        bottom: new TabBar(
          controller: ctr,
          tabs: <Tab>[
            new Tab(icon: new Icon(Icons.content_copy)),
            new Tab(icon: new Icon(Icons.youtube_searched_for)),
            new Tab(icon: new Icon(Icons.map)),
            new Tab(icon: new Icon(Icons.account_box)),
          ],
        ),
      ),
      /*
      bottomNavigationBar: new Material(
          color: Colors.pinkAccent,
          child: new TabBar(
            controller: ctr,
            tabs: <Tab>[
              new Tab(icon: new Icon(Icons.arrow_forward)),
              new Tab(icon: new Icon(Icons.arrow_downward)),
              new Tab(icon: new Icon(Icons.arrow_back)),
            ],
          )),
      */
      body: new TabBarView(
        controller: ctr,
        children: <Widget>[
          new Container(
            child: new SingleChildScrollView(
              child: new
              Column(
                children: <Widget>[
                  Image.asset(
                    'images/perf1.png',
                    fit: BoxFit.cover,),
                  Text(''),
                  Image.asset(
                    'images/perf2.png',
                    fit: BoxFit.cover,),
                ],
              ),

            )
          ),
          new WebView(initialUrl:'https://www.youtube.com/watch?v=rovQIZryPZ8',javascriptMode: JavascriptMode.unrestricted),
          new WebView(initialUrl:'https://naver.me/x4CMvY7X',javascriptMode: JavascriptMode.unrestricted),
          new Container(
            child: Center(
              child: Column(
                children: <Widget>[
                  Text("\n"),
                  Text("Cometogether",textScaleFactor: 3,),
                  Text(""),
                  Material(
                    child:Image.asset('images/about.jpg',scale:0.4),
                    borderRadius: BorderRadius.all(
                      Radius.circular(30.0),
                    ),
                    clipBehavior: Clip.hardEdge,
                  ),
                  Text("\n"),
                  Text("컴투게더는 삼성전자 내 임직원들의 공연 모임 입니다."),
                  Text("누구나 자유롭게 가입 가능합니다."),
                  Text("반갑습니다.\n\n"),
                  Text("Since 2018.00.00\n",),
                  Text("Band나 기사 링크 여기 ??",),
                ]
              )
            )
          )
          //new p1.Page1(),
          //new p2.Page2(),
          //new p3.Page3(),
        ],
      ),

    );
  }
}

/*
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.

 */