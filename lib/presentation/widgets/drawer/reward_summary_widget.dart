import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ozapay/core/constants.dart';
import 'package:ozapay/domain/entities/sales_reward_entity.dart';
import 'package:ozapay/presentation/widgets/drawer/custom_dashed_line_painter.dart';
import 'package:ozapay/theme.dart';

class RewardSummaryWidget extends StatelessWidget {
  const RewardSummaryWidget(
      {super.key, required this.reward, this.isLastItem = false});

  final SalesRewardEntity reward;
  final bool isLastItem;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kSpacing * 3),
      child: isLastItem
          ? body(reward, context)
          : CustomPaint(
              painter: CustomDashedLinePainter(),
              child: body(reward, context),
            ),
    );
  }

  Widget body(SalesRewardEntity reward, BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: reward.type?.color ?? Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(kSpacing * 4),
          ),
          height: kSpacing * 5,
          width: kSpacing * 5,
          padding: const EdgeInsets.all(kSpacing),
          child: SvgPicture.asset('assets/icons/${reward.type?.iconName}.svg'),
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.only(left: kSpacing),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${reward.type?.title} reçu'),
                Text(
                  'De “${reward.from}”, le 27/08/2024',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 10,
                        color: greyDarker,
                      ),
                ),
              ],
            ),
          ),
        ),
        Row(
          children: [
            const Icon(
              Icons.add,
              color: greenColor,
              size: kSpacing * 2,
            ),
            const SizedBox(width: kSpacing / 4),
            Text('${reward.amount?.toInt()} EUR')
          ],
        )
      ],
    );
  }
}
