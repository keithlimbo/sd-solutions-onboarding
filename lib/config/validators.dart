String? validateEmail(String? value) {
  String? msg;
  RegExp regex = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  if (value!.isEmpty) {
    msg = "Please type a correct email address";
  } else if (!regex.hasMatch(value)) {
    msg = "Please provide a valid email address";
  }
  return msg;
}

String? validateName(String? value) {
  String? msg;
  RegExp regex = RegExp(r"^[\p{L} ,.'-]*$",
      caseSensitive: false, unicode: true, dotAll: true);
  if (value!.isEmpty) {
    msg = "Your name is required";
  } else if (value.contains(" ") != true) {
    msg = "Please provide a space to identify fullname";
  } else if (!regex.hasMatch(value)) {
    msg = "Please provide a valid name";
  }
  return msg;
}

String? validatePassword(String? value) {
  String? msg;
  RegExp hasUppercase = RegExp(r'[A-Z]');
  RegExp hasDigits = RegExp(r'[0-9]');
  RegExp hasLowercase = RegExp(r'[a-z]');
  RegExp hasSpecialCharacters = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
  if (value!.isEmpty) {
    msg = "Your password is required";
  } else if (value.length < 9) {
    msg = "Password must be more than 8 characters";
  } else if (!hasUppercase.hasMatch(value)) {
    msg = "Uppercase letter (At least 1 character)";
  } else if (!hasDigits.hasMatch(value)) {
    msg = "Numeric digit (At least 1 character)";
  } else if (!hasLowercase.hasMatch(value)) {
    msg = "Lowercase letter (At least 1 character)";
  } else if (!hasSpecialCharacters.hasMatch(value)) {
    msg = "Special character (At least 1 character)";
  }
  return msg;
}

String? validateEmpty(String? value) {
  String? msg;
  // RegExp regex = new RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]');
  if (value!.isEmpty) {
    msg = "Your input is required";
  } else if (value.length < 4) {
    msg = "Your input must be at least 4 characters";
  }
  return msg;
}
