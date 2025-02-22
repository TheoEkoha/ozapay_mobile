import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ozapay/core/extension.dart';
import 'package:ozapay/data/enums/enum.dart';
import 'package:ozapay/presentation/blocs/bloc_status.dart';
import 'package:ozapay/presentation/blocs/user/user_bloc.dart';
import 'package:ozapay/presentation/screens/setting/personal_info/personal_info_controller.dart';
import 'package:ozapay/presentation/widgets/widget.dart';

class PersonalInfoForm extends StatefulWidget {
  const PersonalInfoForm({
    super.key,
  });

  @override
  State<PersonalInfoForm> createState() => _PersonalInfoFormState();
}

class _PersonalInfoFormState extends State<PersonalInfoForm> {
  late final PersonalInfoController controller;

  @override
  void initState() {
    controller = PersonalInfoController(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {
        if (state.status is LoadedStatus) {
          context.showSnackBar(
            'Vos informations ont été mises à jour avec succès!',
          );
        }
        if (state.status is ErrorStatus) {
          context.showSnackBar(
            'Une erreur est survenue! Veuillez réessayer plus tard!',
            error: true,
          );
        }
      },
      buildWhen: (previous, current) => previous.user != current.user,
      builder: (context, state) {
        return state.user?.accountRole == AccountRoleEnum.particular
            ? IndividualAccountForm(
                controller: controller,
                user: state.user!,
              )
            : ProfessionalAccountForm(
                controller: controller,
                user: state.user!,
              );
      },
    );
  }
}
