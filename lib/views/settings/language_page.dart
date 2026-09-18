import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_school_teacher/core/extensions/context_x.dart';
import 'package:my_school_teacher/controllers/locale_controller.dart';
import 'package:my_school_teacher/views/widgets/brand_app_bar.dart';
import 'package:my_school_teacher/views/widgets/section_card.dart';

class LanguagePage extends StatelessWidget {
  const LanguagePage({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleController>().state;
    return Scaffold(
      appBar: BrandAppBar(title: context.l10n.language),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          SectionCard(
            padding: EdgeInsets.zero,
            child: RadioGroup<String>(
              groupValue: locale.languageCode,
              onChanged: (value) {
                if (value != null) {
                  context.read<LocaleController>().setLocale(Locale(value));
                }
              },
              child: Column(
                children: [
                  RadioListTile(
                    value: 'en',
                    title: Text(context.l10n.english),
                    secondary: const Text('EN'),
                  ),
                  const Divider(),
                  RadioListTile(
                    value: 'fr',
                    title: Text(context.l10n.french),
                    secondary: const Text('FR'),
                  ),
                  const Divider(),
                  RadioListTile(
                    value: 'ar',
                    title: Text(context.l10n.arabic),
                    secondary: const Text('AR'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
