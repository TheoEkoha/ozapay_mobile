import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ozapay/core/constants.dart';
import 'package:ozapay/presentation/blocs/wallet/wallet_bloc.dart';
import 'package:ozapay/presentation/widgets/widget.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

class QrCodeScreen extends StatelessWidget {
  const QrCodeScreen({super.key});

  static String route = "/receive-crypto";

  @override
  Widget build(BuildContext context) {
    final address = context.watch<WalletBloc>().address!;
    final quickSandStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
        fontFamily: 'Quicksand',
        color: Color(0xFF4F4F4F),
        fontWeight: FontWeight.w600);

    return ScaffoldWithBackButton(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title
            Text(
              'Recevoir des cryptomonnaies',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: kSpacing * 3),

            // Description
            Text(
              'Présentez ce QR-CODE et recevez des cryptomonnaies via le réseau Solana',
              textAlign: TextAlign.center,
              style: quickSandStyle,
            ),

            SizedBox(height: kSpacing),

            // Divider
            Divider(
              thickness: 1,
              height: kSpacing * 3,
              indent: kSpacing,
              endIndent: kSpacing,
              color: Color(0xFFECECEC),
            ),
            SizedBox(height: kSpacing),

            // QR Code
            Center(
              child: QrImageView(
                data: address,
                version: QrVersions.auto,
                size: min(250, MediaQuery.of(context).size.width * 0.65),
                padding: EdgeInsets.zero,
              ),
            ),
            SizedBox(height: kSpacing),

            Divider(
              thickness: 1,
              height: kSpacing * 3,
              indent: kSpacing,
              color: Color(0xFFECECEC),
            ),
            Text(
              "OU",
              textAlign: TextAlign.center,
              style: quickSandStyle,
            ),
            Divider(
              thickness: 1,
              height: kSpacing * 3,
              indent: kSpacing,
              color: Color(0xFFECECEC),
            ),
            SizedBox(height: kSpacing * 2),

            Text(
              'Copiez votre adresse ci-dessous et partagez là à votre destinataire',
              textAlign: TextAlign.center,
              style: quickSandStyle,
            ),
            SizedBox(height: kSpacing * 2),

            OutlinedButton.icon(
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: address));
              },
              style: OutlinedButton.styleFrom(
                textStyle: TextStyle(fontSize: 12),
                foregroundColor: Colors.black,
                padding: EdgeInsets.zero,
                fixedSize: Size.fromHeight(kSpacing * 3),
              ),
              label: Text(
                  "${address.substring(0, 6)}...${address.substring(address.length - 7, address.length - 1)}"),
              icon: Icon(
                OzapayIcons.copy_paste,
                size: kSpacing * 2.5,
              ),
              iconAlignment: IconAlignment.end,
            ),
            SizedBox(height: kSpacing * 2),
            FilledButton(
              onPressed: () async {
                await Share.share(address);
              },
              child: Text("Partager"),
            ),
          ],
        ),
      ),
    );
  }
}
