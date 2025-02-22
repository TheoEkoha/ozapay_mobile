import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ozapay/core/constants.dart';
import 'package:ozapay/core/extension.dart';
import 'package:ozapay/presentation/blocs/bloc_status.dart';
import 'package:ozapay/presentation/blocs/wallet/wallet_bloc.dart';
import 'package:ozapay/presentation/widgets/widget.dart';

import 'recap_screen.dart';

class SelectTokenListScreen extends StatefulWidget {
  final String recipientAddress;

  const SelectTokenListScreen({super.key, required this.recipientAddress});

  static final route = '/select-token-list';

  @override
  State<SelectTokenListScreen> createState() => _SelectTokenListScreenState();
}

class _SelectTokenListScreenState extends State<SelectTokenListScreen> {
  @override
  void initState() {
    final walletBloc = context.read<WalletBloc>();

    if (walletBloc.state.tokenBalances.isEmpty) {
      walletBloc.add(OnTokenGot());
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithBackButton(
      body: BlocConsumer<WalletBloc, WalletState>(
        listener: (context, state) {
          if (state.status is AllTokenBalancesGotStatus) {
            context.read<WalletBloc>().add(OnWalletBalanceGot());
          }
        },
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Sélectionner un jeton",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Quicksand',
                      color: Color(0xFF4F4F4F),
                    ),
              ),
              SizedBox(height: kSpacing * 2),
              Expanded(
                child: Builder(builder: (context) {
                  switch (state.status) {
                    case LoadingStatus _:
                      return Center(child: CircularProgressIndicator());

                    case LoadedStatus _:
                    default:
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.tokenBalances.length,
                        itemBuilder: (context, index) {
                          final token = state.tokenBalances[index];

                          return TokenTile(
                            onTap: () {
                              context.push(RecapScreen.route, extra: {
                                "recipientAddress": widget.recipientAddress,
                                "token": token,
                              });
                            },
                            image: token.info.image,
                            name: token.info.name,
                            balance:
                                "${token.balance.balance} ${token.info.symbol}",
                          );
                        },
                      );
                  }
                }),
              ),
            ],
          );
        },
      ),
    );
  }
}
