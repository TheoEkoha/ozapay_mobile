import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ozapay/data/enums/enum.dart';

import '../../controllers/signup_controller.dart';
import 'personal_info.dart';
import 'professional_info.dart';

class UserInfo extends StatelessWidget {
  const UserInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final role = context.watch<SignupProvider>().role;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          role == AccountRoleEnum.particular
              ? const PersonalInfo()
              : const ProfessionalInfo(),
        ],
      ),
    );
  }
}
