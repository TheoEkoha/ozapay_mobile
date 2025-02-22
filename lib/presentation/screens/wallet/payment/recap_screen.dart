import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ozapay/core/extension.dart';
import 'package:ozapay/core/ozapay/ozapay.dart';
import 'package:ozapay/presentation/blocs/bloc_status.dart';
import 'package:ozapay/presentation/blocs/wallet/wallet_bloc.dart';
import 'package:ozapay/presentation/widgets/widget.dart';

class RecapScreen extends StatefulWidget {
  final String recipientAddress;
  final TokenBalanceInfoModel token;

  static final route = "/recap";

  const RecapScreen({
    super.key,
    required this.recipientAddress,
    required this.token,
  });

  @override
  State<RecapScreen> createState() => _RecapScreenState();
}

class _RecapScreenState extends State<RecapScreen> {
  TextEditingController amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context)
        .textTheme
        .displaySmall
        ?.copyWith(fontWeight: FontWeight.w600, fontSize: 48);

    return ScaffoldWithBackButton(
      body: BlocListener<WalletBloc, WalletState>(
        listener: (context, state) async {
          if (state.status is TokenTransferedStatus) {
            context.popUntil("/");
            context.pushReplacement("/");
          }
          if (state.status is ATACreatedStatus) {
            await transferToken();
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("À : ${widget.recipientAddress}"),
            Expanded(
              child: Center(
                child: SizedBox(
                  width: 250,
                  child: TextFormField(
                    autofocus: true,
                    controller: amountController,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      filled: false,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      suffixText: widget.token.info.symbol,
                      suffixStyle: textTheme,
                      hintStyle: textTheme,
                    ),
                    cursorColor: Colors.black,
                    style: textTheme,
                    keyboardType: TextInputType.numberWithOptions(),
                  ),
                ),
              ),
            ),
            LoadingButton(
              loading:
                  context.watch<WalletBloc>().state.status is LoadingStatus,
              onPressed: createATA,
              child: Text("Envoyer"),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> get _privateKey async =>
      (await context.read<WalletBloc>().state.keypair!.extract())
          .bytes
          .toString();

  Future<void> createATA() async {
    context.read<WalletBloc>().add(OnATACreated(
          senderPrivateKey: await _privateKey,
          recipientAddress: widget.recipientAddress,
          tokenAddress: widget.token.address,
        ));
  }

  Future<void> transferToken() async {
    context.read<WalletBloc>().add(OnTokenTransfered(
          senderPrivateKey: await _privateKey,
          recipientAddress: widget.recipientAddress,
          tokenAddress: widget.token.address,
          amount: double.parse(amountController.text),
        ));
  }
}
