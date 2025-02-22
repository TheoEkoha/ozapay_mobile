import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:ozapay/core/constants.dart';
import 'package:ozapay/core/extension.dart';
import 'package:ozapay/presentation/blocs/wallet/wallet_bloc.dart';
import 'package:ozapay/presentation/widgets/ozapay_icons.dart';

import 'select_token_list_screen.dart';

class ScanQrCodeScreen extends StatefulWidget {
  const ScanQrCodeScreen({super.key});

  static final String route = '/send-crypto';

  @override
  State<ScanQrCodeScreen> createState() => _ScanQrCodeScreenState();
}

class _ScanQrCodeScreenState extends State<ScanQrCodeScreen> {
  final MobileScannerController controller = MobileScannerController();

  Barcode? barcode;

  String get barcodeValueAsAddress =>
      "${barcode!.displayValue!.substring(0, 6)}..."
      "${barcode!.displayValue!.substring(barcode!.displayValue!.length - 7, barcode!.displayValue!.length - 1)}";

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (context.read<WalletBloc>().state.keypair == null) {
        context.showSnackBar(
            "Nous n'avons pas trouvé votre clé privé nécessaire pour effectuer cette action.");

        await Future.delayed(Duration(milliseconds: 500)).then((_) {
          if (!mounted) return;
          context.pop();
        });
      }

      await controller.start();
    });

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        toolbarHeight: 90,
        flexibleSpace: Padding(
          padding: EdgeInsets.only(top: kToolbarHeight),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                OzapayIcons.qr_code,
                color: Colors.white,
              ),
              SizedBox(height: kSpacing),
              Text(
                "Scanner un code QR",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
          vertical: kSpacing * 2,
          horizontal: kSpacing * 3,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(kSpacing * 3),
            topRight: Radius.circular(kSpacing * 3),
          ),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Scanner l'addresse pour envoyer des fonds",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Quicksand',
                    color: Color(0xFF4F4F4F),
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: kSpacing * 2),
            Divider(
              thickness: 1,
              height: kSpacing * 3,
              indent: kSpacing,
              endIndent: kSpacing,
              color: Color(0xFFECECEC),
            ),
            SizedBox(height: kSpacing * 2),
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Center(
                    child: SizedBox(
                      width: 280,
                      height: 280,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: kSpacing),
                        child: MobileScanner(
                          controller: controller,
                          onDetect: onDetect,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 320,
                    height: 320,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image:
                            Image.asset('assets/images/scan_border.png').image,
                        filterQuality: FilterQuality.high,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: kSpacing * 2),
            Divider(
              thickness: 1,
              height: kSpacing * 3,
              indent: kSpacing,
              endIndent: kSpacing,
              color: Color(0xFFECECEC),
            ),
            SizedBox(height: kSpacing * 2),
            Text(
              barcode == null
                  ? "En attente des informations..."
                  : barcodeValueAsAddress,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void onDetect(BarcodeCapture capture) async {
    setState(() {
      barcode = capture.barcodes.firstOrNull;
    });

    if (barcode != null && barcode!.displayValue != null) {
      controller.stop().then((_) => context.push(
            SelectTokenListScreen.route,
            extra: barcode!.displayValue!,
          ));
    }
  }
}
