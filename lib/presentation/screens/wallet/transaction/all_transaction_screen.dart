import 'package:flutter/material.dart' hide Drawer;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ozapay/core/constants.dart';
import 'package:ozapay/presentation/blocs/wallet/wallet_bloc.dart';
import 'package:ozapay/presentation/widgets/widget.dart';

import '../../dashboard/drawer.dart';
import '../bottom_sheet/recent_transactions.dart';

class AllTransactionScreen extends StatelessWidget {
  const AllTransactionScreen({super.key});

  static final route = "/all-transactions";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ConnectedAppbar(
        actions: [
          Container(
            margin: EdgeInsets.only(right: kSpacing * 2),
            constraints: BoxConstraints(maxHeight: 32),
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                textStyle: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(fontWeight: FontWeight.w600),
                backgroundColor: Theme.of(context).colorScheme.tertiary,
                padding: const EdgeInsets.symmetric(horizontal: kSpacing * 1.5),
              ),
              onPressed: () {},
              icon: Icon(
                OzapayIcons.filter,
                size: kSpacing * 2,
              ),
              label: Text("FILTRER"),
            ),
          ),
        ],
      ),
      drawer: Drawer(),
      body: Padding(
        padding: EdgeInsets.only(top: kSpacing),
        child: RecentTransactions(
          onRefresh: () {
            context.read<WalletBloc>().add(OnTransactionHistoryGot(limit: 20));
          },
          button: InkWell(
            onTap: () {
              context.pop();
            },
            child: Text(
              'Voir moins -',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ),
      ),
    );
  }
}
