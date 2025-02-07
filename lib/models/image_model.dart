import 'dart:io';

import 'package:flutter/material.dart';

class ImageModel {
  final String id;
  final String tittle;
  final String imageUrl;

  ImageModel({required this.id, required this.imageUrl, required this.tittle});

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    String tittle = json['description'] ?? 'No tittle';
    if (tittle.length > 50) {
      tittle = '${tittle.substring(0, 50)}...';
    }
    try {
      ImageModel image = ImageModel(
        id: json['id'].toString(),
        tittle: tittle,
        imageUrl: json['urls']['regular'] ?? '',
      );
      debugPrint('Image: $image', wrapWidth: 1024);
      return image;
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

  //Local
  static List<ImageModel> sampleImage() {
    return [
      ImageModel(
          id: '1',
          imageUrl: 'https://picsum.photos/seed/picsum/200',
          tittle: 'Image 1'),
      ImageModel(
          id: '2',
          imageUrl: 'https://picsum.photos/seed/picsum/200',
          tittle: 'Image 2'),
      ImageModel(
          id: '3',
          imageUrl: 'https://picsum.photos/seed/picsum/200',
          tittle: 'Image 3'),
    ];
  }
}
