import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ozapay/core/constants.dart';
import 'package:ozapay/theme.dart';

class TokenTile extends StatelessWidget {
  final String image, name, balance;
  final String? currency;
  final VoidCallback? onTap;

  const TokenTile({
    super.key,
    required this.image,
    required this.name,
    required this.balance,
    this.currency,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tokenImage = image.isNotEmpty && !image.startsWith(r'assets')
        ? image.endsWith('.svg')
            ? SvgPicture.network(image)
            : CachedNetworkImage(imageUrl: image)
        : Image.asset(image);

    return ListTile(
      onTap: onTap,
      minTileHeight: 30,
      contentPadding: EdgeInsets.zero,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: SizedBox(
          width: 35,
          height: 35,
          child: tokenImage,
        ),
      ),
      horizontalTitleGap: kSpacing,
      titleTextStyle: TextStyle(
        fontFamily: bodyFont,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
      subtitleTextStyle: TextStyle(
        fontSize: 12,
        fontFamily: 'Quicksand',
        color: Color(0xFF868686),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name),
          if (currency != null) Text(currency!),
        ],
      ),
      subtitle: Text(balance),
    );
  }
}
