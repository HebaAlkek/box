import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/base/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/category.dart';
import 'package:flutter_sixvalley_ecommerce/data/repository/category_repo.dart';
import 'package:flutter_sixvalley_ecommerce/helper/api_checker.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryRepo categoryRepo;

  CategoryProvider({@required this.categoryRepo});


  List<Category> _categoryList = [];
  List<Category> _categoryListFirst = [];

  int _categorySelectedIndex;

  List<Category> get categoryList => _categoryList;
  int get categorySelectedIndex => _categorySelectedIndex;

  Future<void> getCategoryList(bool reload, BuildContext context) async {
    if (_categoryList.length == 0 || reload) {
      ApiResponse apiResponse = await categoryRepo.getCategoryList();
      if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
        _categoryList.clear();
        _categoryListFirst.clear();
        apiResponse.response.data.forEach((category) => _categoryListFirst.add(Category.fromJson(category)));
        _categorySelectedIndex = 0;
        for(int i=0;i<_categoryListFirst.length;i++){
          if(_categoryListFirst[i].homeStatus==1){
            _categoryList.add(_categoryListFirst[i]);
          }
        }
        _categorySelectedIndex = 0;
      } else {
        ApiChecker.checkApi(context, apiResponse,'0');
      }
      notifyListeners();
    }
  }

  void changeSelectedIndex(int selectedIndex) {
    _categorySelectedIndex = selectedIndex;
    notifyListeners();
  }
}
