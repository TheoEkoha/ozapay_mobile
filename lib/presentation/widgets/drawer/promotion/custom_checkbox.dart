import 'package:flutter/material.dart';
import 'package:ozapay/core/constants.dart';
import 'package:ozapay/theme.dart';

class CustomCheckbox extends StatefulWidget {
  const CustomCheckbox(
      {super.key, required this.value, this.onChanged, this.child});

  final bool value;
  final void Function(bool?)? onChanged;
  final Widget? child;

  @override
  State<CustomCheckbox> createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  late bool _value;

  @override
  void initState() {
    _value = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(
            vertical: kSpacing,
            horizontal: kSpacing * 2,
          ).copyWith(left: 0),
          width: 20,
          height: 20,
          child: Stack(
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: 200),
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: _value ? Theme.of(context).colorScheme.primary : Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: _value
                    ? UnconstrainedBox(
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: secondaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      )
                    : null,
              ),
              Opacity(
                opacity: 0,
                child: Checkbox(
                  value: _value,
                  onChanged: (val) {
                    setState(() {
                      _value = val!;
                    });
                    if (widget.onChanged != null) widget.onChanged!(val);
                  },
                ),
              ),
            ],
          ),
        ),
        if (widget.child != null)
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _value = !_value;
                });
                if (widget.onChanged != null) widget.onChanged!(_value);
              },
              child: widget.child!,
            ),
          )
      ],
    );
  }
}
