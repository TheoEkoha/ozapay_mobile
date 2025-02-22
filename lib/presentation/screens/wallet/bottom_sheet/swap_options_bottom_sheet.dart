import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ozapay/core/constants.dart';
import 'package:ozapay/presentation/screens/wallet/payment/scan_qr_code_screen.dart';
import 'package:ozapay/presentation/widgets/widget.dart';
import 'package:ozapay/theme.dart';

class SwapOptionsBottomSheet extends StatelessWidget {
  const SwapOptionsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: kSpacing * 3),
        Text(
          'Transférer de l’Argent',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: kSpacing * 2),
        Text(
          'Envoyez, encaissez, échangez et \ntransférez des fonds partout !',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: kSpacing * 2),
        CustomListTile(
          icon: OzapayIcons.nfc,
          colorContainer: Theme.of(context).colorScheme.tertiary,
          title: 'Payer sans contact',
          subtitle: 'Paiement via NFC ou QR-CODE',
          onTap: () {},
        ),
        CustomListTile(
          icon: OzapayIcons.send,
          colorContainer: Theme.of(context).colorScheme.primary,
          title: 'Transférer des fonds',
          subtitle: 'Envoyer de l’argent',
          onTap: () {
            context.push(ScanQrCodeScreen.route);
          },
        ),
        CustomListTile(
          icon: OzapayIcons.get_pay,
          colorContainer: Color(0xffF4AF02),
          title: 'Demander un paiement',
          subtitle: 'Via notification, QR-CODE et NFC',
          onTap: () {},
        ),
        CustomListTile(
          icon: OzapayIcons.money,
          colorContainer: Color(0xFF757673),
          title: 'Convertir des fonds',
          subtitle: 'Investir et échanger des cryptos',
          onTap: () {
            //context.push(SwapScreen.route);
          },
        ),
      ],
    );
  }
}

class CustomListTile extends StatelessWidget {
  final IconData icon;
  final Color colorContainer;
  final String title, subtitle;
  final VoidCallback onTap;

  const CustomListTile({
    super.key,
    required this.icon,
    required this.colorContainer,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: EdgeInsets.only(bottom: kSpacing * 2.5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(borderRadius).copyWith(topRight: Radius.zero),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.16),
            spreadRadius: 0,
            blurRadius: 10,
            offset: Offset(5, 6),
          )
        ],
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: EdgeInsets.symmetric(
          horizontal: kSpacing * 2,
          vertical: kSpacing * 0.5,
        ),
        minTileHeight: 40,
        horizontalTitleGap: kSpacing * 1.5,
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: colorContainer,
            borderRadius: BorderRadius.circular(12).copyWith(
              topRight: Radius.zero,
            ),
          ),
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        titleTextStyle: textTheme.bodyLarge,
        subtitleTextStyle: textTheme.bodySmall?.copyWith(
          fontSize: 11,
          fontWeight: FontWeight.w400,
        ),
        textColor: Colors.black,
      ),
    );
  }
}
