import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final imageProvider = StateProvider<CameraImage>((ref) => "" as CameraImage);
