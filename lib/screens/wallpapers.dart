import 'dart:convert' as convert;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lazywall/model/wallpapermodel.dart';
import 'package:lazywall/screens/wallpaper_view.dart';

class WallPapers extends StatefulWidget {
  const WallPapers({Key? key}) : super(key: key);

  @override
  _WallPapersState createState() => _WallPapersState();
}

class _WallPapersState extends State<WallPapers> {
  final client = http.Client();
  List finalData = [];
  int page = 1;

  bool isLoading = false;
  RefreshController refreshController = RefreshController(initialRefresh: true);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallpapers'),
      ),
      body: SmartRefresher(
        controller: refreshController,
        scrollDirection: Axis.vertical,
        enablePullUp: true,
        onRefresh: () async {
          await fetchWall(isRefresh: true);
          refreshController.refreshCompleted();
        },
        onLoading: () async {
          await fetchWall();
          refreshController.loadComplete();
        },
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: size.width > 1020 ? 10 : 2),
          itemCount: finalData.length,
          itemBuilder: (context, item) {
            return Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Text('ID:${finalData[item].id.toString()}'),
                ),
                Expanded(
                  flex: 10,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return WallpaperView(
                                imageURL: finalData[item].largeImageURL);
                          },
                        ),
                      );
                    },
                    child: Image(
                      width: 200,
                      height: 400,
                      fit: BoxFit.contain,
                      image: NetworkImage(finalData[item].previewURL),
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  //methods
  Future fetchWall({bool isRefresh = false}) async {
    if (isRefresh) {
      page = 1;
    } else {
      if (page >= 100) {
        refreshController.loadNoData();
        return false;
      }
    }
    print('called');
    final response = await client.get(
      Uri.parse(
          'https://pixabay.com/api/?key=23566879-c93c4d47c3633866a8b592216&'
          '&page=$page'),
    );
    if (response.statusCode == 200) {
      var data = convert.jsonDecode(response.body) as Map<dynamic, dynamic>;
      List listData = data['hits'] as List;

      if (isRefresh) {
        finalData = listData.map((e) => WallPaperModel.fromJson(e)).toList();
      } else {
        finalData
            .addAll(listData.map((e) => WallPaperModel.fromJson(e)).toList());
      }

      page++;
      setState(() {});
      return true;
    } else {
      return false;
    }
  }
}
