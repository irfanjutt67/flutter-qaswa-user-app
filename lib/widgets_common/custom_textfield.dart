import '../consts/consts.dart';

Widget customTextField(
    {String? title, String? hint, label, controller, isPass, type, fillcolor}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      5.heightBox,
      TextFormField(
        autofocus: true,
        autocorrect: true,
        textInputAction: TextInputAction.next,
        keyboardType: type,
        obscureText: isPass,
        controller: controller,
        validator: (value) {
          if (value!.isEmpty) {
            return '*Required';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: textfieldGrey),
          hintText: hint,
          hintStyle:
              const TextStyle(fontFamily: semibold, color: textfieldGrey),
          isDense: true,
          fillColor: fillcolor,
          filled: true,
          border: InputBorder.none,
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: redColor),
          ),
        ),
      ),
      5.heightBox,
    ],
  );
}
