import 'package:flutter/material.dart';
import 'package:my_school_teacher/core/extensions/context_x.dart';

class AppSelectOption<T> {
  const AppSelectOption({required this.value, required this.label});

  final T value;
  final String label;
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
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: enabled && options.isNotEmpty ? () => _open(context) : null,
      child: InputDecorator(
        isEmpty: display.isEmpty,
        decoration: InputDecoration(
          labelText: label,
          enabled: enabled,
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
          style: context.textStyles.bodyLarge?.copyWith(
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
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      final option = options[index];
                      final isSelected = option.value == value;
                      return ListTile(
                        minVerticalPadding: 12,
                        title: Text(option.label),
                        trailing: Icon(
                          isSelected
                              ? Icons.check_circle_rounded
                              : Icons.circle_outlined,
                          color: isSelected
                              ? context.colors.primary
                              : context.colors.outline,
                        ),
                        onTap: () =>
                            Navigator.pop(sheetContext, _Picked(option.value)),
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
