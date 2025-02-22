import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ozapay/presentation/screens/promotion/create/create_promotion_screen.dart';
import 'package:ozapay/presentation/widgets/drawer/setting_screen_scaffold.dart';
import '../../../core/constants.dart';

class ListOfferPromotion extends StatelessWidget {
  const ListOfferPromotion({super.key});

  static const route = '/promotion/list-offer';

  @override
  Widget build(BuildContext context) {
    return SettingScreenScaffold(
      appBarActions: [
        GestureDetector(
          child: Row(
            children: [
              Text('Espace Promotionnel'),
              Padding(
                padding:
                    const EdgeInsets.only(left: kSpacing, right: kSpacing * 3),
                child: Image.asset('assets/images/list.png'),
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
          Text(
            'Choisissez votre thématique, partagez vos offres et gagnez de l’argent !',
          ),
          SizedBox(height: kSpacing * 2),
          ...List.generate(
            thematics.length,
            (index) {
              return OfferWidget(
                thematic: thematics[index],
              );
            },
          )
        ],
      ),
    );
  }
}

class OfferThematic extends Equatable {
  const OfferThematic({this.name, this.examples, this.placeholder});

  final String? name;
  final List<String>? examples;
  final String? placeholder;

  @override
  List<Object?> get props => [name, examples, placeholder];
}

final thematics = [
  OfferThematic(
    name: 'Activité Locale',
    examples: ['Événements', 'Loisirs', 'Sites Culturels'],
    placeholder: 'assets/images/activite.png',
  ),
  OfferThematic(
    name: 'Bar/Resto',
    examples: ['Cafés', 'Brasseries', 'Pizzerias', 'Restaurants'],
    placeholder: 'assets/images/resto.png',
  ),
  OfferThematic(
    name: 'Commerce',
    examples: ['Alimentaires', 'Boutiques', 'Stands', 'Fournisseurs'],
    placeholder: 'assets/images/commerce.png',
  ),
];

class OfferWidget extends StatelessWidget {
  const OfferWidget({super.key, required this.thematic});

  final OfferThematic thematic;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(
          CreatePromotionScreen.route,
          extra: {'thematic': thematic},
        );
      },
      child: Column(
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: thematic.name ?? '',
                  style: Theme.of(context).textTheme.titleMedium,
                  children: [
                    TextSpan(
                      text: ' (${thematic.examples?.join(', ') ?? ''}...)',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: 150,
            margin: EdgeInsets.only(top: kSpacing, bottom: kSpacing * 3),
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(20).copyWith(topRight: Radius.zero),
              image: DecorationImage(
                image: Image.asset(
                  thematic.placeholder ?? 'assets/images/smiley_face.png',
                ).image,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
