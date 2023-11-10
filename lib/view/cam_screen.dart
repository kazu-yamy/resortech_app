import 'dart:async';
import 'dart:convert';

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
    final percent = ref.watch(percentProvider);
    final result = ref.watch(resultProvider);

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
            await controller.setFlashMode(FlashMode.off);
            cameraController.value = controller;
            timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
              if (!isCancelled) {
                try {
                  XFile image = await controller.takePicture();
                  var response =
                      await ResortechRepository.postImage(image.path);
                  Map<String, dynamic> convert = jsonDecode(response.body);
                  ref.read(resultProvider.notifier).state =
                      convert["result"][0];
                  ref.read(percentProvider.notifier).state =
                      convert["result"][1].toString();
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
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: CameraPreview(
              controller,
              child: Row(
                children: <Widget>[
                  Text(
                    result,
                    style: const TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.w900,
                      backgroundColor: Colors.greenAccent,
                    ),
                  ),
                  Text(
                    "$percent%",
                    style: const TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.w900,
                      backgroundColor: Colors.redAccent,
                    ),
                  ),
                ],
              ),
            ),
          )
      ],
    );
  }
}
