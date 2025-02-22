import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:ozapay/core/constants.dart';
import 'package:ozapay/core/extension.dart';
import 'package:ozapay/presentation/blocs/bloc_status.dart';
import 'package:ozapay/presentation/blocs/wallet/wallet_bloc.dart';
import 'package:ozapay/presentation/screens/wallet/wallet_screen.dart';
import 'package:ozapay/presentation/widgets/widget.dart';

import 'import_wallet_controller.dart';
import 'mnemonic_tab_bar_view.dart';
import 'secret_or_address_tab_bar_view.dart';

class ImportWalletScreen extends StatefulWidget {
  const ImportWalletScreen({super.key});

  static const route = '/import-wallet';

  @override
  State<ImportWalletScreen> createState() => _ImportWalletScreenState();
}

class _ImportWalletScreenState extends State<ImportWalletScreen> {
  late final ImportWalletController controller;

  @override
  void initState() {
    controller = ImportWalletController(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      GoRouterState.of(context).matchedLocation;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ScaffoldWithRoundedCorner(
      body: DefaultTabController(
        length: 3,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TabBar(
              dividerHeight: 0,
              labelPadding: EdgeInsets.zero,
              indicatorWeight: 0,
              labelColor: theme.colorScheme.primary,
              labelStyle: theme.textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
              unselectedLabelStyle: theme.textTheme.bodyMedium,
              indicator: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: theme.colorScheme.primary,
                    width: 2,
                  ),
                ),
              ),
              tabs: [
                Tab(text: 'Phrase secrète'),
                Tab(text: 'Clé privée'),
                Tab(text: 'Adresse'),
              ],
            ),
            SizedBox(height: kSpacing * 2),
            BlocListener<WalletBloc, WalletState>(
              listener: (context, state) {
                switch (state.status) {
                  // Step 1: Get Wallet
                  case WalletImportedStatus _:
                    context.showSnackBar(
                      "Vérification du portefeuille en cours...",
                      persistent: true,
                    );
                    context.read<WalletBloc>().add(OnWalletGot());
                    break;

                  // Step 2: Create ATA
                  case WalletGotStatus _:
                    //context.read<WalletBloc>().add(OnSubscribeToWebsocket());
                    context.read<WalletBloc>().add(OnATACreated());

                    break;

                  // Step 3: Aidrop OZA
                  case ATACreatedStatus _:
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    context.showSnackBar("Portefeuille importé avec succès.");
                    context.popUntil('/');
                    context.push(WalletScreen.route);

                    break;

                  case ErrorStatus _:
                    context.showSnackBar(state.error!.message.join("\n"),
                        error: true);

                  default:
                    break;
                }
              },
              child: Expanded(
                child: FormBuilder(
                  key: controller.formKey,
                  child: TabBarView(
                    children: [
                      MnemonicTabBarView(controller: controller),
                      SecretOrAddressTabBarView(
                        controller: controller,
                        type: ImportTypeEnum.secretKey,
                      ),
                      SecretOrAddressTabBarView(
                        controller: controller,
                        type: ImportTypeEnum.address,
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
