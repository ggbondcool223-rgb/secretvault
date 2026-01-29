import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';

class EncryptionHelper {

  static const String _encryptionKey = 'SecretVault2024Key';


  static Future<void> encryptFile(String sourcePath, String targetPath) async {
    try {
      final sourceFile = File(sourcePath);
      final bytes = await sourceFile.readAsBytes();
      final encryptedBytes = _xorEncrypt(bytes);
      
      final targetFile = File(targetPath);
      await targetFile.parent.create(recursive: true);
      await targetFile.writeAsBytes(encryptedBytes);
    } catch (e) {
      throw Exception('Failed to encrypt file: $e');
    }
  }


  static Future<Uint8List> decryptFile(String encryptedPath) async {
    try {
      final file = File(encryptedPath);
      final encryptedBytes = await file.readAsBytes();
      return _xorDecrypt(encryptedBytes);
    } catch (e) {
      throw Exception('Failed to decrypt file: $e');
    }
  }


  static Uint8List _xorEncrypt(Uint8List data) {
    final key = utf8.encode(_encryptionKey);
    final result = Uint8List(data.length);
    
    for (int i = 0; i < data.length; i++) {
      result[i] = data[i] ^ key[i % key.length];
    }
    
    return result;
  }


  static Uint8List _xorDecrypt(Uint8List data) {
    return _xorEncrypt(data);
  }


  static String generateFileHash(String content) {
    final bytes = utf8.encode(content + DateTime.now().toString());
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
