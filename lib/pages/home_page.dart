import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shop/config/index.dart';
import 'package:flutter_shop/service/http_service.dart';
import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:flutter_easyrefresh/easy_refresh.dart';

import 'package:flutter_swiper/flutter_swiper.dart';
import '../config/font.dart';

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
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true; //保持激活   防止刷新处理  保持当前状态

  //火爆专区分页
  int page = 1;
  List<Map> hotGoodsList = []; //火爆专区数据

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
                  //广告
                  FloorPic(floorPic: fp1),
                  //广告下的几个商品
                  Floor(floor: floor1),
                  //火爆专区
                  hotGoods()
                ],
              ),
              loadMore: () async {
                //异步
                print('加载更多.....');
                getHotGoodsData();
              },
            );
          } else {
            return Container(child: Text('加载中...'));
          }
        },
      ),
    );
  }

  void getHotGoodsData() {
    //获取火爆专区数据
    var formPage = {'page': page}; //页数
    request('getHotGoods', formData: formPage).then((value) {
      var data = json.decode(value.toString());
      List<Map> newGoodsList = (data['data'] as List).cast();
      //设置  火爆专区  数据列表
      setState(() {
        hotGoodsList.addAll(newGoodsList);
        page++;
      });
    });
  }

  Widget hotGoods() {
    return Container(
      child: Column(
        children: <Widget>[
          hotTitle(),
          _wrapList(),
        ],
      ),
    );
  }

  Widget hotTitle() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.all(5),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(width: 0.5, color: KColor.defaultBorderColor),
          )),
      child: Text(
        KString.hotHomeTitle,
        style: TextStyle(
          color: KColor.homeSubTitleTextColor,
        ),
      ),
    );
  }

  //火爆专区  数据渲染
  Widget _wrapList() {
    if (hotGoodsList.length != 0) {
      List<Widget> listWidget = hotGoodsList.map((value) {
        return InkWell(
          onTap: () {},
          child: Container(
            width: ScreenUtil().setWidth(372),
            color: Colors.white,
            padding: EdgeInsets.all(5.0),
            margin: EdgeInsets.only(bottom: 3.0),
            child: Column(
              children: <Widget>[
                Image.network(
                  value['image'],
                  width: ScreenUtil().setWidth(375),
                  height: 200,
                  fit: BoxFit.cover,
                ),
                Text(
                  value['name'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: ScreenUtil().setSp(26)),
                ),
                Row(
                  children: <Widget>[
                    Text(
                      '￥${value['prientPrice']}',
                      style: TextStyle(color: KColor.presentPriceTextColor),
                    ),
                    Text(
                      '￥${value['oriPrice']}',
                      style: TextStyle(color: KColor.oriPriceTextColor),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      }).toList();

      return Wrap(
        spacing: 2,
        children: listWidget,
      );
    } else {
      return Text('');
    }
  }
}

//商品推荐    底部分类
class Floor extends StatelessWidget {
  final List<Map> floor;

  Floor({Key key, this.floor}) : super(key: key);

  void jumpDetail(context, String goodId) {
    //跳转到商品详情界面
  }

  @override
  Widget build(BuildContext context) {
    double width = ScreenUtil
        .getInstance()
        .width;
    return Container(
      child: Row(
        children: <Widget>[
          //左侧商品
          Expanded(
            child: Column(
              children: <Widget>[
                //左上角大图
                Container(
                  padding: EdgeInsets.only(top: 4, left: 4, right: 1),
                  height: ScreenUtil().setHeight(333),
                  child: InkWell(
                    child: Image.network(
                      floor[0]['image'],
                      fit: BoxFit.cover,
                    ),
                    onTap: () {
                      jumpDetail(context, floor[0]['goodsId']);
                    },
                  ),
                )
              ],
            ),
          ),
//            右侧商品
          Expanded(
            child: Column(
              children: <Widget>[
                //右上图
                Container(
                  padding: EdgeInsets.only(top: 4, left: 1, right: 4),
                  height: ScreenUtil().setHeight(111),
                  width: width / 2,
                  child: InkWell(
                    child: Image.network(
                      floor[1]['image'],
                      fit: BoxFit.fill,
                    ),
                    onTap: () {
                      jumpDetail(context, floor[1]['goodsId']);
                    },
                  ),
                ),
                //右中图
                Container(
                  padding: EdgeInsets.only(top: 4, left: 1, right: 4),
                  height: ScreenUtil().setHeight(111),
                  width: width / 2,
                  child: InkWell(
                    child: Image.network(
                      floor[1]['image'],
                      fit: BoxFit.cover,
                    ),
                    onTap: () {
                      jumpDetail(context, floor[1]['goodsId']);
                    },
                  ),
                ),
                //右下图
                Container(
                  padding: EdgeInsets.only(top: 4, left: 1, right: 4),
                  height: ScreenUtil().setHeight(111),
                  width: width / 2,
                  child: InkWell(
                    child: Image.network(
                      floor[4]['image'],
                      fit: BoxFit.cover,
                    ),
                    onTap: () {
                      jumpDetail(context, floor[4]['goodsId']);
                    },
                  ),
                )
              ],
            ),
          )
        ],
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
      ),
    );
  }
}

//商品推荐 下面   广告
class FloorPic extends StatelessWidget {
  final Map floorPic;

  FloorPic({Key key, this.floorPic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 5.0),
      child: Container(
        height: ScreenUtil().setHeight(250),
        margin: EdgeInsets.only(top: 5.0),
        child: InkWell(
          child: Image.network(
            floorPic['PICTURE_ADDRESS'],
            fit: BoxFit.fitWidth,
          ),
          onTap: () {},
        ),
      ),
    );
  }
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
      height: ScreenUtil().setHeight(280),
      child: ListView.builder(
          itemCount: recommendList.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return _item(index, context);
          }),
    );
  }

  Widget _item(index, context) {
    return InkWell(
      onTap: () {},
      child: Container(
        width: ScreenUtil().setWidth(280),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              left: BorderSide(width: 0.5, color: KColor.defaultBorderColor),
            )),
        child: Column(children: <Widget>[
          //防止溢出
          Expanded(
            child: Image.network(
              recommendList[index]['image'],
              fit: BoxFit.fitHeight,
            ),
          ),
          Text('￥${recommendList[index]['presentPrice']}',
              style: TextStyle(color: KColor.presentPriceTextColor)),
          Text('￥${recommendList[index]['oriPrice']}',
              style: KFont.priPriceStyle)
        ]),
      ),
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
