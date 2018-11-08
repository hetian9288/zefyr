import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:zefyr/zefyr.dart';
import 'dart:io';

class ZefyrLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('Ze'),
        FlutterLogo(size: 24.0),
        Text('yr'),
      ],
    );
  }
}

class FullPageEditorScreen extends StatefulWidget {
  @override
  _FullPageEditorScreenState createState() => new _FullPageEditorScreenState();
}

final doc =
    r'[{"insert":"​","attributes":{"embed":{"type":"goods","source":{"id":550492594990,"thumbs":["//img.alicdn.com/imgextra/i1/2549841410/O1CN011MHovXiqHbyo84b_!!2549841410-0-sm.jpg","//img.alicdn.com/imgextra/i4/2549841410/O1CN011MHov5yS6qUD0q1_!!2549841410.jpg","//img.alicdn.com/imgextra/i4/2549841410/TB2lNNItbRkpuFjSspmXXc.9XXa_!!2549841410.jpg","//img.alicdn.com/imgextra/i2/2549841410/TB2_YIas9BjpuFjy1XdXXaooVXa_!!2549841410.jpg","//img.alicdn.com/imgextra/i4/2549841410/TB282xzhZ2vU1JjSZFwXXX2cpXa_!!2549841410.jpg"],"platform":"tmall","title":"【直营】天梭进口防水机械表男恒意系列T065.430.11.031.00瑞士","subtitle":"香港直邮","content":"","price":"260-320","volume":337}}}},{"insert":"\n"},'
    r'{"insert":"Zefyr"},{"insert":"\n","attributes":{"heading":1}},{"insert":"Soft and gentle rich text editing for Flutter applications.","attributes":{"i":true}},{"insert":"\n"},{"insert":"​","attributes":{"embed":{"type":"image","source":"asset://images/breeze.jpg"}}},{"insert":"\n"},{"insert":"Photo by Hiroyuki Takeda.","attributes":{"i":true}},{"insert":"\nZefyr is currently in "},{"insert":"early preview","attributes":{"b":true}},{"insert":". If you have a feature request or found a bug, please file it at the "},{"insert":"issue tracker","attributes":{"a":"https://github.com/memspace/zefyr/issues"}},{"insert":'
    r'".\nDocumentation"},{"insert":"\n","attributes":{"heading":3}},{"insert":"Quick Start","attributes":{"a":"https://github.com/memspace/zefyr/blob/master/doc/quick_start.md"}},{"insert":"\n","attributes":{"block":"ul"}},{"insert":"Data Format and Document Model","attributes":{"a":"https://github.com/memspace/zefyr/blob/master/doc/data_and_document.md"}},{"insert":"\n","attributes":{"block":"ul"}},{"insert":"Style Attributes","attributes":{"a":"https://github.com/memspace/zefyr/blob/master/doc/attr'
    r'ibutes.md"}},{"insert":"\n","attributes":{"block":"ul"}},{"insert":"Heuristic Rules","attributes":{"a":"https://github.com/memspace/zefyr/blob/master/doc/heuristics.md"}},{"insert":"\n","attributes":{"block":"ul"}},{"insert":"FAQ","attributes":{"a":"https://github.com/memspace/zefyr/blob/master/doc/faq.md"}},{"insert":"\n","attributes":{"block":"ul"}},{"insert":"Clean and modern look"},{"insert":"\n","attributes":{"heading":2}},{"insert":"Zefyr’s rich text editor is built with simplicity and fle'
    r'xibility in mind. It provides clean interface for distraction-free editing. Think Medium.com-like experience.\nMarkdown inspired semantics"},{"insert":"\n","attributes":{"heading":2}},{"insert":"Ever needed to have a heading line inside of a quote block, like this:\nI’m a Markdown heading"},{"insert":"\n","attributes":{"block":"quote","heading":3}},{"insert":"And I’m a regular paragraph"},{"insert":"\n","attributes":{"block":"quote"}},{"insert":"Code blocks"},{"insert":"\n","attributes":{"headin'
    r'g":2}},{"insert":"Of course:\nimport ‘package:flutter/material.dart’;"},{"insert":"\n","attributes":{"block":"code"}},{"insert":"import ‘package:zefyr/zefyr.dart’;"},{"insert":"\n\n","attributes":{"block":"code"}},{"insert":"void main() {"},{"insert":"\n","attributes":{"block":"code"}},{"insert":" runApp(MyZefyrApp());"},{"insert":"\n","attributes":{"block":"code"}},{"insert":"}"},{"insert":"\n","attributes":{"block":"code"}},{"insert":"\n\n\n"}]';

Delta getDelta() {
  return Delta.fromJson(json.decode(doc));
}

class _FullPageEditorScreenState extends State<FullPageEditorScreen> {
  final ZefyrController _controller =
      ZefyrController(NotusDocument.fromDelta(getDelta()));
  final FocusNode _focusNode = new FocusNode();
  bool _editing = false;

  @override
  Widget build(BuildContext context) {
    final theme = new ZefyrThemeData(
      toolbarTheme: ZefyrToolbarTheme.fallback(context).copyWith(
        color: Colors.grey.shade800,
        toggleColor: Colors.grey.shade900,
        iconColor: Colors.white,
        disabledIconColor: Colors.grey.shade500,
      ),
    );

    final done = _editing
        ? [new FlatButton(onPressed: _stopEditing, child: Text('DONE'))]
        : [new FlatButton(onPressed: _startEditing, child: Text('EDIT'))];
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        elevation: 1.0,
        backgroundColor: Colors.grey.shade200,
        brightness: Brightness.light,
        title: ZefyrLogo(),
        actions: done,
      ),
      body: ZefyrScaffold(
        child: ZefyrTheme(
          data: theme,
          child: ZefyrEditor(
            controller: _controller,
            focusNode: _focusNode,
            enabled: _editing,
            apihost: Uri.parse("http://192.168.1.4:5928"),
            gesturesDelegate: MyGestures(),
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

  void _stopEditing() async {
    setState(() {
      _editing = false;
    });

    print(json.encode(_controller.document.toDelta()));
  }
}

/// Custom image delegate used by this example to load image from application
/// assets.
///
/// Default image delegate only supports [FileImage]s.
class CustomImageDelegate extends ZefyrDefaultImageDelegate {
  @override
  Widget buildImage(BuildContext context, String imageSource) {
    // We use custom "asset" scheme to distinguish asset images from other files.
    if (imageSource.startsWith('asset://')) {
      final asset = new AssetImage(imageSource.replaceFirst('asset://', ''));
      return new Image(image: asset);
    } else {
      return super.buildImage(context, imageSource);
    }
  }
}


class MyGestures extends ZefyrGesturesDelegate {
  @override
  void onLongPress(RenderEditableBox renderNode, NotusStyle style, Offset offset) {
    // TODO: implement onLongPress
    print("---->n");
  }

  @override
  void onPress(RenderEditableBox renderNode, NotusStyle style, Offset offset) {
    // TODO: implement onPress
    print("---->l");
  }

}