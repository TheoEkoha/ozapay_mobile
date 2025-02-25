import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ozapay/core/constants.dart';

import '../screens/wallet/bottom_sheet/notification_bottom_sheet.dart';
import 'ozapay_icons.dart';

class ConnectedAppbar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget> actions;

  const ConnectedAppbar({super.key, required this.actions});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      titleSpacing: kSpacing,
      automaticallyImplyLeading: false,
      leading: GestureDetector(
        onTap: () {
          Scaffold.of(context).openDrawer();
        },
        child: Transform(
          transform: Matrix4.identity()
            ..scale(0.7)
            ..translate(kSpacing * 3, kSpacing),
          child: CircleAvatar(
            backgroundColor: Color(0xFFEDEDED),
            child: Icon(
              OzapayIcons.user_circle,
              color: Color(0xFFB1B1B1),
              size: 50,
            ),
          ),
        ),
      ),
      title: Transform.translate(
        offset: Offset(0, -2.25),
        child: Image.asset(
          "assets/images/logo_ozapay.png",
          height: kSpacing * 3,
        ),
      ),
      actions: [
        // Builder( 
        //   builder: (context) {
        //     return IconButton(
        //       onPressed: () {
        //         showBottomSheet(
        //           context: context,
        //           enableDrag: true,
        //           builder: (context) => NotificationBottomSheet(),
        //         );
        //       },
        //       icon: SvgPicture.asset(
        //         width: kSpacing * 2.5,
        //         height: kSpacing * 2.5,
        //         'assets/icons/notification.svg',
        //       ),
        //     );
        //   },
        // ),
        ...actions
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
