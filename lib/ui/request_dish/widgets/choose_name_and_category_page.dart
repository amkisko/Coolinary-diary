import 'package:flutter/material.dart';
import 'package:sqflite_worker/localization/app_translations.dart';
import 'package:sqflite_worker/resourses/module.dart' as App;

import '../module.dart';

class ChooseNameAndCategoryPage extends StatefulWidget {
  final RequestDishViewModelType _viewModel;

  ChooseNameAndCategoryPage(this._viewModel);

  @override
  _ChooseNameAndCategoryPageState createState() =>
      _ChooseNameAndCategoryPageState();
}

class _ChooseNameAndCategoryPageState extends State<ChooseNameAndCategoryPage> {
  final TextEditingController dishNameTextController = TextEditingController();
  String _radioValue = "Soups";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget._viewModel.getPageTitle(context)),
        ),
        body: _buildBody(context));
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: App.Dimens.normalPadding,
            left: App.Dimens.bigPadding,
            right: App.Dimens.bigPadding,
          ),
          child: _buildDishName(context),
        ),
        Padding(
          padding: const EdgeInsets.only(
              top: App.Dimens.normalPadding, left: App.Dimens.normalPadding, right: App.Dimens.normalPadding),
          child: _buildRadioButtons(context),
        )
      ],
    );
  }

  Widget _buildDishName(BuildContext context) {
    return TextFormField(
      controller: dishNameTextController,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          labelText: AppTranslations.of(context)
              .text('dish_name_hint_text_field_request_screen')),
    );
  }

  Widget _buildRadioButtons(BuildContext context) {
    return Column(
      children: [
        _buildRadioButton(context, "Soups", AppTranslations.of(context).text('soups_category_label_common_screens')),
        _buildRadioButton(context, "Main", AppTranslations.of(context).text('main_category_label_common_screens')),
        _buildRadioButton(context, "Salads", AppTranslations.of(context).text('salads_category_label_common_screens')),
        _buildRadioButton(context, "Dessert", AppTranslations.of(context).text('dessert_category_label_common_screens')),
        _buildRadioButton(context, "Drinks", AppTranslations.of(context).text('drinks_category_label_common_screens'))
      ],
    );
  }

  Widget _buildRadioButton(BuildContext context, String value, String label) {
    return Row(
      children: [
        Radio(onChanged: _handleRadioValueChange, value: value, groupValue: _radioValue),
        GestureDetector(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 2.0),
            child: Text(label),
          ),
          onTap: () => _handleRadioValueChange(value),
        )
      ],
    );
  }

  void _handleRadioValueChange(String value) {
    setState(() {
      _radioValue = value;
    });
  }
}
