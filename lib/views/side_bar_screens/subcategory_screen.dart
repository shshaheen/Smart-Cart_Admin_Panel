import 'package:app_web/controllers/category_controller.dart';
import 'package:app_web/controllers/subcategory_controller.dart';
import 'package:app_web/models/category.dart';
import 'package:app_web/views/side_bar_screens/widgets/subcategory_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class SubcategoryScreen extends StatefulWidget {
  static const String id = "subCategoryScreen";
  const SubcategoryScreen({super.key});

  @override
  State<SubcategoryScreen> createState() => _SubcategoryScreenState();
}

class _SubcategoryScreenState extends State<SubcategoryScreen> {
  final SubcategoryController subcategoryController = SubcategoryController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late Future<List<Category>> futureCategories;
  late String name;
  Category? selectedCategory;
  dynamic _image;
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

  @override
  void initState() {
    futureCategories = CategoryController().loadCateegories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                alignment: Alignment.topLeft,
                child: Text(
                  "Sub-Categories",
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
            FutureBuilder(
                future: futureCategories,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text("No Category"),
                    );
                  } else {
                    return DropdownButton<Category>(
                        value: selectedCategory,
                        hint: Text('Select Category'),
                        items: snapshot.data!.map((Category category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(category.name),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCategory = value;
                          });
                          print(selectedCategory!.name);
                        });
                  }
                }),
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
                          : Text("Subcategory Image")),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 200,
                    child: TextFormField(
                      onChanged: (value) {
                        name = value;
                      },
                      validator: (value) {
                        if (value!.isNotEmpty) {
                          return null;
                        } else {
                          return "Please Enter Subcategory name";
                        }
                      },
                      decoration: InputDecoration(
                        labelText: "Enter Subcategory name",
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await subcategoryController.uploadSubCategory(
                            categoryId: selectedCategory!.id,
                            categoryName: selectedCategory!.name,
                            pickedImage: _image,
                            subCategoryName: name,
                            context: context);
                        setState(() {
                          _formKey.currentState!.validate();
                          _image = null;
                        });
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
                  child: Text("Pick Image")),
            ),
            Divider(color: Colors.grey,),
            SubcategoryWidget(),
          ],
        ),
      ),
    );
  }
}
