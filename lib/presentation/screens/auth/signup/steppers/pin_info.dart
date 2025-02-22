import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:ozapay/core/constants.dart';
import 'package:ozapay/core/extension.dart';
import 'package:ozapay/data/enums/enum.dart';
import 'package:ozapay/presentation/blocs/auth/auth_bloc.dart';
import 'package:ozapay/presentation/widgets/widget.dart';
import 'package:ozapay/theme.dart';
import 'package:provider/provider.dart';

import '../../controllers/signup_controller.dart';

class PinInfo extends StatelessWidget {
  final SignupStepperEnum step;
  final String fieldName;

  const PinInfo({
    super.key,
    required this.step,
    required this.fieldName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 30,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(borderRadius * 1.5),
            topRight: Radius.circular(borderRadius * 1.5),
          ),
        ),
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * .8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: kSpacing * 2),
                Text(
                  step.title.tr(),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                const SizedBox(height: kSpacing * 2),
                Image.asset(
                  step == SignupStepperEnum.pin
                      ? 'assets/images/timer.png'
                      : 'assets/images/check.png',
                  width: 76,
                ),
                const SizedBox(height: kSpacing * 2),
                PinCode(
                  name: fieldName,
                  pinLength: 6,
                  textStyle: const TextStyle(
                    fontSize: kSpacing * 4,
                    fontWeight: FontWeight.w300,
                    color: Colors.black,
                  ),
                  onEnter: (String pin) {
                    if (step == SignupStepperEnum.pin) {
                      context.read<SignupProvider>().validateFields(
                        (value) {
                          value.toJson().log();

                          context.read<SignupProvider>().next();
                        },
                      );
                    } else {
                      context.read<SignupProvider>().validateFields(
                        (params) {
                          if (params.pin != params.confirmPin) {
                            FormBuilder.of(context)
                                ?.fields['confirmPin']
                                ?.invalidate("errors.password".tr());
                          } else {
                            context.read<AuthBloc>().add(OnPatch(params
                                .copyWith(confirmPin: null, step: 'pin')));
                          }
                        },
                      );
                    }
                  },
                ),
                const SizedBox(height: kSpacing * 4),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
