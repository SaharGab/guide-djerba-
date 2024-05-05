import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:projet_pfe/apis/recognition_api.dart';
import 'package:projet_pfe/apis/translation_api.dart';

class TranslationPage extends StatefulWidget {
  final CameraDescription camera;
  const TranslationPage({required this.camera, super.key});

  @override
  State<TranslationPage> createState() => _TranslationPageState();
}

class _TranslationPageState extends State<TranslationPage> {
  late CameraController cameraController;
  late Future<void> initCameraFn;
  String? shownText;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cameraController = CameraController(widget.camera, ResolutionPreset.max);
    initCameraFn = cameraController
        .initialize()
        .then((value) => cameraController.setFlashMode(FlashMode.off));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    cameraController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        FutureBuilder(
          future: initCameraFn,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }
            return SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: CameraPreview(cameraController),
            );
          },
        ),
        Positioned(
          bottom: 30,
          child: FloatingActionButton(
            onPressed: () async {
              final image = await cameraController.takePicture();
              final recognizedText = await RecognitionApi.recognizeText(
                InputImage.fromFile(
                  File(image.path),
                ),
              );
              if (recognizedText == null) return;
              final translatedText =
                  await TranslateApi.translateText(recognizedText);
              setState(() {
                shownText = translatedText;
              });
            },
            child: const Icon(Icons.translate_rounded),
          ),
        ),
        if (shownText != null)
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black45,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    shownText!,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
