import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:ext_storage/ext_storage.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lazywall/widgets/icon_widget.dart';

class WallpaperView extends StatefulWidget {
  final String imageURL;
  final int viewCount;
  final int likecount;
  final int downloadCount;
  const WallpaperView({
    Key? key,
    required this.imageURL,
    required this.viewCount,
    required this.likecount,
    required this.downloadCount,
  }) : super(key: key);

  @override
  State<WallpaperView> createState() => _WallpaperViewState();
}

class _WallpaperViewState extends State<WallpaperView> {
  Progress controller = Get.put(Progress());
  @override
  Widget build(BuildContext context) {
    controller.progress.value = 0.0;
    controller.isDownloaded.value = false;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Image'),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              flex: 4,
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
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconWidget(
                        text: 'Likes',
                        icon: FontAwesomeIcons.solidHeart,
                        iconColor: Colors.red,
                        count: widget.likecount,
                      ),
                      IconWidget(
                        text: 'Downloads',
                        icon: FontAwesomeIcons.fileDownload,
                        iconColor: Colors.greenAccent,
                        count: widget.downloadCount,
                      ),
                      IconWidget(
                        text: 'Views',
                        icon: FontAwesomeIcons.solidEye,
                        iconColor: Colors.blue,
                        count: widget.viewCount,
                      ),
                    ],
                  ),
                  MaterialButton(
                    onPressed: () async {
                      await controller.download(widget.imageURL);
                    },
                    child: Obx(
                      () => Text('${controller.progress}'),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Progress extends GetxController {
  var progress = 0.0.obs;
  var isDownloaded = false.obs;

  download(String url) async {
    final dio = Dio();
    try {
      var path = await ExtStorage.getExternalStoragePublicDirectory(
          ExtStorage.DIRECTORY_DOWNLOADS);
      await dio.download(url, "$path/img.jpg",
          onReceiveProgress: (received, total) {
        progress.value = (received / total) * 100;
        if (progress.value == 100) {
          isDownloaded.value = true;
        }
      });
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }
}
