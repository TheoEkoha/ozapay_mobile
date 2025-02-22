import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:ozapay/core/constants.dart';
import 'package:ozapay/theme.dart';

class NoContactPayment extends StatelessWidget {
  const NoContactPayment({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height,
      child: Column(
        children: [
          SizedBox(height: kSpacing * 6),
          SvgPicture.asset('assets/icons/wifi.svg'),
          Text(
            'Payer via NFC',
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: kSpacing * 3),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(kSpacing * 3).copyWith(top: kSpacing * 2),
              decoration: BoxDecoration(
                color: lightThemeBgColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(borderRadius * 2),
                  topRight: Radius.circular(borderRadius * 2),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  InkWell(
                    onTap: () {
                      context.pop();
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        RotatedBox(
                          quarterTurns: -45,
                          child: Icon(Icons.arrow_back_ios),
                        ),
                        SizedBox(width: kSpacing),
                        Padding(
                          padding: const EdgeInsets.only(top: kSpacing * 1.5),
                          child: Text(
                            'Payer sans contact',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: kSpacing * 2),
                  Text(
                    'Touchez l’appareil du créditeur ou scannez ce Qr-Code pour payer !',
                    textAlign: TextAlign.center,
                  ),
                  Divider(
                    height: kSpacing * 6,
                  ),
                  Text(
                    'En attente des informations...',
                    textAlign: TextAlign.center,
                  ),
                  TextButton(
                    onPressed: () {
                      context.pop();
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: defaultTextStyle.color,
                    ),
                    child: Text(
                      'Annuler le paiement',
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
