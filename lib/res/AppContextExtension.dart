
import 'package:flutter/cupertino.dart';
import 'package:connect_social/res/Resources.dart';
import 'package:connect_social/res/dimentions/AppDimension.dart';

extension AppContext on BuildContext {
  Resources get resources => Resources.of(this);
}