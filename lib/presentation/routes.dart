import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ozapay/data/enums/enum.dart';

import 'screens/auth/signin/signin_screen.dart';
import 'screens/auth/signin/signin_with_phone.dart';
import 'screens/auth/signup/signup_screen.dart';
import 'screens/auth/signup/single_stepper.dart';
import 'screens/auth/signup/steppers/code_info.dart';
import 'screens/auth/signup/steppers/email_info.dart';
import 'screens/auth/signup/steppers/phone_info.dart';
import 'screens/auth/signup/steppers/signup_choice.dart';
import 'screens/auth/signup/steppers/user_info.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/offer/update_offer_screen.dart';
import 'screens/promotion/create/create_promotion_screen.dart';
import 'screens/promotion/created_promotion_screen.dart';
import 'screens/promotion/list_offer_promotion.dart';
import 'screens/promotion/promotional_space_screen.dart';
import 'screens/setting/about_screen.dart';
import 'screens/setting/account_security/account_security_screen.dart';
import 'screens/setting/challenge_screen.dart';
import 'screens/setting/gains_and_cashback_screen.dart';
import 'screens/setting/identity_verification_screen.dart';
import 'screens/setting/personal_info/personal_info_screen.dart';
import 'screens/setting/setting_screen.dart';
import 'screens/wallet/create/create_wallet_screen.dart';
import 'screens/wallet/create/generate_mnemonic_screen.dart';
import 'screens/wallet/create/verify_mnemonic_screen.dart';
import 'screens/wallet/import/import_wallet_screen.dart';
import 'screens/wallet/payment/recap_screen.dart';
import 'screens/wallet/payment/scan_qr_code_screen.dart';
import 'screens/wallet/payment/select_token_list_screen.dart';
import 'screens/wallet/payment/swap_screen.dart';
import 'screens/wallet/receive/qr_code_screen.dart';
import 'screens/wallet/transaction/all_transaction_screen.dart';
import 'screens/wallet/wallet_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  initialLocation: '/',
  navigatorKey: _rootNavigatorKey,
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        return DashboardScreen();
      },
      routes: [
        /// Sign in
        GoRoute(
          path: 'signin',
          builder: (context, state) {
            return SigninScreen();
          },
          routes: [
            GoRoute(
              path: 'with-phone',
              builder: (context, state) {
                return SigninWithPhone();
              },
            ),
            GoRoute(
              path: 'verify-code',
              builder: (context, state) => SingleStepper(
                customBuilder: true,
                step: SignupStepperEnum.smsCode,
                onPop: () {
                  context.pop();
                },
                child: CodeInfo(
                  input: (state.extra as Map)['input'] as String?,
                  service: (state.extra as Map)['service'],
                  type: (state.extra as Map)['type'],
                ),
              ),
            ),
          ],
        ),

        /// Sign up
        GoRoute(
          path: 'signup',
          builder: (context, state) => SignupScreen(),
          routes: [
            GoRoute(
              path: 'create',
              builder: (context, state) => SingleStepper(
                step: SignupStepperEnum.choice,
                customBuilder: true,
                child: SignupChoice(),
              ),
            ),
            GoRoute(
              path: 'info',
              builder: (context, state) => SingleStepper(
                step: SignupStepperEnum.info,
                child: UserInfo(),
              ),
            ),
            GoRoute(
              path: 'phone',
              builder: (context, state) {
                final extra = state.extra as Map;

                return SingleStepper(
                  step: SignupStepperEnum.phone,
                  loading: extra['loading'] as bool?,
                  onValidate: extra['onValidate'] as VoidCallback?,
                  onPop: extra['onPop'] as VoidCallback?,
                  child: PhoneInfo(),
                );
              },
            ),
            GoRoute(
              path: 'sms-code',
              builder: (context, state) => SingleStepper(
                customBuilder: true,
                step: SignupStepperEnum.smsCode,
                child: CodeInfo(
                  input: (state.extra as Map)['input'] as String?,
                  service: (state.extra as Map)['service'],
                  type: (state.extra as Map)['type'],
                ),
              ),
            ),
            GoRoute(
              path: 'email',
              builder: (context, state) => SingleStepper(
                step: SignupStepperEnum.email,
                child: EmailInfo(),
              ),
            ),
            GoRoute(
              path: 'email-code',
              builder: (context, state) => SingleStepper(
                customBuilder: true,
                step: SignupStepperEnum.emailCode,
                child: CodeInfo(
                  input: (state.extra as Map)['input'] as String?,
                  service: (state.extra as Map)['service'],
                  type: (state.extra as Map)['type'],
                ),
              ),
            ),
          ],
        ),

        /// My Wallet
        GoRoute(
          path: WalletScreen.route,
          builder: (context, state) => WalletScreen(),
        ),

        /// Create/Import Wallet
        GoRoute(
          path: ImportWalletScreen.route,
          builder: (context, state) => ImportWalletScreen(),
        ),
        GoRoute(
          path: CreateWalletScreen.route,
          builder: (context, state) {
            return CreateWalletScreen();
          },
        ),
        GoRoute(
          path: GenerateMnemonicScreen.route,
          builder: (context, state) {
            return GenerateMnemonicScreen();
          },
        ),
        GoRoute(
          path: VerifyMnemonicScreen.route,
          builder: (context, state) {
            return VerifyMnemonicScreen();
          },
        ),

        // Transaction
        GoRoute(
          path: QrCodeScreen.route,
          builder: (context, state) {
            return QrCodeScreen();
          },
        ),

        GoRoute(
          path: ScanQrCodeScreen.route,
          builder: (context, state) {
            return ScanQrCodeScreen();
          },
        ),
        GoRoute(
          path: SelectTokenListScreen.route,
          builder: (context, state) {
            return SelectTokenListScreen(
                recipientAddress: state.extra as String);
          },
        ),
        GoRoute(
          path: RecapScreen.route,
          builder: (context, state) {
            return RecapScreen(
              recipientAddress: (state.extra as Map)["recipientAddress"],
              token: (state.extra as Map)["token"],
            );
          },
        ),
        GoRoute(
          path: SwapScreen.route,
          builder: (context, state) {
            return SwapScreen();
          },
        ),
        GoRoute(
          path: AllTransactionScreen.route,
          builder: (context, state) => AllTransactionScreen(),
        ),

        // Settings
        GoRoute(
          path: 'setting',
          builder: (context, state) {
            return SettingScreen();
          },
          routes: [
            GoRoute(
              path: 'personal-info',
              builder: (context, state) {
                return PersonalInfoScreen();
              },
            ),
            GoRoute(
              path: 'challenge',
              builder: (context, state) {
                return ChallengeScreen();
              },
            ),
            GoRoute(
              path: 'identity-verification',
              builder: (context, state) {
                return IdentityVerificationScreen();
              },
            ),
            GoRoute(
              path: 'account-security',
              builder: (context, state) {
                return AccountSecurityScreen();
              },
            ),
            GoRoute(
              path: 'about',
              builder: (context, state) {
                return AboutScreen();
              },
            ),
          ],
        ),

        // Cashback
        GoRoute(
          path: GainsAndCashbackScreen.route,
          builder: (context, state) {
            return GainsAndCashbackScreen();
          },
        ),

        // Offer
        GoRoute(
          path: 'update-offer',
          builder: (context, state) {
            return UpdateOfferScreen();
          },
        ),

        // Promotion
        GoRoute(
          path: 'promotion',
          builder: (context, state) {
            return PromotionalSpaceScreen();
          },
          routes: [
            GoRoute(
              path: 'list-offer',
              builder: (context, state) {
                return ListOfferPromotion();
              },
            ),
            GoRoute(
              path: 'create',
              builder: (context, state) {
                return CreatePromotionScreen(
                  thematic: (state.extra as Map)['thematic'] as OfferThematic,
                );
              },
            ),
            GoRoute(
              path: 'created',
              builder: (context, state) {
                return CreatedPromotionScreen();
              },
            ),
          ],
        ),
      ],
    ),
  ],
);