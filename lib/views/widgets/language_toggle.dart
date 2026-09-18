import 'package:flutter/material.dart';
import 'package:my_school_teacher/core/extensions/context_x.dart';
import 'package:my_school_teacher/controllers/locale_controller.dart';
import 'package:provider/provider.dart';

/// Compact language dropdown that matches the page surface background.
class LanguageToggle extends StatelessWidget {
  const LanguageToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleController>(
      builder: (context, localeController, _) {
        final locale = localeController.state;
        final code = LocaleController.supportedLanguageCodes.contains(
              locale.languageCode,
            )
            ? locale.languageCode
            : 'en';
        final colors = context.colors;

        return SizedBox(
          key: const Key('language_dropdown'),
          width: 168,
          child: InputDecorator(
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: colors.surface,
              contentPadding: const EdgeInsetsDirectional.only(
                start: 4,
                end: 8,
                top: 4,
                bottom: 4,
              ),
              prefixIcon: Icon(
                Icons.translate_rounded,
                size: 20,
                color: colors.primary,
              ),
              prefixIconConstraints: const BoxConstraints(
                minWidth: 40,
                minHeight: 40,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: colors.outlineVariant),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: colors.outlineVariant),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: colors.primary, width: 1.5),
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: code,
                isExpanded: true,
                isDense: true,
                borderRadius: BorderRadius.circular(14),
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: colors.onSurfaceVariant,
                ),
                style: context.textStyles.bodyLarge?.copyWith(
                  color: colors.onSurface,
                ),
                dropdownColor: colors.surface,
                items: [
                  DropdownMenuItem(
                    value: 'en',
                    child: Text(
                      context.l10n.english,
                      key: const Key('language_en'),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'fr',
                    child: Text(
                      context.l10n.french,
                      key: const Key('language_fr'),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'ar',
                    child: Text(
                      context.l10n.arabic,
                      key: const Key('language_ar'),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
                onChanged: (value) {
                  if (value == null || value == code) {
                    return;
                  }
                  localeController.setLocale(Locale(value));
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
