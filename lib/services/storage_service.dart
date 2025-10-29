import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  // Faz upload de um arquivo para o caminho especificado no storage
  Future<String> uploadFile(File file, String path) async {
    try {
      final ref = _firebaseStorage.ref().child(path);
      final uploadTask = ref.putFile(file);
      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception('Erro ao fazer upload do arquivo: $e');
    }
  }

  // Obtém a URL pública para exibir/baixar o arquivo salvo no storage
  Future<String?> getFileUrl(String path) async {
    try {
      final ref = _firebaseStorage.ref().child(path);
      return await ref.getDownloadURL();
    } catch (e) {
      print('Erro ao obter URL do arquivo: $e');
      return null;
    }
  }

  // Deleta o arquivo no caminho especificado no storage
  Future<void> deleteFile(String path) async {
    try {
      final ref = _firebaseStorage.ref().child(path);
      await ref.delete();
    } catch (e) {
      throw Exception('Erro ao deletar arquivo: $e');
    }
  }
}
