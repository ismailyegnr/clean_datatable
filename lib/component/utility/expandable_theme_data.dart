import 'package:flutter/material.dart';

class ExpandableThemeData {
  /// Text style of header row.
  final TextStyle? headerTextStyle;

  /// Text style of all rows.
  final TextStyle? rowsTextStyle;

  /// Text style of expansion content.
  ///
  /// It overrides if custom render function is used.
  final TextStyle? expandedTextStyle;

  /// Background color of header row.
  final Color? headerColor;

  /// Expansion background color.
  final Color expandedBackgroundColor;

  /// Expansion border color.
  ///
  /// It overrides if rowsBorder is used.
  final Color? expandedBorderColor;

  //TODO
  final Color? rowsColor;

  /// Border style of header row.
  final BorderSide headerBorder;

  /// Border style of all rows.
  final BorderSide? rowsBorder;

  /// Icon showing editing feature.
  final Icon editIcon;

  /// Icon that expands the expansion content.
  final Icon expansionIcon;

  ExpandableThemeData({
    this.headerTextStyle,
    this.rowsTextStyle,
    this.expandedTextStyle = const TextStyle(fontSize: 13),
    this.headerColor,
    this.headerBorder = const BorderSide(
      width: 2.5,
      color: Color(0xffeeeeee),
    ),
    this.rowsBorder,
    this.expandedBorderColor,
    this.rowsColor,
    this.expandedBackgroundColor = Colors.white,
    this.editIcon = const Icon(
      Icons.edit,
      size: 16,
    ),
    this.expansionIcon = const Icon(
      Icons.more_vert,
      size: 18,
    ),
  });

  factory ExpandableThemeData.normal() => ExpandableThemeData();
}
