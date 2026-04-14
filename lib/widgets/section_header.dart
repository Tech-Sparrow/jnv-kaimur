import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.description,
    this.descriptionWidget,
  });

  final String title;
  final String? description;
  final Widget? descriptionWidget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        children: [
          Text(title, textAlign: TextAlign.center, style: appHeadingStyle(context, fontSize: 32)),
          const SizedBox(height: 12),
          Container(
            width: 120,
            height: 3,
            decoration: BoxDecoration(
              gradient: appBarGradient,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          if (description != null || descriptionWidget != null) ...[
            const SizedBox(height: 16),
            if (descriptionWidget != null)
              descriptionWidget!
            else
              Text(
                description!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
              ),
          ],
        ],
      ),
    );
  }
}
