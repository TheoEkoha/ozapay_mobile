import 'package:flutter/material.dart' hide Drawer;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ozapay/presentation/blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_bloc.dart';

import 'connected_screen.dart';
import 'not_connected_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userIsConnected =
        context.watch<AuthBloc>().state is AuthUserConnectedState;

    return Scaffold(
      body: userIsConnected
          ? const ConnectedScreen()
          : const NotConnectedScreen(),
    );
  }
}
