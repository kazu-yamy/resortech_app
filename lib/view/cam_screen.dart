import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:camera/camera.dart';
import 'package:resortech_app/provider/controller.dart';
import 'package:resortech_app/provider/image.dart';
import 'package:resortech_app/provider/initialized.dart';

class CameraScreen extends HookConsumerWidget {
  const CameraScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cameraControllerFuture = ref.watch(controllerProvider);

    // コントローラーの状態を管理するためのuseStateフック
    final cameraController = useState<CameraController?>(null);

    useEffect(() {
      bool isCancelled = false;

      // 非同期処理を実行
      Future<void> initializeCamera() async {
        try {
          // プロバイダからカメラコントローラーを取得
          final controller = await cameraControllerFuture;
          // コントローラーがキャンセルされていなければ状態を更新
          if (!isCancelled) {
            await controller.initialize();
            cameraController.value = controller;
            controller.startImageStream((image) {
              ref.read(imageProvider.notifier).state = image;
            });
          }
        } catch (e) {
          if (!isCancelled) {
            print("asdlkjfalksdjfa;lkjsdf;lkajsdflk");
          }
        }
      }

      // カメラ初期化処理を呼び出す
      initializeCamera();

      // クリーンアップ関数
      return () {
        isCancelled = true;
        cameraController.value?.dispose();
      };
    }, const []);

    if (!ref.watch(initializedProvider) || cameraController.value == null) {
      return const CircularProgressIndicator();
    }

    final controller = cameraController.value!;
    return Column(
      children: <Widget>[
        if (controller.value.isInitialized)
          AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: const Text("sdafasdf"),
          ),
      ],
    );
  }
}
