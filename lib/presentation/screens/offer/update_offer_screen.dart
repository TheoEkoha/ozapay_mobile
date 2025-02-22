import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ozapay/core/constants.dart';
import 'package:ozapay/data/enums/enum.dart';
import 'package:ozapay/domain/entities/auth/user_entity.dart';
import 'package:ozapay/presentation/widgets/widget.dart';

import '../../widgets/offer_widget.dart';

class UpdateOfferScreen extends StatelessWidget {
  const UpdateOfferScreen({super.key});

  static const route = '/update-offer';
  final currentOffer = OfferTypeEnum.liberty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leading: IconButton(
          onPressed: context.pop,
          icon: const Icon(
            OzapayIcons.caret_left,
          ),
        ),
        title: Text(
          "Menu",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
              ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(kSpacing * 3),
        children: [
          const UserInfo(
            showOffer: false,
            textColor: Colors.white,
            user: UserEntity(firstName: 'Username'),
          ),
          const SizedBox(height: kSpacing * 2),
          CustomCard(
            color: Colors.transparent,
            border: Border.all(color: currentOffer.color, width: 3),
            padding:
                const EdgeInsets.all(kSpacing * 2.5).copyWith(bottom: kSpacing),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Offre active sur votre COMPTE',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.white),
                    ),
                    OfferWidget(
                      offer: currentOffer,
                    )
                  ],
                ),
                const SizedBox(height: kSpacing * 2),
                Text(
                  currentOffer.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: currentOffer.color,
                        fontWeight: FontWeight.w700,
                        fontSize: kSpacing * 3.5,
                      ),
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                  child: const Text(
                    'Demander la résiliation du compte',
                    style: TextStyle(
                      color: Colors.white,
                      decoration: TextDecoration.underline,
                      fontSize: kSpacing * 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: kSpacing * 2),
          Text(
            'Évoluer mon Offre',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Text(
            'Booster mes performances',
          ),
        ],
      ),
    );
  }
}
