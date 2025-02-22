import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:ozapay/core/constants.dart';
import 'package:ozapay/presentation/screens/promotion/create/create_promotion_controller.dart';
import 'package:ozapay/presentation/screens/promotion/created_promotion_screen.dart';
import 'package:ozapay/presentation/screens/promotion/list_offer_promotion.dart';
import 'package:ozapay/presentation/widgets/drawer/promotion/discount_slider.dart';
import 'package:ozapay/presentation/widgets/drawer/promotion/input_decorations.dart';
import 'package:ozapay/presentation/widgets/drawer/promotion/multimedia_promotion.dart';
import 'package:ozapay/presentation/widgets/drawer/promotion/operation_days.dart';
import 'package:ozapay/presentation/widgets/drawer/promotion/underline_input_field.dart';
import 'package:ozapay/presentation/widgets/drawer/setting_screen_scaffold.dart';
import 'package:ozapay/presentation/widgets/form_field_phone.dart';
import 'package:ozapay/presentation/widgets/loading_button.dart';
import 'package:ozapay/theme.dart';

import '../../../widgets/drawer/promotion/custom_checkbox.dart';
import '../../../widgets/drawer/promotion/pricing_dropdown.dart';
import '../../../widgets/drawer/promotion/promotion_info_form.dart';

class CreatePromotionScreen extends StatefulWidget {
  const CreatePromotionScreen({super.key, required this.thematic});

  final OfferThematic thematic;
  static const route = '/promotion/create';

  @override
  State<CreatePromotionScreen> createState() => _CreatePromotionScreenState();
}

class _CreatePromotionScreenState extends State<CreatePromotionScreen> {
  late CreatePromotionController controller;

  @override
  void initState() {
    controller = CreatePromotionController();
    super.initState();
  }

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
            'Thématique : ${widget.thematic.name}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(
            height: kSpacing * 2,
          ),
          Container(
            height: 150,
            margin: EdgeInsets.only(top: kSpacing, bottom: kSpacing * 3),
            decoration: BoxDecoration(
              color: disabledColor,
              borderRadius:
                  BorderRadius.circular(20).copyWith(topRight: Radius.zero),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/placeholder.png'),
                SizedBox(height: kSpacing),
                Text(
                  'Photos de couverture',
                  style: TextStyle(color: darkGrey),
                )
              ],
            ),
          ),
          SizedBox(
            height: kSpacing * 2,
          ),
          PromotionInfoForm(),
          SizedBox(height: kSpacing * 3),
          MultimediaPromotion(),
          SizedBox(height: kSpacing * 3),
          UnderlineInputField(
            label: 'Site Web',
            fieldName: 'website',
            hintText: 'https://www.monsite.com',
          ),
          SizedBox(height: kSpacing * 3),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Téléphone',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              Expanded(
                flex: 3,
                child: FormBuilderPhone(
                  name: "phone",
                  decoration: UnderlineInputDecoration(
                    filled: false,
                    hintText: "fields.phoneHint".tr(),
                  ),
                  validator: FormBuilderValidators.required(),
                ),
              ),
            ],
          ),
          SizedBox(height: kSpacing * 3),
          PricingDropdown(),
          SizedBox(height: kSpacing),
          DiscountSlider(controller: controller),
          SizedBox(height: kSpacing),
          // OperationDays(),
          ListenableBuilder(
            listenable: controller,
            builder: (context, child) {
              return Column(
                children: [
                  ...List.generate(operationDays.length, (index) {
                    final day = operationDays[index];
                    return CustomCheckbox(
                      value: controller.checkDay(day),
                      onChanged: (value) {
                        controller.addOrRemoveDay(value!, day);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${day.name}'),
                          Text.rich(
                            TextSpan(
                              text: 'de ',
                              style: Theme.of(context).textTheme.bodySmall,
                              children: [
                                TextSpan(
                                  text: '${day.morning?.start}h ',
                                  style: TextStyle(color: lightGreyColor),
                                ),
                                TextSpan(text: 'à '),
                                TextSpan(
                                  text: '${day.morning?.end}h ',
                                  style: TextStyle(color: lightGreyColor),
                                ),
                                TextSpan(text: ' et de '),
                                TextSpan(
                                  text: ' ${day.afternoon?.start}h ',
                                  style: TextStyle(color: lightGreyColor),
                                ),
                                TextSpan(text: 'à '),
                                TextSpan(
                                  text: '${day.afternoon?.end}h ',
                                  style: TextStyle(color: lightGreyColor),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  }),
                ],
              );
            },
          ),
          SizedBox(height: kSpacing * 2),
          Text(
            'Présentation',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          SizedBox(height: kSpacing),
          FormBuilderTextField(
            name: 'presentation',
            maxLines: 5,
            decoration: OutlineInputDecoration(
              hintText: 'Tapez ici votre description (ou programme)',
              filled: false,
            ),
          ),
          SizedBox(height: kSpacing * 2),
          Text(
            'Précisions',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          SizedBox(height: kSpacing),
          FormBuilderTextField(
            name: 'precision',
            maxLines: 2,
            decoration: OutlineInputDecoration(
              hintText: 'Tapez ici votre description (ou programme)',
              filled: false,
            ),
          ),
          SizedBox(height: kSpacing * 2),
          Text(
            'Choix du mot clé principal',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          SizedBox(height: kSpacing),
          FormBuilderTextField(
            name: 'keyWord',
            decoration: OutlineInputDecoration(
              hintText: 'Tapez ici votre description (ou programme)',
              filled: false,
            ),
          ),
          SizedBox(height: kSpacing * 3),
          LoadingButton(
            loading: false,
            onPressed: () {
              context.pushReplacement(CreatedPromotionScreen.route);
              // controller.publish();
            },
            child: Text('Publier'),
          )
        ],
      ),
    );
  }
}
