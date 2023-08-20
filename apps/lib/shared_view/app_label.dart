import 'package:flutter/material.dart';
import 'package:resources/resources.dart';

class AppLabel extends StatelessWidget {
  const AppLabel({
    this.title = '',
    this.content = '',
    super.key,
  });

  final String title;
  final String content;

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
        Align(
        alignment: Alignment.centerLeft,
          child: Text(content),
        ),
      ],
    );
  }
}
