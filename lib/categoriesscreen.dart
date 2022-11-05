import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sqflite_crud_sample/src/models/category.dart';
import 'package:sqflite_crud_sample/src/models/inscategory.dart';
import 'package:sqflite_crud_sample/src/service/categoryservice.dart';

class CategoriesaScreen extends StatefulWidget {
  const CategoriesaScreen({super.key});

  @override
  State<CategoriesaScreen> createState() => _CategoriesaScreenState();
}

class _CategoriesaScreenState extends State<CategoriesaScreen> {
  var _categoryNameController = TextEditingController();
  var _categorydescription = TextEditingController();

  var _category = Category();
  var _inscategory = InsCategory();
  var _categopryservice = CategoryService();

  var _editcategoryNameController = TextEditingController();
  var _editcategorydescription = TextEditingController();

  List<Category> _categorylist = <Category>[];

  var categorydata;

  @override
  void initState() {
    super.initState();
    getAllCategories();
  }

  getAllCategories() async {
    _categorylist = <Category>[];

    var category = await _categopryservice.readCategory();

    category.forEach((category) {
      setState(() {
        var categorymodel = Category();
        categorymodel.name = category['name'];
        categorymodel.description = category['description'];
        categorymodel.id = category['id'];
        _categorylist.add(categorymodel);
      });
    });
  }

  _editCategory(BuildContext context, categoryId) async {
    categorydata = await _categopryservice.readCategoryById(categoryId);
    setState(() {
      _editcategoryNameController.text =
          categorydata[0]['name'] ?? 'empty name';
      _editcategorydescription.text =
          categorydata[0]['description'] ?? 'empty desc';
    });

    _showeditdialog(context);
  }

  _showformdialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: <Widget>[
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel")),
              TextButton(
                  onPressed: () async {
                    _inscategory.name = _categoryNameController.text;
                    _inscategory.description = _categorydescription.text;
                    var result =
                        await _categopryservice.saveCategory(_inscategory);
                    if (result > 0) {
                      print(result);
                      Navigator.pop(context);
                      getAllCategories();
                    }
                  },
                  child: Text("Save"))
            ],
            title: Text("Add Category"),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _categoryNameController,
                    decoration: InputDecoration(
                        hintText: "Name", labelText: 'Category Name'),
                  ),
                  TextField(
                    controller: _categorydescription,
                    decoration: InputDecoration(
                        hintText: "Description",
                        labelText: 'Category Description'),
                  ),
                ],
              ),
            ),
          );
        });
  }

  _showeditdialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: <Widget>[
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel")),
              TextButton(
                  onPressed: () async {
                    _category.id = categorydata[0]['id'];
                    _category.name = _editcategoryNameController.text;
                    _category.description = _editcategorydescription.text;
                    var result =
                        await _categopryservice.updateCategory(_category);
                    if (result > 0) {
                      print(result);
                      Navigator.pop(context);
                      getAllCategories();
                    }
                  },
                  child: Text("Update"))
            ],
            title: Text("Edit Category"),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _editcategoryNameController,
                    decoration: InputDecoration(
                        hintText: "Name", labelText: 'Category Name'),
                  ),
                  TextField(
                    controller: _editcategorydescription,
                    decoration: InputDecoration(
                        hintText: "Description",
                        labelText: 'Category Description'),
                  ),
                ],
              ),
            ),
          );
        });
  }

  _showdeleteformdialog(BuildContext context, categoryId) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: <Widget>[
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel")),
              TextButton(
                  onPressed: () async {
                    _category.name = _categoryNameController.text;
                    _category.description = _categorydescription.text;
                    var result =
                        await _categopryservice.deleteCategory(categoryId);
                    if (result > 0) {
                      print(result);
                      Navigator.pop(context);
                      _categorylist.clear();
                      // getAllCategories();
                    }
                  },
                  child: Text("Delete"))
            ],
            content: SingleChildScrollView(
                child: Text("Do you really want to delete ?")),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Categories"),
      ),
      body: _categorylist.isEmpty
          ? Center(
              child: Text("No Categories Found"),
            )
          : ListView.builder(
              itemCount: _categorylist.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: IconButton(
                        onPressed: () {
                          _editCategory(context, _categorylist[index].id);
                        },
                        icon: Icon(
                          Icons.edit,
                        )),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(_categorylist[index].name),
                        IconButton(
                            onPressed: () {
                              _showdeleteformdialog(
                                  context, _categorylist[index].id);
                            },
                            icon: Icon(Icons.delete))
                      ],
                    ),
                  ),
                );
              }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showformdialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
