import 'dart:async';
import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // date formatter
import 'package:OneDiaryApp/ViewArticle.dart'; // article detail page
import '../Editor.dart';
import '../model/Diary.dart'; // diary model
import '../Persistance/FileManager.dart';
import '../RouteObserver.dart';

class DiaryListPage extends StatefulWidget {
  @override
  _DiaryListPageState createState() => new _DiaryListPageState();
}

class _DiaryListPageState extends State<DiaryListPage> with RouteAware {
  List<Diary> _diary = [];
  final formatter = new DateFormat('yyyy-MM-dd hh:mm:ss');

  @override
  void initState() {
    super.initState();
    _loadDiary().then((onValue) {
      if (onValue.length == 0) {
        _loadFakeDiary().then((onValue) {
          setState(() {
            _diary = onValue;
          });
        }).catchError(print);
      } else {
        setState(() {
          /* 
          Diary diary = new Diary(
              // TODO there has a id 1
              id: 1,
              title: "b",
              text: "Zefyr2",
              date: DateTime(2019, 02, 01, 11, 12, 13));
          List<Diary> _diaryJson = [diary]; */

          _diary = onValue;
          //_diary = _diaryJson;
        });
      }
      /* 
      setState(() {
        _diary = _diaryJson;
      }); */
    }).catchError(print);
  }

  //Future<void> _loadDiary() async {
  Future<List<Diary>> _loadDiary() async {
    // http.Response response = await http.get('https://randomuser.me/api/?results=25');
    var fm = new FileManager();
    final res = await fm.getDiary();
    // await DefaultAssetBundle.of(context).loadString("assets/text.json");
    res.sort();
    return res;
  }

  Future<List<Diary>> _loadFakeDiary() async {
    var response =
        await DefaultAssetBundle.of(context).loadString("assets/text.json");
    //var diary = Diary.allFromResponse(response);
    var diary = Diary.fromJsonResponse(response);
    /* List<Diary> diaryList = List<Diary>();
    diaryList.add(diary);
    return diaryList; */
    List<Diary> diaryList = List<Diary>();
    diaryList.add(diary);
    diaryList.sort();
    return diaryList;
  }

  Widget _buildDiaryListTile(BuildContext context, int index) {
    var diary = _diary[index];

    return new ListTile(
      onTap: () => _navigateToDiaryDetails(diary, index),
      title: new Text(diary.title),
      subtitle: new Text(formatter.format(diary.date)),
    );
  }

  void _navigateToDiaryDetails(Diary diary, Object index,
      {bool startEditing = false}) {
    debugPrint(diary.text);
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (c) {
          return new FullPageEditorScreen(diary, startEditing);
        },
      ),
    );
  }

  void _addDiary() {
    final diary = new Diary(
        id: 0,
        title: "",
        text: Diary.emptyText,
        date: new DateTime.now(),
        lastModified: new DateTime.now());
    _navigateToDiaryDetails(diary, null, startEditing: true);
  }

  // Called when the top route has been popped off, and the current route shows up.
  void didPopNext() {
    // debugPrint("didPopNext ${runtimeType}");
    // force reload page
    _loadDiary().then((onValue) {
      if (onValue.length == 0) {
        _loadFakeDiary().then((onValue) {
          _diary = onValue;
        }).catchError(print);
      } else {
        setState(() {
          _diary = onValue;
        });
      }
    }).catchError(print);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    final add = [
      new FlatButton(
          onPressed: _addDiary,
          child: Text(
            'ADD',
            style: TextStyle(color: Colors.white),
          ))
    ];

    if (_diary.isEmpty) {
      content = new Center(
        child: new CircularProgressIndicator(),
      );
    } else {
      content = new ListView.builder(
        itemCount: _diary.length,
        itemBuilder: _buildDiaryListTile,
      );
    }

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Editor'),
        actions: <Widget>[add[0]],
      ),
      body: content,
    );
  }
}
