import 'package:awesome_bottom_bar/awesome_bottom_bar.dart'
    hide BottomBarInspiredInside;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart' hide Drawer;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ozapay/core/constants.dart';
import 'package:ozapay/core/enums.dart';
import 'package:ozapay/core/extension.dart';
import 'package:ozapay/presentation/blocs/auth/auth_bloc.dart';
import 'package:ozapay/presentation/blocs/wallet/wallet_bloc.dart';
import 'package:ozapay/presentation/widgets/widget.dart';

import '../home/home_screen.dart';
import '../wallet/bottom_sheet/swap_options_bottom_sheet.dart';
import 'bottom_bar.dart';
import 'dashboard_controller.dart';
import 'drawer.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardState();
}

class _DashboardState extends State<DashboardScreen> {
  final controller = DashboardController();
  final disabledColor = const Color(0xFFEDEDED);

  bool get userIsConnected =>
      context.read<AuthBloc>().state is AuthUserConnectedState;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return Scaffold(
          appBar: ConnectedAppbar(
            actions: [
              Transform.translate(
                offset: Offset(0, -2.2),
                child: Container(
                  margin: EdgeInsets.only(right: kSpacing * 2.25),
                  constraints: BoxConstraints(maxHeight: 32),
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      textStyle: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                      backgroundColor: Theme.of(context).colorScheme.tertiary,
                      disabledBackgroundColor: Color(0xFFB0B0BC),
                      padding:
                          const EdgeInsets.symmetric(horizontal: kSpacing * 2),
                    ),
                    onPressed: null,
                    icon: Icon(OzapayIcons.nfc, size: 14),
                    label: Text("PAYER"),
                  ),
                ),
              ),
            ],
          ),
          drawer: userIsConnected ? const Drawer() : null,
          body: Builder(
            builder: (context) {
              switch (controller.currentMenu) {
                case MenuEnum.home:
                default:
                  return const HomeScreen();
              }
            },
          ),
          bottomNavigationBar: userIsConnected
              ? Builder(
                  builder: (context) {
                    final hasWallet =
                        context.watch<WalletBloc>().address != null;

                    final hasWalletAndIsConnected =
                        userIsConnected && hasWallet;

                    return BottomBarInspiredInside(
                      height: 48,
                      items: MenuEnum.values
                          .map((menu) =>
                              TabItem(icon: menu.icon, title: menu.title.tr()))
                          .toList(),
                      backgroundColor: Colors.white,
                      color: Color(0xFFB0B0BC),
                      colorSelected: Colors.white,
                      indexSelected: controller.currentMenu.index,
                      fixed: true,
                      fixedIndex: 1,
                      elevation: 5,
                      onTap: (int index) {
                        if (hasWalletAndIsConnected && index == 1) {
                          context.showBottomSheet(
                            showDragHandle: false,
                            isScrollControlled: true,
                            child: CustomBottomsheet(
                              child: SwapOptionsBottomSheet(),
                            ),
                          );
                        }

                        if (!userIsConnected || !hasWallet) {
                          controller.changeIndex(MenuEnum.home);
                        } else {
                          controller
                              .changeIndex(MenuEnum.values.elementAt(index));
                        }
                      },
                      sizeInside: 60,
                      titleStyle: TextStyle(color: Colors.black),
                      chipStyle: ChipStyle(
                        size: 30,
                        convexBridge: true,
                        background: userIsConnected &&
                                context.watch<WalletBloc>().address != null
                            ? Theme.of(context).colorScheme.primary
                            : Color(0xFFB0B0BC),
                      ),
                      itemStyle: ItemStyle.circle,
                      animated: false,
                      pad: 2,
                      padTop: kSpacing,
                      padbottom: 6,
                    );
                  },
                )
              : null,
        );
      },
    );
  }
}
