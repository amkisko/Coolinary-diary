import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqflite_worker/model/dish.dart';
import 'package:sqflite_worker/resourses/strings.dart';
import 'package:sqflite_worker/utils/database_helper.dart';
import 'package:sqflite_worker/utils/utils.dart';
import 'package:sqflite_worker/widgets/camera_alert_dialog.dart';
import 'package:sqflite_worker/widgets/image_addition_dish_widget.dart';
import 'package:sqflite_worker/widgets/multiline_text_field.dart';

typedef void Callback();

class AddDish extends StatefulWidget {
  final Callback callback;

  AddDish(this.callback);

  @override
  _AddDishState createState() => _AddDishState();
}

class _AddDishState extends State<AddDish> {
  var nameController = new TextEditingController();
  var cookingListController = new TextEditingController();
  var ingredientListController = new TextEditingController();
  String category;
  List<DropdownMenuItem<String>> _dropDownMenuItems;
  DatabaseHelper databaseHelper = new DatabaseHelper();
  bool validateName = false;
  bool validateCookingList = false;
  bool validateIngredient = false;
  File image;

  @override
  void initState() {
    _initControllers();
    _dropDownMenuItems = getDropDownMenuItems();
    category = _dropDownMenuItems[0].value;
  }

  void _initControllers() {
    nameController.addListener(() {
      setState(() {
        validateName = Utils.getValidation(nameController.text);
      });
    });

    cookingListController.addListener(() {
      setState(() {
        validateCookingList = Utils.getValidation(cookingListController.text);
      });
    });

    ingredientListController.addListener(() {
      setState(() {
        validateIngredient = Utils.getValidation(ingredientListController.text);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text("Add dish"),
      ),
      body: Builder(
        builder: (context) => SingleChildScrollView(
              child: Container(
                  child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: _getWidgetWithPadding(MultiLineTextField(
                            "Name", validateName, nameController, 1)),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: ImageNewDish(
                            image: image,
                            onPressed: _showDialog,
                          )),
                      Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: DropdownButton(
                          value: category,
                          items: _dropDownMenuItems,
                          onChanged: _changeDropDownItem,
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: _getWidgetWithPadding(MultiLineTextField(
                            "Cooking list",
                            validateCookingList,
                            cookingListController,
                            4)),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: _getWidgetWithPadding(MultiLineTextField(
                            "Ingredient list",
                            validateIngredient,
                            ingredientListController,
                            4)),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, right: 16.0, top: 8.0),
                    child: SizedBox(
                      height: 48,
                      width: double.infinity,
                      child: RaisedButton(
                        color: Colors.grey,
                        child: new Text("Add dish"),
                        onPressed: () {
                          _onClickAddDish(context);
                        },
                      ),
                    ),
                  )
                ],
              )),
            ),
      ),
    );
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String category in listCategories) {
      items.add(new DropdownMenuItem(
          value: category,
          child: new Text(
            category,
            style: new TextStyle(fontSize: 18.0),
          )));
    }

    return items;
  }

  Widget _getWidgetWithPadding(Widget widget) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
      child: widget,
    );
  }

  bool _isValidAllField() {
    if (validateName && validateIngredient && validateCookingList) {
      return true;
    } else {
      return false;
    }
  }

  void _changeDropDownItem(String selectedCategory) {
    setState(() {
      category = selectedCategory;
    });
  }

  void _onClickAddDish(var context) {
    if (_isValidAllField() && image != null) {
      _insertDishFromFields();
    } else {
      _showSnackbarError(context);
    }
  }

  void _insertDishFromFields() async {
    int result = await databaseHelper.insertDish(_getDishFromFields());
    if (result != 0) {
      widget.callback();
      Navigator.pop(context);
    }
  }

  Dish _getDishFromFields() {
    return new Dish(nameController.text, 0, category,
        ingredientListController.text, cookingListController.text, image.path);
  }

  void _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CameraAlertDialog(
              "Camera", "Gallery", _clickOnCamera, _clickOnGallery);
        });
  }

  void _clickOnCamera() async {
    Navigator.pop(context);
    image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {});
  }

  void _clickOnGallery() async {
    Navigator.pop(context);
    image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }

  void _showSnackbarError(var context) {
    final snackbar = new SnackBar(
      content: Text("You need to fill all fields and add photo"),
    );
    Scaffold.of(context).showSnackBar(snackbar);
  }
}
