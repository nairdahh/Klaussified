import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload user avatar
  Future<String> uploadUserAvatar({
    required String userId,
    required Uint8List fileBytes,
    required String fileName,
  }) async {
    try {
      // Create a reference to the avatar location
      final ref = _storage.ref().child('avatars/$userId/$fileName');

      // Upload the file
      final uploadTask = await ref.putData(
        fileBytes,
        SettableMetadata(
          contentType: _getContentType(fileName),
        ),
      );

      // Get the download URL
      final downloadURL = await uploadTask.ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      throw Exception('Failed to upload avatar: $e');
    }
  }

  // Delete user avatar
  Future<void> deleteUserAvatar(String photoURL) async {
    try {
      final ref = _storage.refFromURL(photoURL);
      await ref.delete();
    } catch (e) {
      // Ignore errors when deleting (file might not exist)
    }
  }

  // Get content type from file extension
  String _getContentType(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      default:
        return 'application/octet-stream';
    }
  }
}
