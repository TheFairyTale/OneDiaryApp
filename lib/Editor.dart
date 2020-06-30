import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:zefyr/zefyr.dart';

import './model/Diary.dart';
import './Persistance/FileManager.dart';

// https://learningflutter.net/flutter-markdown-editor/
class ZefyrLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text('Editor'),
      ],
    );
  }
}

class FullPageEditorScreen extends StatefulWidget {
  FullPageEditorScreen(this.diary, this.openOnEditing);
  final Diary diary;
  final bool openOnEditing;

  @override
  _FullPageEditorScreenState createState() => new _FullPageEditorScreenState();
}

class _FullPageEditorScreenState extends State<FullPageEditorScreen> {
  ZefyrController _controller;
  final FocusNode _focusNode = new FocusNode();
  bool _editing = false;
  StreamSubscription<NotusChange> _sub;
  TextEditingController _titleController;
  final FileManager fm = new FileManager();

  @override
  void initState() {
    super.initState();
    _controller = ZefyrController(NotusDocument.fromDelta(
        Delta.fromJson(json.decode(widget.diary.text) as List)));
    _sub = _controller.document.changes.listen((change) {
      print('${change.source}: ${change.change}');
    });
    _titleController = new TextEditingController(text: widget.diary.title);
    _titleController.addListener(_editTitle);

    if (widget.openOnEditing) {
      _startEditing();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _sub.cancel();
    super.dispose();
  }

  void _editTitle() {
    var text = _titleController.text;
    if (text.isEmpty) {
      setState(() {
        widget.diary.changeDiaryTitle('Untitled');
      });
    } else {
      setState(() {
        widget.diary.changeDiaryTitle(text);
      });
    }
  }

  void _deleteDiary() {
    fm.deleteDiary(widget.diary).then((res) {
      print('deleted');
      print(res);
      Navigator.of(context).pop();
    }).catchError(print);
  }

  @override
  Widget build(BuildContext context) {
    final theme = new ZefyrThemeData(
      toolbarTheme: ToolbarTheme.fallback(context).copyWith(
        color: Colors.grey.shade800,
        toggleColor: Colors.grey.shade900,
        iconColor: Colors.white,
        disabledIconColor: Colors.grey.shade500,
      ),
    );

    final done = _editing
        ? [
            new FlatButton(
                onPressed: _deleteDiary,
                child: Text(
                  'DELETE',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                )),
            new FlatButton(
                onPressed: _stopEditing,
                child: Text(
                  'DONE',
                  style: TextStyle(color: Colors.white),
                ))
          ]
        : [
            new FlatButton(
                onPressed: _startEditing,
                child: Text(
                  'EDIT',
                  style: TextStyle(color: Colors.white),
                ))
          ];
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        elevation: 1.0,
        title: TextField(
          controller: _titleController,
          autofocus: false,
          enabled: _editing,
          textInputAction: TextInputAction.done,
          textCapitalization: TextCapitalization.words,
          cursorColor: Colors.white,
          style: new TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelStyle: TextStyle(color: Colors.white),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            disabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            fillColor: Colors.white,
          ),
        ),
        actions: done,
      ),
      body: ZefyrScaffold(
        child: ZefyrTheme(
          data: theme,
          child: ZefyrEditor(
            controller: _controller,
            focusNode: _focusNode,
            //enabled: _editing,
            autofocus: true,
            imageDelegate: new CustomImageDelegate(),
          ),
        ),
      ),
    );
  }

  void _startEditing() {
    setState(() {
      _editing = true;
    });
  }

  void _stopEditing() {
    final jsonValue = jsonEncode(_controller.document.toJson());
    var diaryCopy = widget.diary;
    diaryCopy.text = jsonValue;
    fm.writeDiary(diaryCopy).then((res) {
      print('ok');
      print(res);
    });
    setState(() {
      _editing = false;
    });
  }
}

/// Custom image delegate used by this example to load image from application
/// assets.
///
/// Default image delegate only supports [FileImage]s.
class CustomImageDelegate extends ZefyrImageDelegate {
  @override
  Widget buildImage(BuildContext context, String imageSource) {
    // We use custom "asset" scheme to distinguish asset images from other files.
    if (imageSource.startsWith('asset://')) {
      final asset = new AssetImage(imageSource.replaceFirst('asset://', ''));
      return new Image(image: asset);
    } else {
      //return super.buildImage(context, imageSource);
      return buildImage(context, imageSource);
    }
  }

  @override
  // TODO: implement cameraSource
  get cameraSource => throw UnimplementedError();

  @override
  // TODO: implement gallerySource
  get gallerySource => throw UnimplementedError();

  @override
  Future<String> pickImage(source) {
    // TODO: implement pickImage
    throw UnimplementedError();
  }
}
