import 'dart:convert';

import 'package:app_web/global_variable.dart';
import 'package:app_web/models/category.dart';
import 'package:app_web/services/manage_http_response.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:http/http.dart' as http;

class CategoryController {
  uploadCategory(
      {required dynamic pickedImage,
      required dynamic pickedBanner,
      required String name,
      required context}) async {
    try {
      final cloudinary = CloudinaryPublic("dvlvqsufy", "yykjowx6");

      CloudinaryResponse imageResponse = await cloudinary.uploadFile(
        CloudinaryFile.fromBytesData(pickedImage,
            identifier: 'pickedImage', folder: 'categoryImages'),
      );
      String image = imageResponse.secureUrl;

      CloudinaryResponse bannerResponse = await cloudinary.uploadFile(
        CloudinaryFile.fromBytesData(pickedBanner,
            identifier: "pickedBanner", folder: "categoryBanners"),
      );
      String banner = bannerResponse.secureUrl;

      Category category =
          Category(id: "", name: name, image: image, banner: banner);
      http.Response response = await http.post(
        Uri.parse("$uri/api/categories"),
        body: category.toJson(),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8"
        },
      );

      manageHttpResponse(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(context, "Uploaded category");
          }
        );
      // Save the category details to the database or use it in the app.
      // print("Image URL: $image");
      // print("Banner URL: $banner");
    } catch (e) {
      // print("Error uploading to cloudinary: ");
    }
  }

  // load the uploaded categories from the database
  Future<List<Category>> loadCateegories() async {
    try {
      // send an http get request to load the categories
      http.Response response = await http
          .get(Uri.parse('$uri/api/categories'), headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      });
      print(response.body);
      if (response.statusCode == 200) {
        //OK
        List<dynamic> data = jsonDecode(response.body);
        List<Category> categories =
            data.map((item) => Category.fromJson(item)).toList();
        return categories;
      } else {
        //throw an exception if the server responded with an error status code
        throw Exception('Failed to load Categories: ');
      }
    } catch (e,stacktrace) {
      print("Error loading banners: $e");
    print("StackTrace: $stacktrace");
      throw Exception("Error Loading categories: ");
    }
  }
}
