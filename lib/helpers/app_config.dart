import 'package:flutter/material.dart';

class App {
  late BuildContext _context;
  late double _height;
  late double _width;
  late double _heightPadding;
  late double _widthPadding;

  App(_context) {
    this._context = _context;
    MediaQueryData _queryData = MediaQuery.of(this._context);
    _height = _queryData.size.height / 100.0;
    _width = _queryData.size.width / 100.0;
    _heightPadding = _height -
        ((_queryData.padding.top + _queryData.padding.bottom) / 100.0);
    _widthPadding =
        _width - (_queryData.padding.left + _queryData.padding.right) / 100.0;
  }

  double appHeight(double v) {
    return _height * v;
  }

  double appWidth(double v) {
    return _width * v;
  }

  double appVerticalPadding(double v) {
    return _heightPadding * v;
  }

  double appHorizontalPadding(double v) {
//    int.parse(settingRepo.setting.mainColor.replaceAll("#", "0xFF"));
    return _widthPadding * v;
  }
}

String convertString(String input) {
  String returnString = input.toLowerCase();
  returnString = returnString.replaceAll(RegExp(r'ö'), "o");
  returnString = returnString.replaceAll(RegExp(r'ç'), "c");
  returnString = returnString.replaceAll(RegExp(r'ş'), "s");
  returnString = returnString.replaceAll(RegExp(r'ı'), "i");
  returnString = returnString.replaceAll(RegExp(r'ğ'), "g");
  returnString = returnString.replaceAll(RegExp(r'ü'), "u");

  returnString = returnString.replaceAll(RegExp(r'[^a-z0-9\s-]'), "");
  returnString = returnString.replaceAll(RegExp(r'[\s-]+'), " ");
  returnString = returnString.replaceAll(RegExp(r'^\s+|\s+$'), "");
  returnString = returnString.replaceAll(RegExp(r'\s'), "-");

  return returnString;
}