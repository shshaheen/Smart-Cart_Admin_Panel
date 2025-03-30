import 'package:app_web/global_variable.dart';
import 'package:app_web/models/banner.dart';
import 'package:app_web/services/manage_http_response.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:http/http.dart' as http;

class BannerController {
  uploadBanner({required dynamic pickedImage, required context}) async {
    try {
      final cloudinary = CloudinaryPublic("dvlvqsufy", "yykjowx6");
      CloudinaryResponse imageResponses = await cloudinary.uploadFile(
        CloudinaryFile.fromBytesData(pickedImage,
            identifier: "pickedImage", folder: "banners"),
      );
      String image = imageResponses.secureUrl;

      BannerModel bannerModel = BannerModel(id: '', image: image);

      http.Response response = await http.post(Uri.parse('$uri/api/banner'),
          body: bannerModel.toJson(),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });
      manageHttpResponse(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(context, "Banner Uploaded Successfully");
          });
    } catch (e) {
      print("Error uploading banner: $e");
      showSnackBar(context, "Error uploading banner");  
    }
  }
}
