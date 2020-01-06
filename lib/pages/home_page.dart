import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shop/config/index.dart';
import 'package:flutter_shop/service/http_service.dart';
import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:flutter_easyrefresh/easy_refresh.dart';

import 'package:flutter_swiper/flutter_swiper.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomePageState();
  }
}

//AutomaticKeepAlive  继承自该类  使得   当前页  在tab切换时   不刷新界面
class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  //diff 算法   保证key唯一
  GlobalKey<RefreshFooterState> _footerKey =
      new GlobalKey<RefreshFooterState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('首页刷新----');
  }

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
            List<Map> swiperDataList =
                (data['data']['slides'] as List).cast(); //轮播图
            List<Map> category = (data['data']['category'] as List).cast(); //分类
            List<Map> recommendList =
                (data['data']['recommend'] as List).cast(); //商品推荐
            List<Map> floor1 =
                (data['data']['floor1'] as List).cast(); //底部商品  推荐
            Map fp1 = data['data']['floorPic']; //广告

            return EasyRefresh(
              refreshFooter: ClassicsFooter(
                key: _footerKey,
                bgColor: Colors.white,
                textColor: KColor.refreshTextColor,
                moreInfoColor: KColor.refreshTextColor,
                showMore: true,
                noMoreText: '',
                moreInfo: KString.loading,
                //加载中
                loadReadyText: KString.loadReadyText,
              ),
              child: ListView(
                children: <Widget>[
                  //轮播图
                  SwiperDiy(
                    swiperDataList: swiperDataList,
                  ),
                  //分类
                  TopNavigator(navigatorList: category),
                  //推荐
                  RecommendUI(recommendList: recommendList),

                ],
              ),
              loadMore: () async {
                //异步
                print('加载更多.....');
              },
            );
          } else {
            return Container(child: Text('加载中...'));
          }
        },
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true; //保持激活   防止刷新处理  保持当前状态
}

//商品推荐
class RecommendUI extends StatelessWidget {
  final List recommendList;

  RecommendUI({Key key, this.recommendList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      child: Column(
        children: <Widget>[
          _titleWidget(),
          _recommendList(context),
        ],
      ),
    );
  }

  //推荐  商品 标题
  Widget _titleWidget() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(10, 2, 0, 5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(width: 0.5, color: KColor.defaultBorderColor),
        ),
      ),
      child: Text(
        KString.recommendText, //商品 推荐
        style: TextStyle(color: KColor.homeSubTitleTextColor),
      ),
    );
  }

  //商品 推荐列表
  Widget _recommendList(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(350),
      child: ListView.builder(
          itemCount: recommendList.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Text("=${index}");
          }),
    );
  }
}

//首页  分类导航组件
class TopNavigator extends StatelessWidget {
  final List navigatorList;

  TopNavigator({Key key, this.navigatorList}) : super(key: key);

  Widget _gridViewItemUI(BuildContext context, item, index) {
    return InkWell(
      onTap: () {
        //跳转到分类页面：
      },
      child: Column(
        children: <Widget>[
          Image.network(item['image'],
              width: ScreenUtil().setWidth(60),
              height: ScreenUtil().setHeight(60)),
          Text(item['firstCategoryName']),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (navigatorList.length > 10) {
      //只保留  是个分类
      navigatorList.removeRange(10, navigatorList.length);
    }
    var tempIndex = -1;
    return Container(
        color: Colors.white,
        margin: EdgeInsets.only(top: 5),
        height: ScreenUtil().setHeight(300),
        padding: EdgeInsets.all(3),
        child: GridView.count(
          physics: NeverScrollableScrollPhysics(), //不要发生滚动  禁止滚动
          crossAxisCount: 5,
          padding: EdgeInsets.all(4),
          children: navigatorList.map((item) {
            tempIndex++;
            return _gridViewItemUI(context, item, tempIndex);
          }).toList(),
        ));
  }
}

//swiperDiy定义：轮播组件
class SwiperDiy extends StatelessWidget {
  final List swiperDataList;

  SwiperDiy({Key key, this.swiperDataList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      color: Colors.white,
      height: ScreenUtil().setWidth(333),
      width: ScreenUtil().setHeight(750),
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              print('----------${index}');
            },
            child: Image.network(
              "${swiperDataList[index]['image']}",
              fit: BoxFit.cover,
            ),
          );
        },
        itemCount: swiperDataList.length,
        pagination: new SwiperPagination(),
        autoplay: true,
      ),
    );
  }
}
