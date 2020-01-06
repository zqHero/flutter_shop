import 'package:flutter_shop/config/index.dart';
import 'package:flutter_shop/service/http_service.dart';
import 'package:flutter/material.dart';

import 'dart:convert';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
//    super.build(context);
    // TODO: implement build
    return Scaffold(
      backgroundColor: Color.fromRGBO(244, 245, 245, 1.0),
      appBar: AppBar(
        title: Text(KString.homeTitle),
      ),
      body: FutureBuilder(
        //FutureBuider  防止频繁重新绘制
        future: request('homePageContent', formData: null),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var data = json.decode(snapshot.data.toString());
            print('==============${data}');
            return Container(
              child: Text(''),
            );
          } else {
            return Container(child: Text('加载中...'));
          }
        },
      ),
    );
  }
}
