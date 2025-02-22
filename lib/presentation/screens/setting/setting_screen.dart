import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:ozapay/core/constants.dart';
import 'package:ozapay/presentation/blocs/auth/auth_bloc.dart';
import 'package:ozapay/presentation/blocs/user/user_bloc.dart';
import 'package:ozapay/presentation/screens/setting/about_screen.dart';
import 'package:ozapay/presentation/screens/setting/account_security/account_security_screen.dart';
import 'package:ozapay/presentation/screens/setting/challenge_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widgets/drawer/custom_dashed_line_painter.dart';
import '../../widgets/drawer/setting_screen_scaffold.dart';
import '../../widgets/drawer/user_info.dart';
import 'identity_verification_screen.dart';
import 'personal_info/personal_info_screen.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  static const route = '/setting';

  @override
  Widget build(BuildContext context) {
    return SettingScreenScaffold(
      appBarTitle: 'Menu',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(kSpacing * 3),
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthUserDisconnectedState) {
              context.pushReplacement("/");
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              BlocBuilder<UserBloc, UserState>(
                builder: (context, state) {
                  if (state.user != null) {
                    return UserInfo(user: state.user!);
                  }
                  return SizedBox.shrink();
                },
              ),
              Divider(height: kSpacing * 6),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Paramètres du compte',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(height: kSpacing * 2),
              SettingItemWidget(
                iconName: 'user_blue',
                title: 'infoPerso',
                onTap: () {
                  context.push(PersonalInfoScreen.route);
                },
              ),
              SettingItemWidget(
                iconName: 'invite_relation',
                title: 'relation',
                onTap: () {
                  context.push(ChallengeScreen.route);
                },
              ),
              SettingItemWidget(
                iconName: 'identity_verification',
                title: 'identity',
                onTap: () {
                  context.push(IdentityVerificationScreen.route);
                },
              ),
              SettingItemWidget(
                iconName: 'security',
                title: 'accountSecurity',
                onTap: () {
                  context.push(AccountSecurityScreen.route);
                },
              ),
              SettingItemWidget(
                iconName: 'info',
                title: 'about',
                onTap: () {
                  context.push(AboutScreen.route);
                },
              ),
              SettingItemWidget(
                iconName: 'logout',
                title: 'logOut',
                onTap: () {
                  context.read<AuthBloc>().add(OnUserSignedOut());
                },
              ),
              SizedBox(height: kSpacing * 4),
              Text(
                'Nos Réseaux Sociaux',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: kSpacing),
              CustomPaint(
                painter: CustomDashedLinePainter(
                  dashWidth: 3,
                  dashSpace: 2,
                  isOnTop: true,
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: kSpacing * 1.5),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      socialIcon(
                        'linkedin',
                        link: 'www.linkedin.com/company/ozapay',
                      ),
                      socialIcon(
                        'twitter',
                        link: 'x.com/OzaPay_official',
                      ),
                      socialIcon(
                        'facebook',
                        link: 'www.facebook.com/ozapayofficial/',
                      ),
                      socialIcon(
                        'youtube',
                        link: 'www.youtube.com/@Ozapay',
                      ),
                      socialIcon(
                        'instagram',
                        link: 'www.instagram.com/ozapay',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget socialIcon(String svg, {String? link}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6),
      child: InkWell(
        onTap: () {
          if (link != null) {
            launchUrl(
              Uri.https(link.split('/').first, link.split('.com').last),
            );
          }
        },
        child: SvgPicture.asset(
          'assets/icons/setting/$svg.svg',
          width: 42,
          height: 42,
        ),
      ),
    );
  }
}

class SettingItemWidget extends StatelessWidget {
  const SettingItemWidget({
    super.key,
    required this.iconName,
    required this.title,
    this.onTap,
  });

  final String iconName;
  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CustomDashedLinePainter(
        isOnTop: false,
        leftPadding: kSpacing,
        rightPadding: kSpacing,
        dashWidth: 3,
        dashSpace: 2,
      ),
      child: ListTile(
        onTap: onTap,
        leading: SvgPicture.asset('assets/icons/setting/$iconName.svg'),
        title: Text(
          'drawer.setting.menus.$title',
          style: const TextStyle(fontSize: 15),
        ).tr(),
      ),
    );
  }
}
