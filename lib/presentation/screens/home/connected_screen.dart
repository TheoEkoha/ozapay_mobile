import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:ozapay/core/constants.dart';
import 'package:ozapay/core/extension.dart';
import 'package:ozapay/presentation/blocs/bloc_status.dart';
import 'package:ozapay/presentation/blocs/user/user_bloc.dart';
import 'package:ozapay/presentation/blocs/wallet/wallet_bloc.dart';
import 'package:ozapay/presentation/screens/wallet/wallet_screen.dart';
import 'package:ozapay/presentation/widgets/widget.dart';
import 'package:ozapay/theme.dart';

import '../wallet/bottom_sheet/activate_wallet_bottom_sheet.dart';
import '../wallet/bottom_sheet/recent_transactions.dart';
import '../wallet/transaction/all_transaction_screen.dart';

class ConnectedScreen extends StatefulWidget {
  const ConnectedScreen({super.key});

  @override
  State<ConnectedScreen> createState() => _ConnectedScreenState();
}

class _ConnectedScreenState extends State<ConnectedScreen> {
  @override
  void initState() {
    context.read<UserBloc>().add(OnUserInfoFetched());
    context.read<WalletBloc>().add(OnWalletGot());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WalletBloc, WalletState>(
      listener: (context, state) {
        final path = GoRouter.of(context).currentPath;
        if (state.status is WalletGotStatus && path == "/") {
          //context.read<WalletBloc>().add(OnTransactionHistoryGot(limit: 5));
        }
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BalanceCard(balance: 0, isActivated: false),

            /// Action
            Padding(
              padding: EdgeInsets.all(defaultPadding)
                  .copyWith(top: 0, bottom: kSpacing * 2),
              child: state.status is LoadingStatus
                  ? Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(kSpacing * 2.75),
                        color: yellowColor,
                      ),
                      child: Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    )
                  : state.keypair == null && state.address == null
                      ? FilledButton.icon(
                          style: FilledButton.styleFrom(
                            textStyle: Theme.of(context).textTheme.bodyMedium,
                            foregroundColor: Colors.black,
                            backgroundColor: yellowColor,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(kSpacing * 2.75),
                            ),
                          ),
                          onPressed: () {
                            context.showBottomSheet(
                              showDragHandle: false,
                              isScrollControlled: true,
                              child: ActivateWalletBottomSheet(),
                            );
                          },
                          icon: SvgPicture.asset(
                              'assets/icons/no_connection.svg'),
                          label: Text(
                            "Activer mes Cryptomonnaies",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        )
                      : FilledButton.icon(
                          style: FilledButton.styleFrom(
                            textStyle: Theme.of(context).textTheme.bodyMedium,
                            foregroundColor: Colors.black,
                            backgroundColor: yellowColor,
                            padding: EdgeInsets.symmetric(
                              horizontal: kSpacing * 2.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(kSpacing * 2.75),
                            ),
                          ),
                          onPressed: () {
                            context.push(WalletScreen.route);
                          },
                          icon: Icon(
                            OzapayIcons.wallet,
                            size: kSpacing * 2,
                          ),
                          label: Row(
                            children: [
                              Text(
                                "Mes Cryptomonnaies",
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              Spacer(),
                              Icon(
                                OzapayIcons.chart,
                                size: kSpacing * 2,
                              ),
                              const SizedBox(width: kSpacing * 0.5),
                              WalletCurrencyChange(
                                  percentage: state.percentage),
                            ],
                          ),
                        ),
            ),

            /// Bottom Sheet
            Expanded(
              child: RecentTransactions(
                onRefresh: () {
                  context
                      .read<WalletBloc>()
                      .add(OnTransactionHistoryGot(limit: 5));
                },
                button: InkWell(
                  onTap: () {
                    context.push(AllTransactionScreen.route);
                  },
                  child: Text(
                    'Voir plus +',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
