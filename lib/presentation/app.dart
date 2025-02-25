import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_builder_validators/localization/l10n.dart';
import 'package:ozapay/data/services/injection/injection_service.dart';
import 'package:ozapay/presentation/blocs/auth/auth_bloc.dart';
import 'package:ozapay/presentation/blocs/user/user_bloc.dart';
import 'package:provider/provider.dart';

import '../theme.dart';
import 'blocs/wallet/wallet_bloc.dart';
import 'routes.dart';
import 'screens/auth/controllers/signup_controller.dart';

class OzapayApp extends StatelessWidget {
  const OzapayApp({super.key});

  @override
  Widget build(BuildContext context) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => SignupProvider()),
    ],
    child: MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<WalletBloc>(),
        ),
        BlocProvider(
          create: (_) => getIt<AuthBloc>()..add(OnCheckUserIsConnected()),
        ),
        BlocProvider(
          create: (_) => getIt<UserBloc>(),
          lazy: false,
        ),
      ],
      child: MaterialApp.router(
        title: 'Ozapay',
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          ...context.localizationDelegates,
          FormBuilderLocalizations.delegate,
        ],
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        theme: theme(context),
        routerConfig: router,
      ),
    ),
  );
}
}
