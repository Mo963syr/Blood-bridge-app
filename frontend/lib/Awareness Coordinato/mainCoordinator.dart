import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:video_player/video_player.dart';
import '../home_page.dart';

class AwarenessCoordinatorPage extends StatefulWidget {
  @override
  _AwarenessCoordinatorPageState createState() =>
      _AwarenessCoordinatorPageState();
}

class _AwarenessCoordinatorPageState extends State<AwarenessCoordinatorPage> {
  TextEditingController _controller = TextEditingController();
  File? _image;
  File? _video; // لتخزين الفيديو المحمل
  final picker = ImagePicker();
  VideoPlayerController? _videoController; // للتحكم في الفيديو

  // لاختيار صورة
  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // لاختيار فيديو
  Future<void> _pickVideo() async {
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _video = File(pickedFile.path);
        _videoController = VideoPlayerController.file(_video!)
          ..initialize().then((_) {
            setState(() {});
            _videoController!.play();
          });
      });
    }
  }

  // إضافة المنشور
  void _addPost() {
    if (_controller.text.isNotEmpty || _image != null || _video != null) {
      Provider.of<ThemeProvider>(context, listen: false).addPost(
          {'text': _controller.text, 'image': _image, 'video': _video});
      _controller.clear();
      setState(() {
        _image = null;
        _video = null;
      });
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _videoController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('إضافة منشور توعوي'),
        backgroundColor: Colors.red[400],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'اكتب منشور توعوي هنا...',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(10),
              ),
            ),
            SizedBox(height: 16),
            // زر لاختيار صورة
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('اختيار صورة'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[400],
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              ),
            ),
            // زر لاختيار فيديو
            ElevatedButton(
              onPressed: _pickVideo,
              child: Text('اختيار فيديو'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[400],
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              ),
            ),
            // عرض الصورة المحملة
            _image != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Image.file(
                      _image!,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  )
                : Container(),
            // عرض الفيديو المحمل
            _video != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: _videoController != null &&
                            _videoController!.value.isInitialized
                        ? AspectRatio(
                            aspectRatio: _videoController!.value.aspectRatio,
                            child: VideoPlayer(_videoController!),
                          )
                        : Container(),
                  )
                : Container(),
            // زر لنشر المنشور
            ElevatedButton(
              onPressed: _addPost,
              child: Text('إضافة منشور'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[400],
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
