import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:video_thumbnail/video_thumbnail.dart';
import 'encryption_helper.dart';

class MediaHelper {

  static Future<Directory> getPrivateDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final privateDir = Directory('${appDir.path}/encrypted_media');
    if (!await privateDir.exists()) {
      await privateDir.create(recursive: true);
    }
    return privateDir;
  }


  static Future<Directory> getThumbnailDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final thumbDir = Directory('${appDir.path}/thumbnails');
    if (!await thumbDir.exists()) {
      await thumbDir.create(recursive: true);
    }
    return thumbDir;
  }


  static String detectMediaType(String filePath) {
    final ext = path.extension(filePath).toLowerCase();
    const imageExts = ['.jpg', '.jpeg', '.png', '.gif', '.webp', '.bmp'];
    const videoExts = ['.mp4', '.mov', '.avi', '.mkv', '.flv', '.wmv'];
    
    if (imageExts.contains(ext)) {
      return 'image';
    } else if (videoExts.contains(ext)) {
      return 'video';
    }
    return 'unknown';
  }


  static String generateUniqueFileName(String originalName) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final ext = path.extension(originalName);
    final hash = EncryptionHelper.generateFileHash('$originalName$timestamp');
    return '${hash.substring(0, 16)}_$timestamp$ext';
  }


  static Future<String> encryptAndSaveFile(
    XFile sourceFile,
    Directory targetDir,
  ) async {
    final uniqueFileName = generateUniqueFileName(sourceFile.name);
    final targetPath = '${targetDir.path}/$uniqueFileName';
    
    await EncryptionHelper.encryptFile(sourceFile.path, targetPath);
    return targetPath;
  }


  static Future<String> generateThumbnail(
    XFile sourceFile,
    String mediaType,
    Directory thumbnailDir,
  ) async {
    try {
      final uniqueFileName = generateUniqueFileName(sourceFile.name);

      if (mediaType == 'image') {

        final thumbnailPath = '${thumbnailDir.path}/thumb_$uniqueFileName';
        final sourceBytes = await File(sourceFile.path).readAsBytes();
        await File(thumbnailPath).writeAsBytes(sourceBytes);
        return thumbnailPath;
      } else if (mediaType == 'video') {

        
        try {

          final jpgPath = '${thumbnailDir.path}/thumb_${uniqueFileName.replaceAll(path.extension(uniqueFileName), '.jpg')}';
          
          final thumbnailPath = await VideoThumbnail.thumbnailFile(
            video: sourceFile.path,
            thumbnailPath: thumbnailDir.path,
            imageFormat: ImageFormat.JPEG,
            maxWidth: 512,
            quality: 75,
          );
          
          
          if (thumbnailPath != null && thumbnailPath.isNotEmpty) {
            final file = File(thumbnailPath);
            if (await file.exists()) {
              final fileSize = await file.length();
              
              if (fileSize > 0) {

                await file.rename(jpgPath);
                return jpgPath;
              }
            }
          }
          

          final thumbnailBytes = await VideoThumbnail.thumbnailData(
            video: sourceFile.path,
            imageFormat: ImageFormat.JPEG,
            maxWidth: 512,
            quality: 75,
          );
          
          
          if (thumbnailBytes != null && thumbnailBytes.isNotEmpty) {
            await File(jpgPath).writeAsBytes(thumbnailBytes);
            return jpgPath;
          }
        } catch (e) {
          debugPrint('Error generating video thumbnail: $e');
        }
        

        final thumbnailPath = '${thumbnailDir.path}/thumb_$uniqueFileName';
        await File(thumbnailPath).create();
        return thumbnailPath;
      }
      

      final thumbnailPath = '${thumbnailDir.path}/thumb_$uniqueFileName';
      await File(thumbnailPath).create();
      return thumbnailPath;
    } catch (e) {

      final uniqueFileName = generateUniqueFileName(sourceFile.name);
      final thumbnailPath = '${thumbnailDir.path}/thumb_$uniqueFileName';
      try {
        await File(thumbnailPath).create(recursive: true);
      } catch (createError) {
        debugPrint('Error creating thumbnail file: $createError');
      }
      return thumbnailPath;
    }
  }


  static Future<int> getFileSize(String filePath) async {
    try {
      final file = File(filePath);
      return await file.length();
    } catch (e) {
      return 0;
    }
  }


  static Future<void> deleteFile(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      debugPrint('Error deleting file: $e');
    }
  }


  static Future<void> cleanupUnusedFiles(List<String> usedPaths) async {
    try {
      final privateDir = await getPrivateDirectory();
      final thumbnailDir = await getThumbnailDirectory();
      

      await _cleanDirectory(privateDir, usedPaths);
      

      await _cleanDirectory(thumbnailDir, usedPaths);
    } catch (e) {
      debugPrint('Error cleaning up unused files: $e');
    }
  }

  static Future<void> _cleanDirectory(
    Directory dir,
    List<String> usedPaths,
  ) async {
    final files = await dir.list().toList();
    for (final file in files) {
      if (file is File && !usedPaths.contains(file.path)) {
        try {
          await file.delete();
        } catch (e) {
          debugPrint('Error deleting unused file ${file.path}: $e');
        }
      }
    }
  }
}
