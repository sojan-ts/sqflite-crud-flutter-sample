import 'package:sqflite_crud_sample/src/models/category.dart';
import 'package:sqflite_crud_sample/src/models/inscategory.dart';
import 'package:sqflite_crud_sample/src/repository/repository.dart';

class CategoryService {
  late Repository _repository;

  CategoryService() {
    _repository = Repository();
  }

  saveCategory(InsCategory category) async {
    // print(category.name);
    // print(category.description);
    return await _repository.insertData(
        'categories', category.InsCategoryMap());
  }

  readCategory() async {
    return await _repository.readData('categories');
  }

  readCategoryById(categoryId) async {
    return await _repository.readDataById('categories', categoryId);
  }

  updateCategory(Category category) async {
    return await _repository.updateData('categories', category.CategoryMap());
  }

  deleteCategory(categoryId) async {
    return await _repository.deleteData('categories', categoryId);
  }
}
