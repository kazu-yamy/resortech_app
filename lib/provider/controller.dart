import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:resortech_app/provider/camera.dart';

final controllerProvider = StateProvider<Future<CameraController>>((ref) async {
  List<CameraDescription> cameras = await ref.watch(cameraProvider);
  return CameraController(cameras[1], ResolutionPreset.high);
});
