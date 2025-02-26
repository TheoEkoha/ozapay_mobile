import 'package:awesome_bottom_bar/awesome_bottom_bar.dart'
    hide BottomBarInspiredInside;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ozapay/presentation/blocs/auth/auth_bloc.dart';
import 'package:ozapay/presentation/screens/dashboard/bottom_bar.dart';
import 'package:ozapay/presentation/screens/dashboard/dashboard_controller.dart';
import 'connected_screen.dart';
import 'not_connected_screen.dart';
import 'package:ozapay/core/enums.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = DashboardController();

  @override
  void initState() {
    super.initState();
    // Vérifiez si l'utilisateur est connecté lors de l'initialisation de l'écran
    context.read<AuthBloc>().add(OnCheckUserIsConnected());
  }

  @override
  Widget build(BuildContext context) {
    final userIsConnected =
        context.watch<AuthBloc>().state is AuthUserConnectedState;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: userIsConnected
                ? const ConnectedScreen()
                : const NotConnectedScreen(),
          ),
          // Affichage d'un message pour les utilisateurs non connectés
          if (!userIsConnected) ...[
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Utilisateur non connecté'),
            ),
          ],
        ],
      ),
      bottomNavigationBar: userIsConnected
          ? Builder(
              builder: (context) {
                return BottomBarInspiredInside(
                  height: 48,
                  items: MenuEnum.values
                      .map((menu) =>
                          TabItem(icon: menu.icon, title: menu.title.tr()))
                      .toList(),
                  backgroundColor: Colors.white,
                  color: const Color(0xFFB0B0BC),
                  colorSelected: Colors.white,
                  indexSelected: controller.currentMenu.index,
                  fixed: true,
                  fixedIndex: 1,
                  elevation: 5,
                  onTap: (int index) {
                    // Gérer la navigation ici
                    controller.changeIndex(MenuEnum.values.elementAt(index));
                  },
                  sizeInside: 60,
                  titleStyle: const TextStyle(color: Colors.black),
                  chipStyle: ChipStyle(
                    size: 30,
                    convexBridge: true,
                    background: Theme.of(context).colorScheme.primary,
                  ),
                  itemStyle: ItemStyle.circle,
                  animated: false,
                  pad: 2,
                  padTop: 16, // Ajuste le padding en fonction de tes besoins
                  padbottom: 6,
                );
              },
            )
          : null,
    );
  }
}