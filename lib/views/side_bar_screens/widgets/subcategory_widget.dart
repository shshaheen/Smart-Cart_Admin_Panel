import 'package:app_web/controllers/subcategory_controller.dart';
import 'package:app_web/models/subcategory.dart';
import 'package:flutter/material.dart';
// import 'package:app_web/controllers/category_controller.dart';
// import 'package:app_web/models/category.dart';

class SubcategoryWidget extends StatefulWidget {
  const SubcategoryWidget({super.key});

  @override
  State<SubcategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<SubcategoryWidget> {
  // A future that will hold the list of categories once loaded from the API

  late Future<List<Subcategory>> futureSubcategories;

  @override
  void initState() {
    super.initState();
    futureSubcategories = SubcategoryController().loadSubcateegories();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: futureSubcategories, builder: (context, snapshot){
      if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // print(snapshot);
            return Center(child: Text('An error occurred: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No sub-categories available'));
          } else {
            final subcategories = snapshot.data!;
            return GridView.builder(
                shrinkWrap: true,
                itemCount: subcategories.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6, 
                    crossAxisSpacing: 8, 
                    mainAxisSpacing: 8
                  ),
                itemBuilder: (context, index) {
                  final subcategory = subcategories[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Image.network(
                          subcategory.image,
                          height: 100,
                          width: 100,
                        ),
                        Text(subcategory.subCategoryName),
                      ],
                    ),
                  );
                });
          }
    });
  }
}
