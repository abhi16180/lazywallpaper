import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:ext_storage/ext_storage.dart';
import 'package:get/get.dart';

class WallpaperView extends StatefulWidget {
  final String imageURL;
  const WallpaperView({
    Key? key,
    required this.imageURL,
  }) : super(key: key);

  @override
  State<WallpaperView> createState() => _WallpaperViewState();
}

class _WallpaperViewState extends State<WallpaperView> {
  var dio = Dio();
  String t = "download";
  var progress = 0.0.obs;
  Progress controller = Get.put(Progress());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image'),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Image.network(
                widget.imageURL,
                loadingBuilder: (context, child, loading) {
                  if (loading == null) {
                    return child;
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        value: loading.expectedTotalBytes != null
                            ? loading.cumulativeBytesLoaded /
                                loading.expectedTotalBytes!.toInt()
                            : null,
                      ),
                    );
                  }
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: MaterialButton(
                  onPressed: () async {
                    await _download();
                  },
                  child: Obx(
                    () => Text('${progress}'),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  _download() async {
    final dio = Dio();
    try {
      var path = await ExtStorage.getExternalStoragePublicDirectory(
          ExtStorage.DIRECTORY_DOWNLOADS);
      await dio.download(widget.imageURL, "$path/img.jpg",
          onReceiveProgress: (received, total) {
        progress.value = (received / total * 100);
      });
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }
}

class Progress extends GetxController {
  var progress = 0.0.obs;
  download(String url) async {
    final dio = Dio();
    try {
      var path = await ExtStorage.getExternalStoragePublicDirectory(
          ExtStorage.DIRECTORY_DOWNLOADS);
      await dio.download(url, "$path/img.jpg",
          onReceiveProgress: (received, total) {
        progress.value = (received / total) * 100;
      });
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }
}
