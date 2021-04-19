import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sqflite_worker/model/module.dart';
import 'package:sqflite_worker/repository/repositories.dart';
import 'package:sqflite_worker/ui/dish_info/module.dart';
import 'package:sqflite_worker/ui/dish_list/module.dart';

class DishListViewModel implements DishListViewModelType {
  final Injector _injector;
  final RequestDishListType _dishListType;
  DishRepositoryType _repository;
  final _dishListController = BehaviorSubject<List<Dish>>();

  @override
  String testData;

  DishListViewModel(this._injector, this._dishListType) {
    _repository = _injector.get<DishRepositoryType>();
  }

  @override
  void initState() async {
    if (_dishListType == RequestDishListType.myDishes) {
      _repository.getDishes(true).listen((dishesList) {
        _dishListController.sink.add(dishesList);
      });
      testData = "My dishes";
    } else if (_dishListType == RequestDishListType.otherDishes) {
      _repository.getDishes(false).listen((dishesList) {
        dishesList.clear();
        _dishListController.sink.add(dishesList);
      });
      testData = "Other dishes";
    }
  }

  @override
  Stream<List<Dish>> get dishesList => _dishListController.stream;

  @override
  void clickOnItem(BuildContext context, Dish dish) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => DishInfoPage(DishInfoViewModel(_injector, dish))));
  }

  @override
  void onDispose() {
    _dishListController.close();
  }
}
