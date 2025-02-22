import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/src/models/country_model.dart';
import 'package:intl_phone_number_input/src/utils/test/test_helper.dart';
import 'package:intl_phone_number_input/src/utils/util.dart';

/// Creates a list of Countries with a search textfield.
class CountrySearchListWidget extends StatefulWidget {
  final List<Country> countries;
  final InputDecoration? searchBoxDecoration;
  final String? locale;
  final ScrollController? scrollController;
  final bool autoFocus;
  final bool? showFlags;
  final bool? useEmoji;
  final bool showDialCode;
  final TextStyle? textStyle;
  final Widget? title;
  final Country? country;

  const CountrySearchListWidget(
    this.countries,
    this.locale, {
    super.key,
    this.searchBoxDecoration,
    this.scrollController,
    this.showFlags,
    this.useEmoji,
    this.autoFocus = false,
    this.showDialCode = true,
    this.textStyle,
    this.title,
    this.country,
  });

  @override
  State<CountrySearchListWidget> createState() =>
      _CountrySearchListWidgetState();
}

class _CountrySearchListWidgetState extends State<CountrySearchListWidget> {
  late final TextEditingController _searchController = TextEditingController();
  late List<Country> filteredCountries;
  bool searchIsShown = false;

  @override
  void initState() {
    final String value = _searchController.text.trim();
    filteredCountries = Utils.filterCountries(
      countries: widget.countries,
      locale: widget.locale,
      value: value,
    );
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Returns [InputDecoration] of the search box
  InputDecoration getSearchBoxDecoration() {
    return widget.searchBoxDecoration ??
        const InputDecoration(labelText: 'Search by country name or dial code');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
              if (widget.title != null) Expanded(child: widget.title!),
              Opacity(
                opacity: !searchIsShown ? 1.0 : 0.0,
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      searchIsShown = !searchIsShown;
                    });
                  },
                  icon: const Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (searchIsShown)
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextFormField(
              key: const Key(TestHelper.CountrySearchInputKeyValue),
              decoration: getSearchBoxDecoration(),
              controller: _searchController,
              autofocus: widget.autoFocus,
              onChanged: (value) {
                final String value = _searchController.text.trim();
                return setState(
                  () => filteredCountries = Utils.filterCountries(
                    countries: widget.countries,
                    locale: widget.locale,
                    value: value,
                  ),
                );
              },
            ),
          ),
        Flexible(
          child: ListView.separated(
            controller: widget.scrollController,
            shrinkWrap: true,
            itemCount: filteredCountries.length,
            separatorBuilder: (context, index) => const Divider(
              indent: 16,
              endIndent: 16,
              height: .5,
              color: Color(0xFFF0F1F5),
            ),
            itemBuilder: (BuildContext context, int index) {
              Country country = filteredCountries[index];

              return DirectionalCountryListTile(
                country: country,
                locale: widget.locale,
                showFlags: widget.showFlags!,
                useEmoji: widget.useEmoji!,
                showDialCode: widget.showDialCode,
                textStyle: widget.textStyle,
                trailing: widget.country == country
                    ? Icon(
                        Icons.check,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    : null,
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
}

class DirectionalCountryListTile extends StatelessWidget {
  final Country country;
  final String? locale;
  final bool showFlags;
  final bool useEmoji;
  final bool showDialCode;
  final TextStyle? textStyle;
  final Widget? trailing;

  const DirectionalCountryListTile({
    super.key,
    required this.country,
    required this.locale,
    required this.showFlags,
    required this.useEmoji,
    this.showDialCode = true,
    this.textStyle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: Key(TestHelper.countryItemKeyValue(country.alpha2Code)),
      leading: (showFlags ? _Flag(country: country, useEmoji: useEmoji) : null),
      title: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Text(
          '${Utils.getCountryName(country, locale)}',
          textDirection: Directionality.of(context),
          textAlign: TextAlign.start,
          style: textStyle,
        ),
      ),
      subtitle: showDialCode
          ? Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                country.dialCode ?? '',
                textDirection: TextDirection.ltr,
                textAlign: TextAlign.start,
              ),
            )
          : null,
      onTap: () => Navigator.of(context).pop(country),
      trailing: trailing,
    );
  }
}

class _Flag extends StatelessWidget {
  final Country? country;
  final bool? useEmoji;

  const _Flag({this.country, this.useEmoji});

  @override
  Widget build(BuildContext context) {
    return country != null
        ? Container(
            child: useEmoji!
                ? Text(
                    Utils.generateFlagEmojiUnicode(country?.alpha2Code ?? ''),
                    style: Theme.of(context).textTheme.headlineSmall,
                  )
                : country?.flagUri != null
                    ? Image.asset(
                        country!.flagUri,
                        width: 24,
                        package: 'intl_phone_number_input',
                      )
                    : const SizedBox.shrink(),
          )
        : const SizedBox.shrink();
  }
}
