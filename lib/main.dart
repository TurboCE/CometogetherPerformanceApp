import 'dart:math';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:marquee/marquee.dart';
import 'package:url_launcher/url_launcher.dart';

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
  String perfTitle;
  String perfNotice;
  bool isLoading;
  double noticeHeight;

  var themeColor = Colors.blueAccent;
  @override void initState() {
    super.initState();
    ctr = new TabController(vsync: this, length: 5);
    isLoading = true;
    noticeHeight = 0.0;
    readLocal();
  }

  readLocal() async {
    Firestore.instance.collection('information').document('information').get().then((document) {
      perfNotice = document['notice'];
      perfTitle = document['title'];
      noticeHeight = ((perfNotice != null)?50.0:0.0);
      log(noticeHeight);

      this.setState(() {
        isLoading = false;
      });
    });
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
            new Tab(icon: new Icon(Icons.home),text: 'Home',),
            new Tab(icon: new Icon(Icons.content_copy),text:'Program'),
            new Tab(icon: new Icon(Icons.youtube_searched_for),text:'Live'),
            new Tab(icon: new Icon(Icons.map),text:'Where'),
            new Tab(icon: new Icon(Icons.account_box),text:'About'),
          ],
        ),
      ),
      bottomNavigationBar: new Material(
          color: Colors.blueGrey,
          child: buildNoticeBar(),//(perfNotice!=null? buildNotice(perfNotice) : Container()),
      ),

      body: new TabBarView(
        controller: ctr,
        children: <Widget>[
          new Container(
            child: new SingleChildScrollView(
              child: new
              Column(
                children: <Widget>[
                  Image.asset(
                    'images/perf2.png',
                    fit: BoxFit.cover,),
                  Text(''),
                  Image.asset(
                    'images/perf1.png',
                    fit: BoxFit.cover,),
                ],
              ),

            )
          ),
          new Column(
            children: <Widget>[
              //Text('순서',style: TextStyle(fontSize:25,color: Colors.black)),
              buildListMessage(),
              ],
            ),
          buildYoutubeLive(),
          new WebView(initialUrl:'https://naver.me/x4CMvY7X',javascriptMode: JavascriptMode.unrestricted),
          new Container(
            child: Center(
              child: Column(
                children: <Widget>[
                  Text("\n"),
                  Text("Cometogether",style:TextStyle(fontSize:40,fontWeight: FontWeight.bold)),
                  Text(""),
                  Text("컴투게더는 삼성전자 내 임직원들의 음악 모임입니다.",style: TextStyle(fontSize:17,fontWeight: FontWeight.bold)),
                  Text(""),
                  Material(
                    child:Image.asset('images/about.jpg',width: 350,),
                    borderRadius: BorderRadius.all(
                      Radius.circular(50.0),
                    ),
                    clipBehavior: Clip.hardEdge,
                  ),
                  Text("\n"),
                  Text("공연 편하게 보시라고 앱 만들었습니다."),
                  Text("잼게 있다 갑시당"),
                  Text("\nby 만든이\n"),
                  Text("- 2019.11.30 -"),
                  Text("\n"),


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

  Widget buildItem(int index, DocumentSnapshot document) {
    return Container(
      child: Column(
        children: <Widget>[
          Center(child: Text(document['name'],style: TextStyle(fontSize:25,color: Colors.white),),),
          Center(child:Text(document['comment']!='' ? document['comment']:'----'),),
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
      margin: EdgeInsets.only(left:10.0,right:10.0,bottom: 10.0),
      padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
      //width: 200.0,
      decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(8.0)),
      //margin: EdgeInsets.only(left: 10.0),
    );
  }
  Widget buildListMessage() {
    return Flexible(
      child: isLoading == true
          ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(themeColor)))
          : StreamBuilder(
        stream: Firestore.instance
            .collection('index')
            .orderBy('order', descending: true)
            .limit(20)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
                child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent)));
          } else {
            //listMessage = snapshot.data.documents;
            return ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemBuilder: (context, index) => buildItem(index, snapshot.data.documents[index]),
              itemCount: snapshot.data.documents.length,
              reverse: true,
              //controller: listScrollController,
            );
          }
        },
      ),
    );
  }

  launchWebView(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false, forceWebView: false);
    }
  }

  Widget buildYoutubeLive() {
    return Material(
      color: Colors.blueGrey,
      child: isLoading == true
          ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(themeColor)))
          : StreamBuilder(
        stream: Firestore.instance
            .collection('information')
            .limit(20)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data.documents[0]['cast'] == '') {
            return new Center(
                heightFactor: 0.0,
                child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent)));
          } else {
            //listMessage = snapshot.data.documents;
            return new Scaffold(
              body: new WebView(initialUrl:snapshot.data.documents[0]['cast'],javascriptMode: JavascriptMode.unrestricted),
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () {
                  launchWebView(snapshot.data.documents[0]['cast']);
                },
                label: Text('Open'),
                icon: Icon(Icons.open_in_browser),
                backgroundColor: Colors.blueGrey,
              ),
            );
          }
        },
      ),
    );
  }

  Widget buildNoticeBar() {
    return Material(
      color: Colors.blueGrey,
      child: isLoading == true
          ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(themeColor)))
          : StreamBuilder(
        stream: Firestore.instance
            .collection('information')
            .limit(20)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data.documents[0]['notice'] == '') {
            return Center(
                heightFactor: 0.0,
                child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent)));
          } else {
            //listMessage = snapshot.data.documents;
            return buildNotice(snapshot.data.documents[0]['notice']);
          }
        },
      ),
    );
  }
  Widget buildNotice(String notice)
  {
    return Container(
      height: noticeHeight,
      child: Marquee(
        text:'$notice',
        style: TextStyle(fontSize:25,color: Colors.white,fontWeight: FontWeight.bold),
        blankSpace: 550.0,),
    );
  }
}

/*
https://www.youtube.com/watch?v=rovQIZryPZ8
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.

 */