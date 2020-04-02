import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Browser extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new BrowserState();
  }

}

class BrowserState extends State<Browser> {

  var isVisible = true;

  @override
  Widget build(BuildContext context) {
    var args = jsonDecode(ModalRoute.of(context).settings.arguments);
    var url = args["url"];

    return Scaffold(
        appBar: AppBar(
          title: Text(args["title"]),
        ),
        body: Stack(
          children: <Widget>[
            WebView(
              initialUrl: url,
              javascriptMode: JavascriptMode.unrestricted,
              onPageFinished: onPageFinished,
            ),
            Visibility(
                visible: isVisible,
                child: Center(
                  child: SizedBox(
                      width: 30.0,
                      height: 30.0,
                      child: CircularProgressIndicator(strokeWidth: 2.0)),
                )
            ),
          ],
        ));
  }

  void onPageFinished(s) {
    setState(() {
      isVisible = false;
    });
  }

}
