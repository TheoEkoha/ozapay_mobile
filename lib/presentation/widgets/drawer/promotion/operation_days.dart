import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:ozapay/theme.dart';

final operationDays = [
  OperationDay(
    name: 'Lundi',
    morning: HourRange(start: 10, end: 12),
    afternoon: HourRange(start: 14, end: 18),
  ),
  OperationDay(
    name: 'Mardi',
    morning: HourRange(start: 10, end: 12),
    afternoon: HourRange(start: 14, end: 18),
  ),
  OperationDay(
    name: 'Mercredi',
    morning: HourRange(start: 10, end: 12),
    afternoon: HourRange(start: 14, end: 18),
  ),
  OperationDay(
    name: 'Jeudi',
    morning: HourRange(start: 10, end: 12),
    afternoon: HourRange(start: 14, end: 18),
  ),
  OperationDay(
    name: 'Vendredi',
    morning: HourRange(start: 10, end: 12),
    afternoon: HourRange(start: 14, end: 18),
  ),
  OperationDay(
    name: 'Samedi',
    morning: HourRange(start: 10, end: 12),
    afternoon: HourRange(start: 14, end: 18),
  ),
  OperationDay(
    name: 'Dimanche',
    morning: HourRange(start: 10, end: 12),
    afternoon: HourRange(start: 14, end: 18),
  ),
];

class HourRange extends Equatable {
  final int? start;
  final int? end;
  const HourRange({
    this.start,
    this.end,
  });

  @override
  List<Object?> get props => [start, end];
}

class OperationDay extends Equatable {
  final String? name;
  final HourRange? morning;
  final HourRange? afternoon;
  const OperationDay({
    this.name,
    this.morning,
    this.afternoon,
  });

  @override
  List<Object?> get props => [name, morning, afternoon];
}

class OperationDays extends StatelessWidget {
  const OperationDays({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Horaires d’ouverture ',
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        // SizedBox(height: kSpacing * 2),
        Theme(
          data: ThemeData(
            checkboxTheme: CheckboxThemeData(
              fillColor: WidgetStateProperty.all(secondaryColor),
              shape: CircleBorder(),
              side: BorderSide.none,
              checkColor: WidgetStateProperty.all(Theme.of(context).colorScheme.primary),
            ),
          ),
          child: FormBuilderCheckboxGroup(
            name: 'hours',
            wrapDirection: Axis.vertical,
            decoration: InputDecoration(
              filled: false,
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
            ),
            options: List.generate(
              operationDays.length,
              (index) {
                final day = operationDays[index];
                return FormBuilderFieldOption(
                  value: day.name,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${day.name}'),
                      Text.rich(
                        TextSpan(
                          text: 'de ',
                          style: Theme.of(context).textTheme.bodySmall,
                          children: [
                            TextSpan(
                              text: '${day.morning?.start}h ',
                              style: TextStyle(color: lightGreyColor),
                            ),
                            TextSpan(text: 'à '),
                            TextSpan(
                              text: '${day.morning?.end}h ',
                              style: TextStyle(color: lightGreyColor),
                            ),
                            TextSpan(text: ' et de '),
                            TextSpan(
                              text: ' ${day.afternoon?.start}h ',
                              style: TextStyle(color: lightGreyColor),
                            ),
                            TextSpan(text: 'à '),
                            TextSpan(
                              text: '${day.afternoon?.end}h ',
                              style: TextStyle(color: lightGreyColor),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        )
      ],
    );
  }
}
