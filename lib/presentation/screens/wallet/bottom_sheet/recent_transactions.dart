import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ozapay/core/constants.dart';
import 'package:ozapay/core/extension.dart';
import 'package:ozapay/core/http_request/multiple_result.dart';
import 'package:ozapay/core/ozapay/ozapay.dart';
import 'package:ozapay/presentation/blocs/bloc_status.dart';
import 'package:ozapay/presentation/blocs/wallet/wallet_bloc.dart';
import 'package:ozapay/presentation/faker.dart';
import 'package:ozapay/presentation/widgets/widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'unverified_account_screen.dart';

class RecentTransactions extends StatelessWidget {
  final VoidCallback onRefresh;
  final Widget button;

  const RecentTransactions({
    super.key,
    required this.button,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WalletBloc, WalletState>(
      listener: (context, state) {
        if (state.error != null) {
          context.showSnackBar(
            (state.error as Failure).message.join(" "),
            error: true,
          );
        }
      },
      builder: (context, state) {
        switch (state.status) {
          case LoadedStatus _:
            return buildItems(context, state.transactions);

          case LoadingStatus _:
            return Skeletonizer(
              enabled: true,
              child: buildItems(context, fakeTransactions),
            );

          default:
            return UnverifiedAccountScreen();
        }
      },
    );
  }

  buildItems(BuildContext context, List<TransactionHistory> transactions) {
    return CustomBottomsheet(
      child: RefreshIndicator(
        onRefresh: () {
          onRefresh();
          return Future.delayed(Duration.zero);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: kSpacing * 2,
            horizontal: kSpacing * 2.5,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Transactions",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                  button,
                ],
              ),
              SizedBox(height: kSpacing * 2),
              transactions.isEmpty
                  ? Center(child: Text("Aucune transaction trouvé !"))
                  : Expanded(
                      child: ListView.separated(
                        primary: true,
                        shrinkWrap: true,
                        itemCount: transactions.length,
                        separatorBuilder: (_, __) => SizedBox(height: kSpacing),
                        itemBuilder: (context, index) {
                          final txn = transactions[index];
                          final instruction = txn.instruction;

                          final symbol = 'SOL';

                          final balance =
                              "${instruction.amount.abs().balance} $symbol";
                          final isTransfer = instruction.amount.isNegative;
                          final op = instruction.amount.isNegative ? "-" : "+";
                          final transaction =
                              "${isTransfer ? "Vers" : "De"}: ${instruction.source.truncatedAddress}";
                          final timestamp =
                              DateFormat.yMd("fr-FR").format(txn.timestamp);

                          return ListTile(
                            minTileHeight: 30,
                            contentPadding: EdgeInsets.zero,
                            horizontalTitleGap: kSpacing,
                            titleTextStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                            leading: txn.token?['uri'] != null
                                ? CachedNetworkImage(
                                    imageUrl: txn.token!['uri'],
                                    width: 35,
                                    height: 35,
                                  )
                                : Image.asset(
                                    'assets/images/solana-logo.png',
                                    width: 35,
                                    height: 35,
                                  ),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(instruction.memo ??
                                    (isTransfer ? 'Envoyé' : 'Reçu')),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: op.padRight(2, " "),
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: isTransfer
                                                ? Colors.red
                                                : Color(0xFF52E34F)),
                                      ),
                                      TextSpan(text: balance),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Text(
                              "$transaction, le $timestamp",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: "Quicksand",
                                fontSize: 12,
                                color: Color(0xFF868686),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
