import 'dart:io';
import 'dart:async';
import 'dart:ui';

import 'package:OneDiaryApp/view/ListDiary.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ViewArticle.dart';
import 'AddArticle.dart';
import 'Editor.dart';
import 'RouteObserver.dart';

final themeColor = Colors.blueGrey;
final brightnessColor = Brightness.dark;
// This is the type used by the popup menu below.
enum WhyFarther { harder, smarter, selfStarter, tradingCharter }

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      // todo what title
      title: 'OneDiaryApp',
      theme: ThemeData(
        // 页面背景色
        brightness: brightnessColor,
        // App 主色调
        primaryColor: themeColor,
        primarySwatch: themeColor,
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => DiaryListPage(),
        //"/": (context) => MyHomePage(),
        "category": (context) => Categories(),
        "pathdemo": (context) => PathDemo(),
        "add_art": (context) => AddArticle(),
        "add_article": (context) => AddArticle(),
        "view_art": (context) => ViewArticle(),
      },
      //home: MyHomePage(title: 'Jan. 16'),
      navigatorObservers: <NavigatorObserver>[routeObserver],
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    const rawDiaryCode = "diary1 | diary2 | diary3 ";
    List<String> firstIn = rawDiaryCode.split("|");
    const textCode = "Hello i'm fine! | It's pretty. | DON'T TOUCH NOW!! ";
    List<String> textArticle = textCode.split("|");

/*
    var indexs = 0;

    var listView = ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: firstIn.length,
      itemBuilder: (BuildContext context, int index) {
        indexs = index;

        return Container(
          child: Center(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text("diaryText"),
                ),
                Expanded(
                  child: Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const ListTile(
                          subtitle: Text("AText",
                              maxLines: 5, overflow: TextOverflow.ellipsis),
                        ),
                        ButtonBar(
                          children: <Widget>[
                            FlatButton(
                              child: const Text('BUY TICKETS'),
                              onPressed: () {/* ... */},
                            ),
                            FlatButton(
                              child: const Text('LISTEN'),
                              onPressed: () {/* ... */},
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
*/
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            PopupMenuButton<WhyFarther>(
              tooltip: "Date",
              icon: Expanded(
                flex: 0,
                child: Row(
                  children: <Widget>[
                    Icon(Icons.home),
                    //Text("<>"),
                  ],
                ),
              ),
              onSelected: (WhyFarther result) {
                setState(() {
                  //_selection = result;
                });
              },
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<WhyFarther>>[
                const PopupMenuItem<WhyFarther>(
                  value: WhyFarther.harder,
                  child: Text('Working a lot harder'),
                ),
              ],
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(
              tooltip: "Search diary",
              icon: Icon(Icons.search),
              onPressed: () {}),
          IconButton(
              tooltip: "Category",
              icon: Icon(Icons.bookmark),
              onPressed: () {}),

          // 导航栏右侧菜单
          Row(
            children: <Widget>[
              PopupMenuButton<String>(
                tooltip: "More options",
                icon: Icon(Icons.more_vert),
                onSelected: (String result) {
                  setState(() {
                    //_selection = result;
                  });
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: "WhyFarther.obverse",
                    child: Text('Obverse'),
                  ),
                  const PopupMenuItem<String>(
                    value: "WhyFarther.showDiary",
                    child: Text('Show private diary'),
                  ),
                  const PopupMenuItem<String>(
                    value: "WhyFarther.hide",
                    child: Text('Hide content'),
                  ),
                  const PopupMenuItem<String>(
                    value: "WhyFarther.switchHomePageTheme",
                    child: Text('Switch item template'),
                  ),
                ],
              ),
            ],
          ),
          //IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      drawer: Drawer(
        // 使用MediaQuery 中的removePadding 来移除顶部空间
        child: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: ListView.builder(
            itemCount: 1,
            itemExtent: window.physicalSize.height,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 0,
                    child: DrawerHeader(
                      decoration: BoxDecoration(
                        color: themeColor,
                        image: DecorationImage(
                          image: NetworkImage(
                              "https://bangdream.ga/assets-jp/characters/resourceset/res005037_rip/card_normal.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Undefined",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.bookmark),
                    title: Text(
                      "Category",
                    ),
                    onTap: () => {
                      Navigator.pushNamed(context, "category"),
                      print("Tapped."),
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.palette),
                    title: Text("Theme"),
                    onTap: () => {
                      print("Tapped."),
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text("Settings"),
                    onTap: () => {
                      print("Tapped."),
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.assistant_photo),
                    title: Text("Assistant Photo"),
                    onTap: () => {
                      print("Tapped."),
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.developer_board),
                    title: Text("Path demo"),
                    onTap: () => {
                      Navigator.pushNamed(context, "pathdemo"),
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),

      body: ListView.builder(
        itemCount: 1,
        itemExtent: window.physicalSize.height,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: <Widget>[
              Center(
                child: Card(
                  child: InkWell(
                    splashColor: Colors.blue.withAlpha(30),
                    onTap: () => Navigator.pushNamed(context, "view_art"),
                    child: Container(
                      width: 300,
                      height: 100,
                      child: Text("data"),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),

      //添加新文章
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, "add_art"),
        tooltip: 'Add new article',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class Categories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Category"),
      ),
      body: Column(
        children: <Widget>[
          Text("Categories.."),
        ],
      ),
    );
  }
}

class PathDemo extends StatefulWidget {
  PathDemo({
    Key key,
  }) : super(key: key);

  _PathDemoState createState() => new _PathDemoState();
}

/* ----------  ----------*/
class _PathDemoState extends State<PathDemo> {
  int _counter;

  @override
  void initState() {
    super.initState();
    _readCounter().then((int value) {
      setState(() {
        _counter = value;
      });
    });
  }

/* 
  Future<File> _getLocalFile() async {
    // get the path to the document directory.
    String dir = (await getApplicationDocumentsDirectory()).path;
    // TODO  测试用的文本记录, 正式使用前要删除

    return new File('$dir/counter.txt');
  }
 */
  Future<int> _readCounter() async {
    try {
/*       File file = await _getLocalFile();
      // read the variable as a string from the file.
      String contents = await file.readAsString();
 */
      //https://www.devio.org/2019/04/24/flutter-shared_preferences/
      final prefs = await SharedPreferences.getInstance();
      // Try reading data from the counter key. If it does not exist, return 0.
      final counter = prefs.getInt('counter') ?? 0;

      String asc = counter.toString();
      return int.parse(asc);
      //return String.parse(counter);
    } on FileSystemException {
      return 0;
    }
  }

  Future<Null> _incrementCounter() async {
    setState(() {
      _counter++;
    });

    //https://www.devio.org/2019/04/24/flutter-shared_preferences/
    final prefs = await SharedPreferences.getInstance();
    // set value
    prefs.setInt('counter', _counter);

/* 
    // write the variable as a string to the file
    await (await _getLocalFile()).writeAsString('$_counter'); */
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text('Flutter Demo')),
      body: new Center(
        child: new Text(
            'Button tapped $_counter time${_counter == 1 ? '' : 's'}.'),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ),
    );
  }
}
