import 'package:flutter/material.dart';

class WallpaperView extends StatelessWidget {
  final String imageURL;
  const WallpaperView({Key? key, required this.imageURL}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image'),
      ),
      body: Center(
        child: Image.network(
          imageURL,
          loadingBuilder: (context, child, loading) {
            if (loading == null) {
              return child;
            } else {
              return CircularProgressIndicator(
                value: loading.expectedTotalBytes != null
                    ? loading.cumulativeBytesLoaded /
                        loading.expectedTotalBytes!.toInt()
                    : null,
              );
            }
          },
        ),
      ),
    );
  }
}
