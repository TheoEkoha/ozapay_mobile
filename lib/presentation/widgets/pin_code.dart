import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:ozapay/core/constants.dart';
import 'package:ozapay/presentation/widgets/widget.dart';

class PinCode extends StatefulWidget {
  const PinCode({
    super.key,
    required this.onEnter,
    this.pinLength = 4,
    required this.textStyle,
    required this.name,
  });

  final String name;

  /// Callback after all pins input
  final void Function(String pin) onEnter;

  final int pinLength;

  final TextStyle textStyle;

  @override
  State<StatefulWidget> createState() => _PinCodeState();
}

class _PinCodeState<T extends PinCode> extends State<T> {
  String pin = '';

  int get length => pin.length;

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<String>(
      name: widget.name,
      builder: (field) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text("CODE DE SÉCURITÉ"),
            const SizedBox(height: kSpacing * 4),
            SizedBox(
              height: 21,
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                primary: false,
                children: List.generate(
                  widget.pinLength,
                  (index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 21,
                      height: 21,
                      margin: const EdgeInsets.symmetric(horizontal: kSpacing),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: index < length
                            ? Theme.of(context).colorScheme.primary
                            : const Color(0xFFECECEC),
                      ),
                    );
                  },
                ),
              ),
            ),
            if (field.errorText != null) ...[
              const SizedBox(height: kSpacing * 2),
              Text(
                field.errorText!,
                style: const TextStyle(fontSize: 12, color: Colors.red),
              ),
            ],
            const SizedBox(height: kSpacing * 4),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisExtent: 84,
                crossAxisSpacing: kSpacing,
                mainAxisSpacing: kSpacing * 3,
              ),
              itemCount: 12,
              itemBuilder: (context, index) {
                switch (index) {
                  case 9:
                    return const SizedBox.shrink();

                  default:
                    return _buildButton(field.didChange, index);
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    if (oldWidget.name != widget.name) {
      setState(() {
        pin = '';
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  _buildButton(ValueChanged<String> onChanged, int index) {
    final value = index == 10 ? 0 : index + 1;
    final alignLeft = [0, 3, 6];
    final alignRight = [2, 5, 8, 11];

    return Align(
      alignment: alignLeft.contains(index)
          ? Alignment.centerRight
          : alignRight.contains(index)
              ? Alignment.centerLeft
              : Alignment.center,
      child: OutlinedButton(
        onPressed: index == 11 && pin.isEmpty
            ? null
            : () => onPressed(onChanged, index, value),
        style: OutlinedButton.styleFrom(
          backgroundColor: index == 11 ? null : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(84),
          ),
          fixedSize: const Size.square(80),
          side: BorderSide(
            color: index == 11 ? Colors.transparent : const Color(0xFFC9C9C9),
          ),
        ),
        child: index == 11
            ? Transform.translate(
                offset: const Offset(-4, 0),
                child: const Icon(
                  OzapayIcons.delete,
                  color: Colors.black,
                ),
              )
            : Center(
                child: Text(
                  '$value',
                  style: widget.textStyle,
                ),
              ),
      ),
    );
  }

  void onPressed(ValueChanged<String> onChanged, int index, int value) {
    HapticFeedback.heavyImpact();

    /// Clear button
    if (index == 11) {
      if (pin.isNotEmpty) {
        _clear(length - 1);
      }
    } else {
      setState(() => pin += '$value');

      if (length > widget.pinLength) {
        _clear(widget.pinLength);
      }

      if (length == widget.pinLength) {
        onChanged(pin);
        widget.onEnter(pin);
      }
    }
  }

  _clear(int length) {
    final tmp = pin.substring(0, length);
    setState(() => pin = tmp);
  }
}
