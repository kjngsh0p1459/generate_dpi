import 'package:flutter/material.dart';
import 'package:resources/resources.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    this.title = '',
    this.hintText = '',
    this.suffixIcon,
    this.controller,
    this.onChanged,
    this.onTap,
    this.keyboardType = TextInputType.text,

    super.key,
  });

  final String title;
  final String hintText;
  final Image? suffixIcon;
  final void Function(String)? onChanged;
  final VoidCallback? onTap;
  final TextInputType keyboardType;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (title.isNotEmpty) ...[
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: AppTextStyles.s14w400Primary(),
            ),
          ),
          SizedBox(height: Dimens.d8.responsive()),
        ],
        TextField(
          // onTap: onTap,
          // onChanged: onChanged,
          controller: controller,
          decoration: InputDecoration(hintText: hintText),
          keyboardType: keyboardType,
        ),
      ],
    );
  }
}
