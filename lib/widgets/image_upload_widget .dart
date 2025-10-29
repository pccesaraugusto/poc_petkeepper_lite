import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:poc_petkeepper_lite/providers/storage_service_provider.dart';

class ImageUploadWidget extends ConsumerStatefulWidget {
  final String
      imagePath; // Caminho no Storage Firebase, ex: 'pet_photos/petId.jpg'

  const ImageUploadWidget({super.key, required this.imagePath});

  @override
  ConsumerState<ImageUploadWidget> createState() => _ImageUploadWidgetState();
}

class _ImageUploadWidgetState extends ConsumerState<ImageUploadWidget> {
  String? _downloadUrl;
  bool _isLoading = false;

  Future<void> _loadImageUrl() async {
    try {
      final storageService = ref.read(storageServiceProvider);
      // final url = await storageService.getFileUrl(widget.imagePath);
      setState(() {
        // _downloadUrl = url;
      });
    } catch (e) {
      setState(() {
        _downloadUrl = null;
      });
    }
  }

  Future<void> _uploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final storageService = ref.read(storageServiceProvider);
      final url = await storageService.uploadFile(
        File(pickedFile.path) as String,
        widget.imagePath as File,
      );
      setState(() {
        _downloadUrl = url;
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erro ao fazer upload: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteImage() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final storageService = ref.read(storageServiceProvider);
      await storageService.deleteFile(widget.imagePath);
      setState(() {
        _downloadUrl = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erro ao deletar: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadImageUrl();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_downloadUrl != null) Image.network(_downloadUrl!, height: 150),
        if (_downloadUrl == null && !_isLoading)
          const Text('Nenhuma imagem disponível'),
        if (_isLoading) const CircularProgressIndicator(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _isLoading ? null : _uploadImage,
              child: const Text('Selecionar/Enviar Foto'),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed:
                  (_isLoading || _downloadUrl == null) ? null : _deleteImage,
              child: const Text('Excluir Foto'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        ),
      ],
    );
  }
}
