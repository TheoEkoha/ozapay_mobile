import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:ozapay/core/constants.dart';
import 'package:ozapay/presentation/screens/promotion/list_offer_promotion.dart';
import 'package:ozapay/presentation/widgets/drawer/setting_screen_scaffold.dart';
import 'package:ozapay/theme.dart';

class PromotionalSpaceScreen extends StatelessWidget {
  const PromotionalSpaceScreen({super.key});

  static const route = '/promotion';

  @override
  Widget build(BuildContext context) {
    return SettingScreenScaffold(
      appBarActions: [
        GestureDetector(
          onTap: () {
            context.push(ListOfferPromotion.route);
          },
          child: Row(
            children: [
              Text('Promouvoir une Offre'),
              Padding(
                padding:
                    const EdgeInsets.only(left: kSpacing, right: kSpacing * 3),
                child: SvgPicture.asset('assets/images/plus.svg'),
              )
            ],
          ),
        )
      ],
      body: ListView(
        padding: EdgeInsets.all(kSpacing * 3),
        children: [
          Text(
            'Espace Promotionnel',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: kSpacing * 2),
          Row(
            children: [
              ...List.generate(
                PromotionStatus.values.length,
                (index) {
                  return Expanded(
                    child: Padding(
                      padding:
                          EdgeInsets.only(left: index == 0 ? 0 : kSpacing * 2),
                      child: FilledButton(
                        onPressed: null,
                        style: FilledButton.styleFrom(
                          fixedSize: Size.fromHeight(30),
                          padding: EdgeInsets.symmetric(
                            vertical: 0,
                            horizontal: kSpacing,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                                    Radius.circular(borderRadius * 2))
                                .copyWith(topRight: Radius.zero),
                          ),
                        ),
                        child: Text(
                          PromotionStatus.values[index].title,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          SizedBox(height: kSpacing * 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Toutes mes Offres',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontSize: kSpacing * 2),
              ),
              Image.asset('assets/images/search.png'),
            ],
          ),
          SizedBox(height: kSpacing * 2),
          Text(
            'Aucune offre trouvée',
          ),
          SizedBox(height: kSpacing * 2),
          Text(
            'Publier ma 1ère offre dès maintenant !',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontSize: kSpacing * 2, color: Theme.of(context).colorScheme.primary),
          ),
          Container(
            height: 150,
            margin: EdgeInsets.symmetric(vertical: kSpacing * 2),
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(20).copyWith(topRight: Radius.zero),
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/smiley_face.png',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Text.rich(
            textAlign: TextAlign.center,
            TextSpan(
              text: 'Ne soyez plus perdu sur le web !\n',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontSize: 14),
              children: [
                TextSpan(
                    text:
                        'Choisissez votre thématique, partagez vos offres et gagnez de l’argent !',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontSize: 14))
              ],
            ),
          ),
          SizedBox(height: kSpacing * 3),
          FilledButton(
            onPressed: () {
              context.push(ListOfferPromotion.route);
            },
            child: Text('Promouvoir une Offre'),
          )
        ],
      ),
    );
  }
}

enum PromotionStatus {
  approved('Approuvées'),
  waiting('En Attente'),
  trash('Corbeille');

  final String title;

  const PromotionStatus(this.title);
}
