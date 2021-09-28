import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:ext_storage/ext_storage.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lazywall/controllers/downloadprogress.dart';
import 'package:lazywall/widgets/icon_widget.dart';

class WallpaperView extends StatefulWidget {
  final String imageURL;
  final int viewCount;
  final int likecount;
  final int downloadCount;
  final int id;
  const WallpaperView({
    Key? key,
    required this.imageURL,
    required this.viewCount,
    required this.likecount,
    required this.downloadCount,
    required this.id,
  }) : super(key: key);

  @override
  State<WallpaperView> createState() => _WallpaperViewState();
}

class _WallpaperViewState extends State<WallpaperView> {
  DownloadProgressController controller = Get.put(DownloadProgressController());

  @override
  Widget build(BuildContext context) {
    controller.progress.value = 0.0;
    controller.isDownloaded.value = false;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Colors.greenAccent, Colors.blue]),
          ),
        ),
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
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  gradient:
                      LinearGradient(colors: [Colors.greenAccent, Colors.blue]),
                ),
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
                          iconColor: Colors.black,
                          count: widget.viewCount,
                        ),
                      ],
                    ),
                    MaterialButton(
                        color: Colors.white,
                        minWidth: MediaQuery.of(context).size.width / 2,
                        height: 60,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        onPressed: () async {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                    title: const Text('Downloading'),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    content: Obx(
                                      () => SizedBox(
                                        height: 100,
                                        width: 200,
                                        child: Column(
                                          children: [
                                            const CircularProgressIndicator(
                                              color: Colors.greenAccent,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                  '${controller.progress.toStringAsFixed(0)} %'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ));
                              });
                          await controller.download(widget.imageURL, widget.id);
                          Get.back();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Downloaded,path:downloads/${widget.id}.jpg',
                              ),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                        child: const Icon(Icons.download))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
