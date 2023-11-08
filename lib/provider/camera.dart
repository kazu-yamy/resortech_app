import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final cameraProvider =
    StateProvider<Future<List<CameraDescription>>>((ref) async {
  return await availableCameras();
});
