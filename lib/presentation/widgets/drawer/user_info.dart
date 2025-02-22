import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ozapay/core/constants.dart';
import 'package:ozapay/domain/entities/auth/user_entity.dart';

class UserInfo extends StatelessWidget {
  const UserInfo(
      {super.key, this.textColor, this.showOffer = true, required this.user});

  final Color? textColor;
  final bool showOffer;
  final UserEntity user;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Row(
            children: [
              const CircleAvatar(radius: kSpacing * 3),
              const SizedBox(width: kSpacing * 2),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.displayName,
                      style: TextStyle(
                        color: textColor,
                      ),
                    ),
                    Text(
                      user.email ?? "@username",
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall
                          ?.copyWith(color: textColor?.withOpacity(.9)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (showOffer)
          Padding(
            padding: EdgeInsets.only(left: kSpacing),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Liberty',
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w700,
                    fontSize: kSpacing,
                  ),
                ),
                SvgPicture.asset('assets/icons/semi_ellipse.svg'),
              ],
            ),
          )
      ],
    );
  }
}
