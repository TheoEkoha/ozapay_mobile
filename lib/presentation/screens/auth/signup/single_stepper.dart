import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ozapay/core/constants.dart';
import 'package:ozapay/data/enums/enum.dart';
import 'package:ozapay/presentation/widgets/widget.dart';

class SingleStepper extends StatelessWidget {
  final SignupStepperEnum step;
  final Widget child;
  final bool customBuilder;
  final VoidCallback? onPop;
  final VoidCallback? onValidate;
  final bool? loading;

  const SingleStepper({
    super.key,
    required this.step,
    required this.child,
    this.customBuilder = false,
    this.onPop,
    this.onValidate,
    this.loading,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: onPop ?? context.pop,
          icon: const Icon(OzapayIcons.caret_left),
        ),
        foregroundColor: Colors.white,
        title: Text(step.title).tr(),
        centerTitle: true,
      ),
      body: customBuilder
          ? child
          : CustomCard(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    child,
                    if (onValidate != null) ...[
                      const SizedBox(height: kSpacing * 3),
                      LoadingButton(
                        onPressed: onValidate!,
                        loading: loading ?? false,
                        child: const Text("buttons.continue").tr(),
                      ),
                    ]
                  ],
                ),
              ),
            ),
    );
  }
}
