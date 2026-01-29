import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';

class CryptoUtils {

  static String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }


  static bool verifyPassword(String password, String hashedPassword) {
    return hashPassword(password) == hashedPassword;
  }



  static String encryptText(String text, String password) {
    final key = hashPassword(password);
    final textBytes = utf8.encode(text);
    final keyBytes = utf8.encode(key);
    
    final encrypted = <int>[];
    for (int i = 0; i < textBytes.length; i++) {
      encrypted.add(textBytes[i] ^ keyBytes[i % keyBytes.length]);
    }
    
    return base64.encode(encrypted);
  }

  static String decryptText(String encryptedText, String password) {
    try {
      final key = hashPassword(password);
      final encryptedBytes = base64.decode(encryptedText);
      final keyBytes = utf8.encode(key);
      
      final decrypted = <int>[];
      for (int i = 0; i < encryptedBytes.length; i++) {
        decrypted.add(encryptedBytes[i] ^ keyBytes[i % keyBytes.length]);
      }
      
      return utf8.decode(decrypted);
    } catch (e) {
      return '';
    }
  }


  static Uint8List encryptFile(Uint8List data, String password) {
    final key = hashPassword(password);
    final keyBytes = utf8.encode(key);
    
    final encrypted = Uint8List(data.length);
    for (int i = 0; i < data.length; i++) {
      encrypted[i] = data[i] ^ keyBytes[i % keyBytes.length];
    }
    
    return encrypted;
  }

  static Uint8List decryptFile(Uint8List encryptedData, String password) {

    return encryptFile(encryptedData, password);
  }
}
