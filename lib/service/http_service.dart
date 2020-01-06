import 'package:dio/dio.dart';
import 'dart:async';
import 'dart:io';
import '../config/index.dart';

Future request(url, {formData}) async {
  try {
    Response response;
    Dio dio = new Dio();
    dio.options.contentType =
        ContentType.parse("application/x-www-form-urlencoded");
    if (formData == null) {
      response = await dio.post(sevicePath[url]);
    } else {
      response = await dio.post(sevicePath[url], data: formData);
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
