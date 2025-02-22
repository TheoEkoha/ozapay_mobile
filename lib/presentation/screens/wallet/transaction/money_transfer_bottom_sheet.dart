import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:ozapay/presentation/screens/wallet/transaction/no_contact_payment.dart';
import 'package:ozapay/theme.dart';

import '../../../../core/constants.dart';

class MoneyTransferBottomSheet extends StatelessWidget {
  const MoneyTransferBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height * .5,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Transférer de l’Argent',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: kSpacing),
          Text(
            'Envoyez, encaissez, échangez et transférez des fonds partout !',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          SizedBox(height: kSpacing * 2),
          buildItem(
            context,
            'nfc',
            'Payer sans contact',
            'Paiement via NFC ou QR-CODE',
            redColor,
            onTap: () {
              context.pop();
              showModalBottomSheet(
                backgroundColor: Colors.black.withOpacity(.75),
                context: context,
                shape: BeveledRectangleBorder(),
                isScrollControlled: true,
                builder: (context) => NoContactPayment(),
              );
              // showBottomSheet(
              //   context: context,
              //   builder: (context) => NoContactPayment(),
              // );
            },
          ),
          buildItem(
            context,
            'send',
            'Transférer des fonds',
            'Envoyer de l’argent',
            Theme.of(context).colorScheme.primary,
            onTap: () {},
          ),
          buildItem(
            context,
            'received_payement',
            'Demander un paiement',
            'Via notification, QR-CODE et NFC',
            yellowColor,
            onTap: () {},
          ),
          buildItem(
            context,
            'cash',
            'Convertir des cryptos',
            'Investir et échanger des cryptos',
            Color(0xFF757673),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget buildItem(BuildContext context, String svgName, String title,
      String subtitle, Color color,
      {required void Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(kSpacing).copyWith(bottom: kSpacing * 1.5),
        margin: EdgeInsets.only(bottom: kSpacing * 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(20).copyWith(topRight: Radius.zero),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(10, 10),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  height: kSpacing * 5,
                  width: kSpacing * 5,
                  padding: const EdgeInsets.all(kSpacing),
                  margin: const EdgeInsets.only(right: kSpacing * 1.5),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius:
                        const BorderRadius.all(Radius.circular(kSpacing))
                            .copyWith(topRight: const Radius.circular(0)),
                  ),
                  child: SvgPicture.asset('assets/icons/$svgName.svg'),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.w500),
                    ),
                    Text(subtitle),
                  ],
                ),
              ],
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFFC8C8D3),
            )
          ],
        ),
      ),
    );
  }
}
