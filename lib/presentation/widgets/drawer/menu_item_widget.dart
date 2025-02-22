import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:ozapay/core/constants.dart';
import 'package:ozapay/presentation/widgets/widget.dart';

class MenuItemWidget extends StatelessWidget {
  const MenuItemWidget({
    super.key,
    this.isLastItem = false,
    required this.item,
  });

  final bool isLastItem;
  final MenuItemEntity item;

  @override
  Widget build(BuildContext context) {
    onTap() {
      if (item.nextRoute != null) context.push(item.nextRoute!);
    }

    return CustomPaint(
      painter: CustomDashedLinePainter(
        leftPadding: kSpacing * 2,
        rightPadding: kSpacing * 1.5,
      ),
      child: buildItem(context, onTap),
    );
  }

  Widget buildItem(BuildContext context, VoidCallback onTap) {
    return ListTile(
      splashColor: Theme.of(context).scaffoldBackgroundColor,
      onTap: onTap,
      contentPadding: EdgeInsets.only(
        left: kSpacing * 2,
        right: kSpacing * 2,
      ),
      leading: Container(
        width: 40,
        height: 40,
        padding: EdgeInsets.all(kSpacing),
        decoration: BoxDecoration(
          color: item.iconBgColor ?? Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(kSpacing * 1.5)
              .copyWith(topRight: const Radius.circular(0)),
        ),
        child: item.icon?.endsWith('png') == true
            ? Transform.scale(
                scale: item.size ?? 1,
                child: Image.asset('assets/icons/menu/${item.icon}'),
              )
            : Transform.scale(
                scale: item.size ?? 1,
                child: SvgPicture.asset('assets/icons/menu/${item.icon}'),
              ),
      ),
      titleTextStyle: Theme.of(context)
          .textTheme
          .titleMedium
          ?.copyWith(height: 2, fontWeight: FontWeight.w600),
      subtitleTextStyle: Theme.of(context).textTheme.bodySmall,
      minVerticalPadding: 0,
      textColor: Colors.white,
      title: Text(item.title ?? ''),
      subtitle: Text(item.description ?? ''),
      trailing: Icon(
        OzapayIcons.caret_right,
        size: kSpacing * 2,
        color: Colors.white,
      ),
    );
  }
}

class MenuItemEntity {
  final String? title;
  final String? description;
  final String? icon;
  final Color? iconBgColor;
  final String? nextRoute;
  final double? size;

  const MenuItemEntity({
    this.title,
    this.description,
    this.icon,
    this.iconBgColor,
    this.nextRoute,
    this.size,
  });
}
