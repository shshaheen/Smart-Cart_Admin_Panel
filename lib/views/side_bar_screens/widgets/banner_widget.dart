import 'package:app_web/controllers/banner_controller.dart';
import 'package:app_web/models/banner.dart';
import 'package:flutter/material.dart';

class BannerWidget extends StatefulWidget {
  const BannerWidget({super.key});

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  late Future<List<BannerModel>> futurebanners;

  @override
  void initState() {
    super.initState();
    futurebanners = BannerController().loadBanners();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BannerModel>>(
      future: futurebanners,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('An error occurred: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No banners available'));
        } else {
          final banners = snapshot.data!;
          return SizedBox(
            height: 200, // 👈 ensure bounded height
            child: PageView.builder(
              itemCount: banners.length,
              itemBuilder: (context, index) {
                final banner = banners[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(
                    banner.image,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}
