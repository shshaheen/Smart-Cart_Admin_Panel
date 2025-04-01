import 'package:app_web/global_variable.dart';
import 'package:app_web/models/subcategory.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:http/http.dart' as http;
import 'package:app_web/services/manage_http_response.dart';
import 'dart:convert';

class SubcategoryController {
  uploadSubCategory(
      {required String categoryId,
      required String categoryName,
      required dynamic pickedImage,
      required String subCategoryName,
      required context}) async {
    try {
      final cloudinary = CloudinaryPublic("dvlvqsufy", "yykjowx6");

      CloudinaryResponse imageResponse = await cloudinary.uploadFile(
        CloudinaryFile.fromBytesData(pickedImage,
            identifier: 'pickedImage', folder: 'categoryImages'),
      );
      String image = imageResponse.secureUrl;

      Subcategory subcategory = Subcategory(
          id: '',
          categoryId: categoryId,
          categoryName: categoryName,
          image: image,
          subCategoryName: subCategoryName);

      http.Response response = await http.post(
        Uri.parse("$uri/api/subcategories"),
        body: subcategory.toJson(),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8"
        },
      );

      manageHttpResponse(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(context, "Uploaded Subcategory");
          });
      // Save the category details to the database or use it in the app.
      // print("Image URL: $image");
      // print("Banner URL: $banner");
    } catch (e) {
      print("Error: ${e}" );
      // print("Error uploading to cloudinary: ");
    }
  }

  //load the uploaded sub-categories from the database
  Future<List<Subcategory>> loadSubcateegories() async {
    try {
      // send an http get request to load the categories
      http.Response response = await http
          .get(Uri.parse('$uri/api/subcategories'), headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      });
      // print(response.body);
      if (response.statusCode == 200) {
        //OK
        List<dynamic> data = jsonDecode(response.body);
        List<Subcategory> subcategories =
            data.map((item) => Subcategory.fromJson(item)).toList();
        return subcategories;
      } else {
        //throw an exception if the server responded with an error status code
        throw Exception('Failed to load Sub-Categories: ');
      }
    } catch (e, stacktrace) {
      print("Error loading banners: $e");
      print("StackTrace: $stacktrace");
      throw Exception("Error Loading categories: ");
    }
  }
}
