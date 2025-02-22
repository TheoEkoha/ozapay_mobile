import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ozapay/core/constants.dart';
import 'package:ozapay/core/http_request/multiple_result.dart';
import 'package:ozapay/presentation/blocs/auth/auth_bloc.dart';

class SimpleErrorWidget extends StatelessWidget {
  const SimpleErrorWidget({super.key, this.failure, required this.onRetry, this.textColor});

  final Failure? failure;
  final void Function() onRetry;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(kSpacing * 3).copyWith(top: 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            failure is UnAuthorizedFailure
                ? 'Votre session est expirée! Veuillez vous réconnecter!'
                : 'Une erreur est survenue! Veuillez réessayer plus tard!',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: textColor ?? Colors.white),
          ),
          SizedBox(height: kSpacing * 3),
          FilledButton(
            onPressed: () {
              if (failure is UnAuthorizedFailure) {
                context.read<AuthBloc>().add(OnUserSignedOut());
                context.push('/signin');
              } else {
                onRetry();
              }
            },
            child: Text(
              failure is UnAuthorizedFailure ? 'Se reconnecter' : 'Réessayer',
            ),
          )
        ],
      ),
    );
  }
}
