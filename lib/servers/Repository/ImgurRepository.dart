import 'dart:io';

import 'package:dio/dio.dart';

class ImgurRepository {
  Dio _dio = Dio();

  Future<String> UploadImage(String image) async {
    try {
    Dio dio = Dio();
    dio.options.headers['Authorization'] = 'Client-ID 6e18b2bf3f2f5b0';

    FormData formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(image),
    });

    Response response = await dio.post(
      'https://api.imgur.com/3/upload',
      data: formData,
    );

    if (response.statusCode == 200) {
      return response.data['data']['link'];
    } else {
      throw Exception('Failed to upload image to Imgur');
    }
  } catch (e) {
    throw Exception('Failed to upload image to Imgur: $e');
  }
    // final dio = Dio();

    // final clientId = '6e18b2bf3f2f5b0';
    // final clientSecret = '172cffc5a32114f2c6be9c2d5f100c752fa5c44f';
    
    // final authorizationCode = '5f0d36ec6044fd8b9daace1975add70b54e6d7cf';

    // final formData = FormData.fromMap({
    //   'client_id': clientId,
    //   'client_secret': clientSecret,
    //   'grant_type': 'authorization_code',
    //   'code': authorizationCode,
    // });

    // final options = Options(
    //   contentType: Headers.formUrlEncodedContentType,
    // );

  
    // final response = await dio.post(
    //   'https://api.imgur.com/oauth2/token',
    //   data: formData,
    //   options: options,
    // );

    // final accessToken = response.data['access_token'];

    // final formDataImage = FormData.fromMap({
    //   'image': await MultipartFile.fromFile(image.path, filename: 'image1.png'),
    //   'type': 'file',
    //   'name': 'image1.png',
    //   'title': 'Image',
    //   'description': 'Image Description',
    //   'album': "WpDjpUp",
    //   'disable_audio': '1',
    // });

    // final headers = {
    //   'Authorization': 'Bearer ${accessToken}',
    // };
    // final optionsImage = Options(headers: headers);
    // try {
    //   final responseImage = await _dio.post(
    //     'https://api.imgur.com/3/image',
    //     data: formDataImage,
    //     options: optionsImage,
    //   );
    //   if (responseImage.statusCode == 200) {
    //     String link = responseImage.data["data"]["link"];
    //     return link;
    //   }
    //   else{
    //     return "Ошибка";
    //   }
    // } catch (e) {
    //     return "Ошибка";
    // }
  }
}
