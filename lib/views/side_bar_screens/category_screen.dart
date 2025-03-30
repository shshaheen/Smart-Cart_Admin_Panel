import 'package:app_web/controllers/category_controller.dart';
// import 'package:app_web/models/category.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class CategoryScreen extends StatefulWidget {
  static const String id = "/category-screen";
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final CategoryController _categoryController = CategoryController();
  late String categoryName;
  dynamic _image;
  dynamic _bannerImage;
  pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      setState(() {
        _image = result.files.first.bytes;
      });
    } else {
      // User canceled the picking
    }
  }

  pickBannerImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      setState(() {
        _bannerImage = result.files.first.bytes;
      });
    } else {
      // User canceled the picking
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                alignment: Alignment.topLeft,
                child: Text(
                  "Categories",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Divider(
                color: Colors.grey,
              ),
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 12),
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                      child: _image != null
                          ? Image.memory(_image)
                          : Text("Category Image")),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 180,
                    child: TextFormField(
                      onChanged: (value) {
                        categoryName = value;
                      },
                      validator: (value) {
                        if (value!.isNotEmpty) {
                          return null;
                        } else {
                          return "Please Enter category name";
                        }
                      },
                      decoration: InputDecoration(
                        labelText: "Enter category name",
                      ),
                    ),
                  ),
                ),
                TextButton(onPressed: () {}, child: Text("Cancel")),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _categoryController.uploadCategory(
                          name: categoryName,
                          pickedImage:_image, 
                          pickedBanner: _bannerImage,
                          context: BuildContext
                        );
                        print(categoryName);
                      } else {
                        // Show error message
                      }
                    },
                    child: Text(
                      "save",
                      style: TextStyle(color: Colors.white),
                    )),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  pickImage();
                },
                child: Text("Pick Image"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Divider(
                color: Colors.grey,
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 12),
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                child: _bannerImage != null
                    ? Image.memory(_bannerImage)
                    : Text(
                        "Category Banner",
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  pickBannerImage();
                },
                child: Text("Pick Image")),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Divider(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
