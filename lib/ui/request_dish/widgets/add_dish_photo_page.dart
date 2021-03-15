import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqflite_worker/localization/app_translations.dart';
import 'package:sqflite_worker/resourses/module.dart' as App;

import '../module.dart';

class AddDishPhotoPage extends StatefulWidget {
  final RequestDishViewModelType _viewModel;

  AddDishPhotoPage(this._viewModel);

  @override
  _AddDishPhotoPageState createState() => _AddDishPhotoPageState();
}

class _AddDishPhotoPageState extends State<AddDishPhotoPage> {
  final ImagePicker _imagePicker = ImagePicker();
  File _image;

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
        _image == null ? _buildStubImage(context) : _buildPickedImage(),
        Padding(
          padding: const EdgeInsets.only(
              left: App.Dimens.normalPadding,
              right: App.Dimens.normalPadding,
              bottom: App.Dimens.smallPadding,
              top: App.Dimens.normalPadding),
          child: _buildSaveButton(context),
        )
      ],
    );
  }

  Widget _buildStubImage(BuildContext context) {
    return Expanded(
        child: GestureDetector(
      child: Container(
        width: double.maxFinite,
        margin: EdgeInsets.only(right: App.Dimens.bigPadding, left: App.Dimens.bigPadding, top: App.Dimens.bigPadding),
        padding: EdgeInsets.only(
            top: App.Dimens.bigPadding,
            bottom: App.Dimens.bigPadding,
            left: App.Dimens.normalPadding,
            right: App.Dimens.normalPadding),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), color: App.Colors.gainsboro),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(right: App.Dimens.smallPadding),
              child: Icon(Icons.camera_alt, size: 72),
            ),
            Padding(
              padding: const EdgeInsets.only(top: App.Dimens.smallPadding),
              child: Text("Upload a dish photo"),
            )
          ],
        ),
      ),
      onTap: () async {
        await _showCameraGalleryDialog(context);
      },
    ));
  }

  Widget _buildPickedImage() {
    return Image.file(_image);
  }

  Widget _buildSaveButton(BuildContext context) {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        child: Text(AppTranslations.of(context).text('add_dish_photo_screen_save_button')),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  Future<void> _showCameraGalleryDialog(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Camera'),
                      onTap: () {
                        _uploadImageFromSource(ImageSource.camera);
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Gallery'),
                    onTap: () {
                      _uploadImageFromSource(ImageSource.gallery);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  _uploadImageFromSource(ImageSource source) async {
    final _pickerImage = await _imagePicker.getImage(source: source);

    setState(() {
      _image = File(_pickerImage.path);
    });
  }
}