import 'package:flutter/material.dart';
import 'package:ozapay/presentation/widgets/widget.dart';

enum MenuEnum {
  home(OzapayIcons.home, "enum.menus.home"),
  exchange(OzapayIcons.transfer, "enum.menus.exchange"),
  explorer(OzapayIcons.explorer, "enum.menus.explorer");
  //news(OzapayIcons.group, "enum.menus.news"),
  //chat(OzapayIcons.chat, "enum.menus.chat");

  final IconData icon;
  final String title;

  const MenuEnum(this.icon, this.title);
}
