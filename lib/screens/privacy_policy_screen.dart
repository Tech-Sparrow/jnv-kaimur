import 'package:flutter/material.dart';

import '../data/batch_data.dart';
import '../theme/app_theme.dart';

/// In-app privacy policy (same content as the former GitHub Pages policy).
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final body = Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.55);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
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
                          'Tech Sparrow — JNVK App Privacy Policy',
                          style: body?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'This Privacy Policy explains how Tech Sparrow (“we” or “us”) collects, uses, and protects '
                  'information for users (“you”) of the JNVK app (“the app”). By using the app, you agree to '
                  'these terms.',
                  style: body,
                ),
                const SizedBox(height: 20),
                const _Heading('Information collection'),
                Text(
                  'The JNVK app does not collect personal information from you. The app is largely static: it '
                  'displays batch and house information for the 2010 cohort of JNV Kaimur. We do not collect, '
                  'store, or share user data through the app itself.',
                  style: body,
                ),
                const SizedBox(height: 20),
                const _Heading('Internet access'),
                Text(
                  'Opening social links (for example Facebook, Instagram, or WhatsApp) uses your device’s '
                  'browser or the respective app; that is outside this app’s own data collection.',
                  style: body,
                ),
                const SizedBox(height: 20),
                const _Heading('Data usage'),
                Text(
                  'Because we do not collect personal information in the app, there is no user data processed '
                  'by us through the app for analytics or profiling.',
                  style: body,
                ),
                const SizedBox(height: 20),
                const _Heading('Third-party services'),
                Text(
                  'The app does not embed third-party analytics or advertising SDKs. Links you tap are handled '
                  'by those services under their own policies.',
                  style: body,
                ),
                const SizedBox(height: 20),
                const _Heading('Children’s privacy'),
                Text(
                  'The app is suitable for general audiences and does not knowingly collect personal '
                  'information from children. Parents or guardians may supervise younger users when using '
                  'social links.',
                  style: body,
                ),
                const SizedBox(height: 20),
                const _Heading('Policy updates'),
                Text(
                  'We may update this policy from time to time. Continued use of the app after changes means '
                  'you accept the updated policy.',
                  style: body,
                ),
                const SizedBox(height: 20),
                const _Heading('Contact'),
                Text(
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
