import 'package:flutter/material.dart';

import '../data/batch_data.dart';
import '../theme/app_theme.dart';

/// In-app terms of use for the JNVK app (Tech Sparrow).
class TermsOfUseScreen extends StatelessWidget {
  const TermsOfUseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final body = Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.55);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms of Use'),
        flexibleSpace: Container(decoration: BoxDecoration(gradient: appBarGradient)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          BatchData.batchIdentityShort,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tech Sparrow — Terms of Use',
                          style: body?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'These Terms of Use ("Terms") govern your use of the JNVK mobile application ("the app") '
                  'published by Tech Sparrow ("we", "us"). By downloading or using the app, you agree to these Terms.',
                  style: body,
                ),
                const SizedBox(height: 20),
                const _Heading('Use of the app'),
                Text(
                  'The app provides information about the JNV Kaimur Batch 2k10 + LE cohort, including house '
                  'rosters, photos bundled in the app, and links to social profiles where provided. You agree to '
                  'use the app only for lawful, personal, non-commercial purposes and not to misuse it or '
                  'attempt to disrupt its operation.',
                  style: body,
                ),
                const SizedBox(height: 20),
                const _Heading('Content and links'),
                Text(
                  'Content in the app is provided as-is for alumni and community reference. Opening external '
                  'links (for example social networks) is subject to those services\' own terms and privacy '
                  'practices. We are not responsible for third-party sites or services.',
                  style: body,
                ),
                const SizedBox(height: 20),
                const _Heading('Intellectual property'),
                Text(
                  'The app design, layout, and Tech Sparrow branding belong to Tech Sparrow or its licensors. '
                  'The Navodaya anthem audio included for listening in the app is used for cultural and '
                  'non-commercial community purposes; all rights in the underlying work remain with their '
                  'respective owners.',
                  style: body,
                ),
                const SizedBox(height: 20),
                const _Heading('Disclaimer'),
                Text(
                  'The app is provided "as is" without warranties of any kind. We do not guarantee uninterrupted '
                  'or error-free operation. To the fullest extent permitted by law, Tech Sparrow is not liable '
                  'for any indirect or consequential damages arising from your use of the app.',
                  style: body,
                ),
                const SizedBox(height: 20),
                const _Heading('Changes'),
                Text(
                  'We may update these Terms from time to time. Continued use of the app after changes constitutes '
                  'acceptance of the updated Terms.',
                  style: body,
                ),
                const SizedBox(height: 20),
                const _Heading('Contact'),
                Text(
                  'Tech Sparrow\n'
                  'Mobile: +91 6386436878\n'
                  'Email: sharmark9931@gmail.com',
                  style: body,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Heading extends StatelessWidget {
  const _Heading(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.teal,
            ),
      ),
    );
  }
}
