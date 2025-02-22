import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ozapay/core/constants.dart';
import 'package:ozapay/data/enums/enum.dart';
import 'package:ozapay/presentation/blocs/user/user_bloc.dart';
import 'package:ozapay/presentation/screens/promotion/promotional_space_screen.dart';
import 'package:ozapay/presentation/screens/setting/challenge_screen.dart';
import 'package:ozapay/presentation/screens/setting/gains_and_cashback_screen.dart';
import 'package:ozapay/presentation/screens/setting/setting_screen.dart';
import 'package:ozapay/presentation/widgets/widget.dart';
import 'package:ozapay/theme.dart';

import '../offer/update_offer_screen.dart';
import '../wallet/bottom_sheet/notification_bottom_sheet.dart';

class Drawer extends StatelessWidget {
  const Drawer({super.key});

  @override
  Widget build(BuildContext context) {
    final menuItems = [
      MenuItemEntity(
        icon: 'promote.png',
        iconBgColor: primaryColor,
        title: 'drawer.main.menus.1.title'.tr(),
        description: 'drawer.main.menus.1.subtitle'.tr(),
        nextRoute: PromotionalSpaceScreen.route,
        size: 1.25,
      ),
      MenuItemEntity(
        icon: 'gains.svg',
        iconBgColor: Color(0xffF4AF02),
        title: 'drawer.main.menus.2.title'.tr(),
        description: 'drawer.main.menus.2.subtitle'.tr(),
        nextRoute: GainsAndCashbackScreen.route,
      ),
      MenuItemEntity(
        icon: 'handshake.svg',
        iconBgColor: redColor,
        title: 'drawer.main.menus.3.title'.tr(),
        description: 'drawer.main.menus.3.subtitle'.tr(),
      ),
      MenuItemEntity(
        icon: 'analytics.svg',
        iconBgColor: Color(0xFFB0B0BC),
        title: 'drawer.main.menus.4.title'.tr(),
        description: 'drawer.main.menus.4.subtitle'.tr(),
        nextRoute: UpdateOfferScreen.route,
      ),
      MenuItemEntity(
        icon: 'goal.svg',
        iconBgColor: Color(0xFF9E9EA9),
        title: 'drawer.main.menus.5.title'.tr(),
        description: 'drawer.main.menus.5.subtitle'.tr(),
        nextRoute: ChallengeScreen.route,
      ),
      MenuItemEntity(
        icon: 'setting.png',
        iconBgColor: Color(0xff646464),
        title: 'drawer.main.menus.6.title'.tr(),
        description: 'drawer.main.menus.6.subtitle'.tr(),
        nextRoute: SettingScreen.route,
      ),
    ];

    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Scaffold.of(context).closeDrawer();
            },
            icon: Icon(OzapayIcons.caret_left),
          ),
          centerTitle: false,
          titleSpacing: 0,
          title: Transform.translate(
            offset: Offset(-8, -2),
            child: GestureDetector(
              onTap: () {
                Scaffold.of(context).closeDrawer();
              },
              child: Text(
                "Accueil",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ),
          actions: [
            Builder(builder: (context) {
              return IconButton(
                onPressed: () {
                  showBottomSheet(
                    context: context,
                    enableDrag: true,
                    builder: (context) => NotificationBottomSheet(),
                  );
                },
                icon: Badge(
                  padding: EdgeInsets.zero,
                  backgroundColor: Theme.of(context).colorScheme.tertiary,
                  child: SvgPicture.asset(
                    'assets/icons/notification.svg',
                  ),
                ),
              );
            }),
            Container(
              padding: EdgeInsets.only(right: kSpacing * 2),
              constraints: BoxConstraints(maxHeight: 32),
              child: FilledButton.icon(
                onPressed: () {
                  context.read<UserBloc>().add(OnUserInfoFetched());
                },
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.tertiary,
                  padding: EdgeInsets.symmetric(horizontal: kSpacing * 2),
                ),
                icon: Icon(
                  OzapayIcons.clockwise,
                  size: kSpacing * 1.75,
                ),
                label: Text(
                  'RECHARGER',
                  style: TextStyle(fontSize: 12, letterSpacing: 0.25),
                ),
              ),
            )
          ],
        ),
        body: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            return ListView(
              padding: const EdgeInsets.all(kSpacing * 2).copyWith(top: 0),
              children: [
                ListTile(
                  minTileHeight: 30,
                  contentPadding: EdgeInsets.zero.copyWith(right: kSpacing * 3),
                  leading: CircleAvatar(
                    radius: 20,
                    backgroundColor: Color(0xFFEDEDED),
                    child: Icon(
                      OzapayIcons.user_circle,
                      color: Color(0xFFB1B1B1),
                      size: 38,
                    ),
                  ),
                  textColor: Colors.white,
                  horizontalTitleGap: kSpacing,
                  titleTextStyle: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                  subtitleTextStyle:
                      Theme.of(context).textTheme.labelSmall?.copyWith(
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.w500,
                          ),
                  title: Text(state.user?.displayName ?? ''),
                  subtitle: Text(state.user?.email ?? ''),
                  trailing: GestureDetector(
                    onTap: () {},
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          OfferTypeEnum.liberty.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: kSpacing,
                            height: 2,
                          ),
                        ),
                        SvgPicture.asset(
                          'assets/icons/semi_ellipse.svg',
                          width: 53,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: kSpacing * 2.25),
                CardBalance(),
                SizedBox(height: kSpacing),
                ...List.generate(
                  menuItems.length,
                  (index) => MenuItemWidget(
                    item: menuItems[index],
                  ),
                ),
                const SizedBox(height: kSpacing * 3),
              ],
            );
          },
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(
              vertical: 8.0, horizontal: kSpacing * 2.5),
          child: DefaultTextStyle(
            style: TextStyle(color: secondaryColor, fontSize: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('drawer.main.copyright')
                    .tr(args: [DateTime.now().year.toString()]),
                Text('v0.3a'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
