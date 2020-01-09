import 'package:flutter/material.dart';
import 'package:flutter_shop/provide/current_index_provide.dart';
import 'package:provide/provide.dart';

import './config/index.dart';
import 'provide/current_index_provide.dart';
import './pages/index_page.dart';

void main() {
  var currentIndexProvide = CurrentIndexProvide();
  var provides = Providers();

  provides
    ..provide(Provider<CurrentIndexProvide>.value(currentIndexProvide));

  runApp(ProviderNode(child: MyApp(), providers: provides));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: MaterialApp(
            title: KString.mainTitle, //flutter 女装商城
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primaryColor: KColor.primaryColor,
            ),
            home: IndexPage()));
  }
}
