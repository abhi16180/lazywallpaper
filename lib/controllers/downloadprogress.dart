import 'package:dio/dio.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class DownloadProgressController extends GetxController {
  var progress = 0.0.obs;
  var isDownloaded = false.obs;
  var isTapped = false.obs;

  download(String url, int id) async {
    final dio = Dio();
    try {
      var path = await ExtStorage.getExternalStoragePublicDirectory(
          ExtStorage.DIRECTORY_DOWNLOADS);
      await dio.download(url, "$path/$id.jpg",
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

  buttonClickAction() {
    isTapped.value = !isTapped.value;
  }
}
