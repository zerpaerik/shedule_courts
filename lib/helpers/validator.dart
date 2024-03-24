class Validator {
  static String? emptyValueValidation(String? value,
      {String? errmsg = "Este campo es obligatorio"}) {
    return (value ??= "").trim().isEmpty ? errmsg : null;
  }

  static String? validateString(String? value,
      {String? errmsg = "Este campo es obligatorio"}) {
    final pattern = RegExp(r'^[a-zA-Z ]+$');
    if ((value ??= "").trim().isEmpty) {
      return errmsg;
    } else if (!pattern.hasMatch(value)) {
      return "Este campo no es un texto válido";
    } else {
      return null;
    }
  }

  static String? nullCheckValidator(String? value, {int? requiredLength}) {
    if (value!.isEmpty) {
      return "Field must not be empty";
    } else if (requiredLength != null) {
      if (value.length < requiredLength) {
        return "Text must be $requiredLength character long";
      } else {
        return null;
      }
    }

    return null;
  }
}
