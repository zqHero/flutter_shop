import 'package:dio/dio.dart';
import 'dart:async';
import 'dart:io';
import '../config/index.dart';
import '../config/http_conf.dart';

Future request(url, {formData}) async {
  try {
    Response response;
    Dio dio = new Dio();
    dio.options.contentType =
        ContentType.parse("application/x-www-form-urlencoded");
    if (formData == null) {
      //TODO  暂时使用 GET请求:
      response = await dio.post(servicePath[url]);
    } else {
      response = await dio.post(servicePath[url], data: formData);
    }
    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception("接口请求异常.....code:${response.statusCode}");
    }
  } catch (e) {
    return print('err:::${e}');
  }
}
