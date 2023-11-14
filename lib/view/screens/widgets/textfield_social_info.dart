import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class TextFeildSocialInfo extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final String value;
  Function(String) onChange;
  final int? maxLength;

  TextFeildSocialInfo({
    required this.label,
    required this.controller,
    required this.value,
    required this.onChange,
    this.maxLength,
  });

  @override
  State<TextFeildSocialInfo> createState() => _TextFeildSocialInfoState();
}

class _TextFeildSocialInfoState extends State<TextFeildSocialInfo> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    if (widget.value != null && widget.value != 'null') {
      widget.controller.text = widget.value;
    }else{
      widget.controller.text = '';
    }
    return Container(
      padding: EdgeInsets.only(top: 10, left: 5, right: 5),
      child: TextField(
        controller: widget.controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: widget.label,
        ),
        keyboardType: TextInputType.name,
        maxLength: widget.maxLength,
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
      ),
    );
  }
}

