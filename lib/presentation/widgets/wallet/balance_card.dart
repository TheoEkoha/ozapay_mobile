import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ozapay/core/constants.dart';
import 'package:ozapay/core/extension.dart';
import 'package:ozapay/data/services/injection/injection_service.dart';
import 'package:ozapay/data/services/prefs/prefs_service.dart';
import 'package:ozapay/presentation/screens/wallet/receive/qr_code_screen.dart';
import 'package:ozapay/presentation/widgets/ozapay_icons.dart';
import 'package:ozapay/theme.dart';

enum CardType {
  bank("Mon COMPTE", Colors.white, primaryColor),
  crypto("Mes Cryptomonnaies", Colors.black, yellowColor);

  final String value;
  final Color foregroundColor, backgroundColor;

  const CardType(this.value, this.foregroundColor, this.backgroundColor);
}

class BalanceCard extends StatefulWidget {
  final CardType cardType;
  final bool isActivated;

  const BalanceCard({
    super.key,
    required this.balance,
    this.cardType = CardType.bank,
    this.isActivated = true,
  });

  final double balance;

  @override
  State<BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> {
  bool hide = getIt<PrefsService>().getHideBalance() ?? false;

  void toggleHideBalance() {
    setState(() {
      hide = !hide;
      getIt<PrefsService>().setHideBalance(hide);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(defaultPadding)
          .copyWith(bottom: kSpacing * 1.5, top: 6),
      child: AspectRatio(
        aspectRatio: 6 / 3,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(kSpacing * 3),
          child: Container(
            color: !widget.isActivated
                ? Color(0xFFB0B0BC)
                : widget.cardType.backgroundColor,
            child: Stack(
              children: [
                /// Decorations
                Positioned(
                  left: 0,
                  top: 0,
                  child: Image.asset(
                    'assets/images/card-bg-home-left.png',
                    width: 110,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Image.asset(
                    'assets/images/card-bg-home-right.png',
                    width: 150,
                  ),
                ),

                /// Show/Hide balance
                Positioned(
                  top: 0,
                  left: kSpacing,
                  child: IconButton(
                    onPressed: toggleHideBalance,
                    icon: Icon(
                      hide ? OzapayIcons.eye_slash : OzapayIcons.visibility,
                      size: kSpacing * 2,
                      color: widget.cardType.foregroundColor,
                    ),
                  ),
                ),

                /// Credit Card
                Positioned(
                  top: 0,
                  right: kSpacing,
                  child: IconButton(
                    onPressed: () {
                      if (widget.cardType == CardType.bank) {
                      } else {
                        context.push(QrCodeScreen.route);
                      }
                    },
                    icon: Icon(
                      widget.cardType == CardType.bank
                          ? OzapayIcons.card
                          : OzapayIcons.qr_code,
                      size: widget.cardType == CardType.bank
                          ? kSpacing * 2.5
                          : kSpacing * 2,
                      color: widget.cardType.foregroundColor,
                    ),
                  ),
                ),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: kSpacing * 3,
                    vertical: kSpacing * 4,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.cardType.value,
                        style: TextStyle(
                          fontSize: 13,
                          color: widget.cardType.foregroundColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),

                      /// Balance
                      Text(
                        hide ? '*****' : BalanceParsing(widget.balance).balance,
                        style: TextStyle(
                          fontSize: 36,
                          color: widget.cardType.foregroundColor,
                          fontWeight: FontWeight.w700,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 12),

                      /// Currency
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: kSpacing,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(kSpacing * 3),
                          color: !widget.isActivated
                              ? Color(0xFF525252)
                              : widget.cardType == CardType.bank
                                  ? Color(0xFF149DA8)
                                  : Color(0xFFF1DDAD),
                        ),
                        child: Text(
                          "EUROS",
                          style: TextStyle(
                            fontSize: 12,
                            color: widget.cardType.foregroundColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
