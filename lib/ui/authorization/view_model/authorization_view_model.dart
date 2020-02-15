import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:injector/injector.dart';
import 'package:sqflite_worker/model/authorization_type.dart';
import 'package:sqflite_worker/model/module.dart';
import 'package:sqflite_worker/providers/module.dart';
import 'package:sqflite_worker/services/module.dart';
import 'package:sqflite_worker/ui/authorization/module.dart';
import 'package:sqflite_worker/ui/dialogs/module.dart';
import 'package:sqflite_worker/ui/home/module.dart';
import 'package:sqflite_worker/utils/converters/converters.dart';
import 'package:sqflite_worker/utils/validators/validators.dart' as Validators;

class AuthorizationViewModel implements AuthorizationViewModelType {
  @override
  AuthorizationType get authorizationType => _authorizationType;

  @override
  String get textAuthorizationButton => _textAuthorizationButton;

  @override
  String get textNavigationLabel => _textNavigationLabel;

  @override
  bool get isSignUpScreen => _authorizationType == AuthorizationType.signUp;

  @override
  String get titleScreen => _titleScreen;

  final Injector _injector;
  final AuthorizationType _authorizationType;
  String _textAuthorizationButton;
  String _textNavigationLabel;
  String _titleScreen;
  AuthorizationServiceType _authorizationService;
  UserProviderType _userProvider;
  Validators.ValidationStatusAuthorizationType _validationStatusAuthorization;
  ValidationAuthorizationConverterType _validationAuthorizationConverter;

  AuthorizationViewModel(this._injector, this._authorizationType) {
    _authorizationService = _injector.getDependency<AuthorizationServiceType>();
    _userProvider = _injector.getDependency<UserProviderType>();
    if (_authorizationType == AuthorizationType.signIn) {
      this._textAuthorizationButton = "Sign in";
      this._textNavigationLabel = "Sign up";
      this._titleScreen = "Sign in";
    } else {
      this._textAuthorizationButton = "Sign up";
      this._textNavigationLabel = "Sign in";
      this._titleScreen = "Sign up";
    }
    _validationStatusAuthorization =
        Validators.ValidationStatusAuthorization(
            Validators.EmailValidator(), Validators.PasswordValidator());
    _validationAuthorizationConverter = ValidationAuthorizationConverter();
  }

  @override
  void initState() {

  }

  @override
  void dispose() {

  }

  @override
  void onClickAuthorization(String email, String password, String repeatedPassword, BuildContext context) {
    if (_authorizationType == AuthorizationType.signIn) {
      _handleOnClickSignIn(email, password, context);
    } else {
      _handleOnClickSignUp(email, password, repeatedPassword, context);
    }
  }

  @override
  void onClickNavigation(BuildContext context) {
    AuthorizationViewModelType authorizationViewModel;
    if (authorizationType == AuthorizationType.signIn) {
      authorizationViewModel =
          AuthorizationViewModel(_injector, AuthorizationType.signUp);
    } else {
      authorizationViewModel =
          AuthorizationViewModel(_injector, AuthorizationType.signIn);
    }
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => AuthorizationPage(authorizationViewModel)));
  }

  void _handleOnClickSignUp(String email, String password,
      String repeatedPassword, BuildContext context) {
    ValidationStatusAuthorization _validationStatus = _validationStatusAuthorization
        .getValidationStatus(_authorizationType, email, password,
        repeatedPassword: repeatedPassword);
    if (_validationStatus == ValidationStatusAuthorization.Ok) {
      _requestSignUp(email, password, context);
    } else {
      String errorMessage = _validationAuthorizationConverter.getErrorMessage(
          context, _validationStatus);
      _showDialog("Error", errorMessage, context);
    }
  }

  void _handleOnClickSignIn(String email, String password,
      BuildContext context) {
    ValidationStatusAuthorization _validationStatus = _validationStatusAuthorization
        .getValidationStatus(_authorizationType, email, password);
    if (_validationStatus == ValidationStatusAuthorization.Ok) {
      _requestSignIn(email, password, context);
    } else {
      String errorMessage = _validationAuthorizationConverter.getErrorMessage(
          context, _validationStatus);
      _showDialog("Error", errorMessage, context);
    }
  }

  void _requestSignUp(String email, String password, BuildContext context) {
    _authorizationService.signUp(email, password).then((onValue) {
      print("user id = ${onValue.user.uid}");
      _userProvider.saveCurrentUserId(onValue.user.uid);
      HomeViewModelType dishListViewModel = HomeViewModel(_injector);
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => HomePage(dishListViewModel)));
    }).catchError((onError) {
      if (onError is PlatformException) {
        _showDialog("Error", onError.message, context);
      } else {
        _showDialog("Error", "Unknown error :(", context);
      }
    });
  }

  void _requestSignIn(String email, String password, BuildContext context) {
    _authorizationService.signIn(email, password).then((onValue) {
      print("user id = ${onValue.user.uid}");
      _userProvider.saveCurrentUserId(onValue.user.uid);
      HomeViewModelType dishListViewModel = HomeViewModel(_injector);
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => HomePage(dishListViewModel)));
    }).catchError((onError) {
      if (onError is PlatformException) {
        _showDialog("Error", onError.message, context);
      } else {
        _showDialog("Error", "Unknown error :(", context);
      }
    });
  }

  void _showDialog(String title, String message, BuildContext context) {
    DialogPresenterType dialogPresenter = DialogPresenter(title, message);
    dialogPresenter.show(context);
  }
}
