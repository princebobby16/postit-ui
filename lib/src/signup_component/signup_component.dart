import 'dart:async';
import 'package:angular/angular.dart';
import 'package:angular_app/src/navbar_component/navbar_component.dart';
import 'package:angular_app/src/routes.dart';
import 'package:angular_app/src/signup_component/signup_services.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';

@Component(
  selector: 'signup-app',
  templateUrl: 'signup_component.html',
  styleUrls: ['signup_component.css'],
  directives: [
    routerDirectives,
    NavbarComponent,
    formDirectives,
    coreDirectives,
    MaterialIconComponent,
    MaterialCheckboxComponent,
    MaterialChipsComponent,
    MaterialChipComponent,
  ],
  providers: [ClassProvider(SignupServices)],
  exports: [Routes]
)
class SignupComponent {
  Router _router;
  SignupServices _signupServices;
  List<String> companyPhoneNumbers = <String>[];
  Signup user = Signup('', '', '', '', '', '', '', '', [], '', false);
  String passwordConfirmation = '';
  String phone = '';
  String message = 'Signup failed';
  bool isLoading = false;
  bool showAlert = false;
  int statusCode = 400;

  SignupComponent(this._signupServices, this._router);

  void addPhone() {
    if(phone.isNotEmpty) {
      companyPhoneNumbers.add(phone);
      phone = '';
    }
  }

  void removePhone(int index) {
    companyPhoneNumbers.removeAt(index);
  }

  void dismissAlert() {
    showAlert = false;
  }

  Future<void> signup() async {
    SignupStandardResponse signup = SignupStandardResponse(statusCode: null, message: '');
    user.companyPhone = companyPhoneNumbers;
    if(
      user.firstname.isEmpty ||
      user.lastname.isEmpty ||
      user.username.isEmpty ||
      user.password.isEmpty ||
      user.companyName.isEmpty ||
      user.companyAddress.isEmpty ||
      user.companyWebsite.isEmpty ||
      user.ghanaPostAddress.isEmpty ||
      user.companyEmail.isEmpty ||
      user.companyPhone.isEmpty
    ) {
      showAlert = true;
      message = 'All input fields are required';
      Timer(Duration(seconds: 5), dismissAlert);
      return;
    } else {
      if(user.termsAndConditions && passwordConfirmation == user.password) {
        try {
          isLoading = true;
          signup = await _signupServices.signup(user.firstname, user.lastname, user.username, user.password, user.companyName, user.companyWebsite, user.companyAddress, user.companyPhone, user.companyEmail, user.ghanaPostAddress);
          isLoading = false;
          showAlert = true;
          statusCode = signup.statusCode;
          message = checkMessage(signup.message);
          print(signup.message);
        } catch(e) {
          isLoading = false;
          showAlert = true;
          message = checkMessage(signup.message);
          statusCode = signup.statusCode;
          Timer(Duration(seconds: 5), dismissAlert);
        }

        if(signup.statusCode != 200) {
          return;
        } else {
          companyPhoneNumbers.clear();
          user.firstname = '';
          user.lastname = '';
          user.username = '';
          user.password = '';
          user.companyName = '';
          user.companyAddress = '';
          user.companyWebsite = '';
          user.ghanaPostAddress = '';
          user.companyEmail = '';
          user.companyPhone = [];
          passwordConfirmation = '';

          _router.navigate(RoutePaths.dashboard.toUrl());
        }
      } else {
        showAlert = true;
        message = 'Confirm password and agree to the terms.';
        Timer(Duration(seconds: 5), dismissAlert);
        return;
      }
    }
  }

  String checkMessage(String m) {
    if(m == '') {
      m = 'Login failed';
    }
    return m;
  }
}
