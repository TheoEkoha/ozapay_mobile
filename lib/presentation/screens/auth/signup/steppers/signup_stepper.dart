import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ozapay/core/constants.dart';
import 'package:ozapay/data/enums/enum.dart';
import 'package:ozapay/data/params/params.dart';
import 'package:ozapay/presentation/blocs/auth/auth_bloc.dart';
import 'package:ozapay/presentation/widgets/widget.dart';
import 'package:ozapay/theme.dart';

import '../../controllers/signup_controller.dart';

typedef SignupCallback = void Function(
    RegisterParams params, SignupStepperEnum step);

class SignupStepper extends StatelessWidget {
  final VoidCallback onPop;
  final SignupStepperEnum currentStep;
  final List<Step> steps;
  final bool customBuilder;
  final bool customTitle;
  final SignupCallback onStepChanged;

  const SignupStepper({
    super.key,
    required this.currentStep,
    required this.steps,
    this.customTitle = false,
    this.customBuilder = false,
    required this.onPop,
    required this.onStepChanged,
  });

  @override
  Widget build(BuildContext context) {
    final step = steps[currentStep.index];

    return Scaffold(
      appBar: customTitle
          ? null
          : AppBar(
              leading: Transform.translate(
                offset: Offset(0, -1),
                child: IconButton(
                  onPressed: onPop,
                  icon: const Icon(
                    OzapayIcons.caret_left,
                    size: 28,
                  ),
                ),
              ),
              foregroundColor: Colors.white,
              title: Transform.translate(
                offset: Offset(-kSpacing * 3, 0),
                child: Align(
                  alignment: Alignment.center,
                  child: step.title,
                ),
              ),
              centerTitle: true,
            ),
      body: customBuilder
          ? step.content
          : Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: CustomCard(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      step.content,
                      const SizedBox(height: kSpacing * 3),
                      LoadingButton(
                        onPressed: () {
                          context.read<SignupProvider>().validateFields(
                            (value) {
                              onStepChanged.call(value, currentStep);
                            },
                          );
                        },
                        loading:
                            context.watch<AuthBloc>().state is AuthLoadingState,
                        child: const Text("buttons.continue").tr(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
