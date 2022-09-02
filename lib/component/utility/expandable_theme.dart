import 'package:flutter/material.dart';

import '../expandable_data_table.dart';
import 'expandable_theme_data.dart';

class ExpandableTheme extends InheritedWidget {
  final ExpandableThemeData data;

  const ExpandableTheme({
    Key? key,
    required this.data,
    required ExpandableDataTable child,
  }) : super(key: key, child: child);

  static final ExpandableThemeData _expandableThemeData =
      ExpandableThemeData.normal();

  static ExpandableThemeData of(BuildContext context) {
    final ExpandableTheme? result =
        context.dependOnInheritedWidgetOfExactType<ExpandableTheme>();

    final ExpandableThemeData themeData = result?.data ?? _expandableThemeData;

    return themeData;
  }

  @override
  bool updateShouldNotify(ExpandableTheme oldWidget) => data != oldWidget.data;
}
