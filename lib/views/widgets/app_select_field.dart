import 'package:flutter/material.dart';
import 'package:my_school_teacher/core/extensions/context_x.dart';

class AppSelectOption<T> {
  const AppSelectOption({
    required this.value,
    required this.label,
    this.enabled = true,
    this.subtitle,
  });

  final T value;
  final String label;
  final bool enabled;
  final String? subtitle;
}

class AppSelectField<T> extends StatelessWidget {
  const AppSelectField({
    super.key,
    required this.label,
    required this.options,
    required this.onChanged,
    this.value,
    this.enabled = true,
  });

  final String label;
  final List<AppSelectOption<T>> options;
  final T? value;
  final bool enabled;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    final selected = options.where((item) => item.value == value);
    final display = selected.isEmpty ? '' : selected.first.label;
    final selectable = options.where((item) => item.enabled);
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: enabled && selectable.isNotEmpty ? () => _open(context) : null,
      child: InputDecorator(
        isEmpty: display.isEmpty,
        decoration: InputDecoration(
          labelText: label,
          enabled: enabled,
          isDense: true,
          contentPadding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
          suffixIcon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: enabled
                ? context.colors.onSurfaceVariant
                : context.colors.outline,
          ),
        ),
        child: Text(
          display.isEmpty ? ' ' : display,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.textStyles.bodyMedium?.copyWith(
            color: enabled
                ? context.colors.onSurface
                : context.colors.onSurface.withValues(alpha: 0.38),
          ),
        ),
      ),
    );
  }

  Future<void> _open(BuildContext context) async {
    final picked = await showModalBottomSheet<_Picked<T>>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(sheetContext).height * 0.55,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
                  child: Text(label, style: sheetContext.textStyles.titleMedium),
                ),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(bottom: 12),
                    itemCount: options.length,
                    separatorBuilder: (_, _) => const Divider(),
                    itemBuilder: (context, index) {
                      final option = options[index];
                      final isSelected = option.value == value;
                      final optionEnabled = option.enabled;
                      final muted = context.colors.onSurface.withValues(
                        alpha: 0.38,
                      );
                      return ListTile(
                        enabled: optionEnabled,
                        minVerticalPadding: 12,
                        title: Text(
                          option.label,
                          style: TextStyle(
                            color: optionEnabled ? null : muted,
                          ),
                        ),
                        subtitle: option.subtitle == null
                            ? null
                            : Text(
                                option.subtitle!,
                                style: context.textStyles.bodySmall?.copyWith(
                                  color: muted,
                                ),
                              ),
                        trailing: Icon(
                          !optionEnabled
                              ? Icons.lock_outline_rounded
                              : isSelected
                              ? Icons.check_circle_rounded
                              : Icons.circle_outlined,
                          color: !optionEnabled
                              ? muted
                              : isSelected
                              ? context.colors.primary
                              : context.colors.outline,
                        ),
                        onTap: optionEnabled
                            ? () => Navigator.pop(
                                sheetContext,
                                _Picked(option.value),
                              )
                            : null,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    if (picked != null) {
      onChanged(picked.value);
    }
  }
}

class _Picked<T> {
  const _Picked(this.value);

  final T value;
}
