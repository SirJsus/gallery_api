import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/image_model.dart';
import 'api_constants.dart';

class ImageService {
  Future<List<ImageModel>> fetchImages({int limit = 10}) async {
    try {
      final url = Uri.parse(
          '${ApiConstants.baseUrl}/photos/?client_id=${ApiConstants.accessKey}');
      //final url = Uri.parse(
      //'https://api.unsplash.com/photos/?client_id=Rw3hZJS3LCyT0RcyJZuxSvKB_nBRq5JGbXmK3BNOnvg');
      debugPrint('url: $url', wrapWidth: 1024);

      final response = await http.get(url);
      /*var response = await get(url, headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Credentials': 'true',
        'Access-Control-Allow-Headers': 'Content-Type',
        'Access-Control-Allow-Methods': 'GET,PUT,POST,DELETE'
      });*/
      debugPrint('Response body length: ${response.statusCode}');

      if (response.statusCode == 200) {
        final String responseBody = response.body;
        debugPrint('Response body length: ${responseBody.length}');
        if (responseBody.length > 1000) {
          debugPrint(
              'Response body (truncated): ${responseBody.substring(0, 1000)}...');
        } else {
          debugPrint('Response body: $responseBody');
        }

        final List<dynamic> data = json.decode(response.body);
        final limitedData = data.take(limit).toList();
        return limitedData.map((json) => ImageModel.fromJson(json)).toList();
      } else {
        debugPrint('Failed to load images: ${response.statusCode}',
            wrapWidth: 1024);
        throw Exception('Failed to load images: ${response.statusCode}');
      }
    } on SocketException catch (e) {
      debugPrint('SocketException: $e', wrapWidth: 1024);
      throw Exception('No Internet connection: $e');
    } on HttpException catch (e) {
      debugPrint('HttpException: $e', wrapWidth: 1024);
      throw Exception('HTTP error: $e');
    } on FormatException catch (e) {
      debugPrint('FormatException: $e', wrapWidth: 1024);
      throw Exception('Bad response format: $e');
    } catch (e) {
      debugPrint('Unexpected error: $e', wrapWidth: 1024);
      throw Exception('Unexpected error: $e');
    }
  }
}
