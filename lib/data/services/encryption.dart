import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'package:ozapay/core/constants.dart';

class Encryption {
  static final _password = const String.fromEnvironment(kMnemonicEnvVar);

  /// Encrypts using AES-256 encryption
  /// Returns base64 encoded encrypted string
  static String encryptMnemonic(String input) {
    // Generate a key from the password using SHA-256
    final digest = sha256.convert(utf8.encode(_password)).bytes;
    final key = Key(Uint8List.fromList(digest));

    // Generate a random IV (Initialization Vector)
    final iv = IV.fromSecureRandom(16);

    // Create encrypter with AES
    final encrypter = Encrypter(AES(key));

    // Encrypt the input
    final encrypted = encrypter.encrypt(input, iv: iv);

    // Combine IV and encrypted data
    final combined = iv.bytes + encrypted.bytes;

    // Return base64 encoded string
    return base64.encode(combined);
  }

  /// Decrypts an encrypted string
  /// Returns the original string
  static String decryptMnemonic(String encryptedData) {
    try {
      // Decode base64 string
      final bytes = base64.decode(encryptedData);

      // Extract IV and encrypted data
      final iv = IV(bytes.sublist(0, 16));
      final encryptedBytes = bytes.sublist(16);

      // Generate key from password
      final digest = sha256.convert(utf8.encode(_password)).bytes;
      final key = Key(Uint8List.fromList(digest));

      // Create encrypter
      final encrypter = Encrypter(AES(key));

      // Decrypt data
      final decrypted = encrypter
          .decrypt(Encrypted(Uint8List.fromList(encryptedBytes)), iv: iv);

      return decrypted;
    } catch (e) {
      throw Exception(
          'Failed to decrypt $encryptedData: Invalid password or corrupted data');
    }
  }

  static List<int> encryptSecretKey(List<int> secretKey) {
    // Generate a key using SHA-256 of the secret key
    var keyBytes = utf8.encode(_password);
    var digest = sha256.convert(keyBytes);
    var key = digest.bytes;

    // Create a reproducible random number generator using the key
    var random =
        Random(ByteData.sublistView(Uint8List.fromList(key)).getInt64(0));

    // XOR each number with a random value generated from the key
    var encrypted = List<int>.filled(secretKey.length, 0);
    for (var i = 0; i < secretKey.length; i++) {
      var randomValue = random.nextInt(pow(2, 32).toInt());
      encrypted[i] = secretKey[i] ^ randomValue;
    }

    return encrypted;
  }

  static List<int> decryptSecretKey(List<int> encryptedSecretKey) {
    // Use the same key generation process
    var keyBytes = utf8.encode(_password);
    var digest = sha256.convert(keyBytes);
    var key = digest.bytes;

    // Create the same random number generator
    var random =
        Random(ByteData.sublistView(Uint8List.fromList(key)).getInt64(0));

    // XOR with the same random values to decrypt
    var decrypted = List<int>.filled(encryptedSecretKey.length, 0);
    for (var i = 0; i < encryptedSecretKey.length; i++) {
      var randomValue = random.nextInt(pow(2, 32).toInt());
      decrypted[i] = encryptedSecretKey[i] ^ randomValue;
    }

    return decrypted;
  }

  /// Validates that a string is a valid mnemonic phrase
  static bool isValidMnemonic(String mnemonic) {
    final words = mnemonic.trim().split(' ');
    // Solana uses 12 or 24 word phrases
    return words.length == 12 || words.length == 24;
  }
}

class PasswordEncryption {
  static const int _ivLength = 16; // 128 bits
  static final String _encryptionKey = r"mK9#xP2vL5@nQ8&jR4%hT7!wY3*cF6$";

  static String encrypt(String data) {
    try {
      // Create key from string
      final key = Key.fromUtf8(_padKey(_encryptionKey));

      // Generate random IV
      final iv = IV.fromSecureRandom(_ivLength);

      // Create encrypter
      final encrypter = Encrypter(AES(key, mode: AESMode.cbc));

      final encrypted = encrypter.encryptBytes(
        utf8.encode(data),
        iv: iv,
      );

      final combined = Uint8List(encrypted.bytes.length + _ivLength);
      combined.setAll(0, iv.bytes);
      combined.setAll(_ivLength, encrypted.bytes);

      // Convert to base64
      return base64.encode(combined);
    } catch (e) {
      throw Exception('Encryption failed: $e');
    }
  }

  static String decrypt(String encryptedData) {
    try {
      // Decode from base64
      final combined = base64.decode(encryptedData);

      // Extract IV and encrypted data
      final iv = IV(combined.sublist(0, _ivLength));
      final encrypted = Encrypted(Uint8List.fromList(
        combined.sublist(_ivLength),
      ));

      // Create key from string
      final key = Key.fromUtf8(_padKey(_encryptionKey));

      // Create encrypter
      final encrypter = Encrypter(AES(key, mode: AESMode.cbc));

      final decryptedBytes = encrypter.decryptBytes(
        encrypted,
        iv: iv,
      );

      // Convert bytes to string
      return utf8.decode(decryptedBytes);
    } catch (e) {
      throw Exception('Decryption failed: $e');
    }
  }

  static String _padKey(String key) {
    if (key.length < 32) {
      return key.padRight(32, '0');
    } else if (key.length > 32) {
      return key.substring(0, 32);
    }
    return key;
  }
}
