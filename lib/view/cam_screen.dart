import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:camera/camera.dart';
import 'package:resortech_app/infrastructure/resortech_repository.dart';
import 'package:resortech_app/provider/controller.dart';
import 'package:resortech_app/provider/initialized.dart';
import 'package:resortech_app/provider/response.dart';

class CameraScreen extends HookConsumerWidget {
  const CameraScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cameraControllerFuture = ref.watch(controllerProvider);
    final response = ref.watch(responseProvider);

    // コントローラーの状態を管理するためのuseStateフック
    final cameraController = useState<CameraController?>(null);

    useEffect(() {
      bool isCancelled = false;
      Timer timer = Timer.periodic(const Duration(microseconds: 1), (timer) {});

      // 非同期処理を実行
      Future<void> initializeCamera() async {
        try {
          // プロバイダからカメラコントローラーを取得
          final controller = await cameraControllerFuture;
          // コントローラーがキャンセルされていなければ状態を更新
          if (!isCancelled) {
            await controller.initialize();
            cameraController.value = controller;
            timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
              if (!isCancelled) {
                try {
                  XFile image = await controller.takePicture();
                  var response =
                      await ResortechRepository.postImage(image.path);
                  ref.read(responseProvider.notifier).state = response.body;
                } on CameraException catch (e) {
                  debugPrint(e.toString());
                }
              }
            });
          }
        } catch (e) {
          if (!isCancelled) {}
        }
      }

      // カメラ初期化処理を呼び出す
      initializeCamera();

      // クリーンアップ関数
      return () {
        isCancelled = true;
        cameraController.value?.dispose();
        timer.cancel();
      };
    }, const []);

    if (ref.watch(initializedProvider) || cameraController.value == null) {
      return const CircularProgressIndicator();
    }

    final controller = cameraController.value!;
    return Column(
      children: <Widget>[
        if (controller.value.isInitialized)
          AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: Column(
                children: [
                  CameraPreview(
                    controller,
                    child: Text(response),
                  )
                ],
              )),
      ],
    );
  }
}
