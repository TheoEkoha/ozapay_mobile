import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart' hide Drawer;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ozapay/core/constants.dart';
import 'package:ozapay/core/extension.dart';
import 'package:ozapay/core/ozapay/ozapay.dart';
import 'package:ozapay/data/params/params.dart';
import 'package:ozapay/presentation/blocs/auth/auth_bloc.dart';
import 'package:ozapay/presentation/blocs/bloc_status.dart';
import 'package:ozapay/presentation/blocs/wallet/wallet_bloc.dart';
import 'package:ozapay/presentation/widgets/widget.dart';
import 'package:ozapay/theme.dart';

import '../dashboard/drawer.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  static String route = "/my-crypto";

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  void initState() {
    //context.read<WalletBloc>().add(OnGiftGiven(amount: 50));
    // if (!(context.read<UserBloc>().state.user?.hasWallet ?? true)) {
    //   context.read<WalletBloc>().add(OnGiftGiven(amount: 50));
    // } else {
    context.read<WalletBloc>().add(OnTokenGot());
    // }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                  backgroundColor: Color(0xFF3B9DB9),
                  disabledBackgroundColor: Color(0xFFB0B0BC),
                  padding: const EdgeInsets.symmetric(horizontal: kSpacing * 2),
                ),
                onPressed: null,
                icon: Icon(OzapayIcons.solana, size: 14),
                label: Text("SOLANA"),
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(),
      body: BlocConsumer<WalletBloc, WalletState>(
        listener: (context, state) {
          switch (state.status) {
            case TokenTransferedStatus _:
              context
                  .read<AuthBloc>()
                  .add(OnPatch(RegisterParams(hasWallet: true)));
              context.read<WalletBloc>().add(OnTokenGot());
              context.showSnackBar("Vous avez reçu un cadeau de 50OZA");
              break;

            case AllTokenBalancesGotStatus _:
              context.read<WalletBloc>().add(OnWalletBalanceGot());
              break;

            case ErrorStatus _:
              context.showSnackBar(
                state.error!.message.join(" "),
                error: true,
              );
              break;

            default:
              break;
          }
        },
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              BalanceCard(
                balance: state.balance,
                cardType: CardType.crypto,
              ),

              // Action
              Padding(
                padding: EdgeInsets.all(defaultPadding).copyWith(top: 0),
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.bodyMedium,
                    foregroundColor: Colors.black,
                    backgroundColor: Color(0xFFFBECC7),
                    padding: EdgeInsets.symmetric(
                      horizontal: kSpacing * 2.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(kSpacing * 2.75),
                    ),
                  ),
                  onPressed: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.replace("/");
                    }
                  },
                  icon: Icon(
                    OzapayIcons.back,
                    size: kSpacing * 2,
                  ),
                  label: Row(
                    children: [
                      Text(
                        " Retour sur mon COMPTE",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Spacer(),
                      Icon(
                        OzapayIcons.chart,
                        size: kSpacing * 2,
                      ),
                      const SizedBox(width: kSpacing * 0.5),
                      WalletCurrencyChange(percentage: state.percentage),
                    ],
                  ),
                ),
              ),

              // Token balances
              Expanded(
                child: CustomBottomsheet(
                  child: EasyRefresh.builder(
                    onRefresh: () {
                      context.read<WalletBloc>().add(OnTokenGot());
                      return Future.delayed(Duration.zero);
                    },
                    header: MaterialHeader(),
                    childBuilder: (context, physics) {
                      return SingleChildScrollView(
                        padding: EdgeInsets.all(kSpacing * 2),
                        physics: physics,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              "Tous mes actifs",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: kSpacing * 2),
                            Builder(
                              builder: (context) {
                                switch (state.status) {
                                  case LoadingStatus _:
                                    return SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.4,
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    );

                                  case LoadedStatus _:
                                  default:
                                    return TokenList(
                                        tokens: state.tokenBalances);
                                }
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class TokenList extends StatelessWidget {
  final List<TokenBalanceInfoModel> tokens;

  const TokenList({super.key, required this.tokens});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: tokens.length,
      itemBuilder: (context, index) {
        final token = tokens[index];

        return TokenTile(
          image: token.info.image,
          name: token.info.name,
          balance: "${token.balance.balance} ${token.info.symbol}",
          currency: token.balanceInCurrency.balanceCurrency,
        );
      },
    );
  }
}
