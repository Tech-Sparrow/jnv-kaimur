import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../data/batch_data.dart';
import '../data/boys_house_profiles.dart';
import '../data/models.dart';
import '../theme/app_theme.dart';
import '../utils/social_url_launcher.dart';

/// Per-house view: boys (photos + socials bundled in-app) and girls (name lists).
class HouseScreen extends StatefulWidget {
  const HouseScreen({super.key, required this.house});

  final House house;

  @override
  State<HouseScreen> createState() => _HouseScreenState();
}

class _HouseScreenState extends State<HouseScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _openUrl(String? url) async {
    if (url == null || url.isEmpty) return;
    final ok = await SocialUrlLauncher.open(url);
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open link')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final roster = BatchData.rosterFor(widget.house);
    if (roster == null) {
      return const Scaffold(body: Center(child: Text('Unknown house')));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.house.label} House'),
        flexibleSpace: Container(decoration: BoxDecoration(gradient: appBarGradient)),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelStyle: const TextStyle(fontWeight: FontWeight.w500),
          tabs: const [
            Tab(text: 'Boys'),
            Tab(text: 'Girls'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _BoysHouseDetailTab(
            house: widget.house,
            onOpenUrl: _openUrl,
          ),
          _CohortList(cohorts: roster.girlsByCohort),
        ],
      ),
    );
  }
}

class _BoysHouseDetailTab extends StatelessWidget {
  const _BoysHouseDetailTab({
    required this.house,
    required this.onOpenUrl,
  });

  final House house;
  final Future<void> Function(String? url) onOpenUrl;

  @override
  Widget build(BuildContext context) {
    final boys = BoysHouseProfiles.boysForHouse(house);
    if (boys.isEmpty) {
      return const Center(child: Text('No profile data for this house.'));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          color: sectionBackground(context),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline_rounded, color: AppColors.teal, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Photos and social links below are bundled in this app. Tap a social button to open that '
                      'service in your browser or app.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.45),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: boys.length,
            itemBuilder: (context, index) {
              final p = boys[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _BoyProfileCard(profile: p, onOpenUrl: onOpenUrl),
                  const SizedBox(height: 12),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class _BoyProfileCard extends StatelessWidget {
  const _BoyProfileCard({
    required this.profile,
    required this.onOpenUrl,
  });

  final BoyMemberProfile profile;
  final Future<void> Function(String? url) onOpenUrl;

  @override
  Widget build(BuildContext context) {
    final path = profile.photoAssetPath;
    final hasSocial = profile.facebookUrl != null ||
        profile.instagramUrl != null ||
        profile.whatsappUrl != null;
    final mutedFill = Theme.of(context).brightness == Brightness.dark
        ? Colors.white.withOpacity(0.06)
        : AppColors.sectionBg;

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shadowColor: AppColors.teal.withOpacity(0.22),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: AppColors.teal.withOpacity(0.22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  AppColors.green.withOpacity(0.28),
                  AppColors.teal.withOpacity(0.3),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  const Icon(Icons.schedule_outlined, size: 18, color: Color(0xFF2A6B6E)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      profile.cohortLabel,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.2,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    border: Border.all(color: AppColors.teal.withOpacity(0.5), width: 2),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      width: 108,
                      height: 132,
                      child: path != null
                          ? Image.asset(
                              path,
                              fit: BoxFit.cover,
                              gaplessPlayback: true,
                              filterQuality: FilterQuality.medium,
                              errorBuilder: (_, __, ___) => _photoPlaceholder(),
                            )
                          : _photoPlaceholder(),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile.name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              height: 1.25,
                            ),
                      ),
                      if (profile.subtitle != null && profile.subtitle!.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          profile.subtitle!,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontStyle: FontStyle.italic,
                                height: 1.35,
                              ),
                        ),
                      ],
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.place_outlined, size: 15, color: AppColors.textMuted.withOpacity(0.9)),
                          const SizedBox(width: 4),
                          Text(
                            'JNV Kaimur',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: AppColors.textMuted,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.2,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Divider(height: 1, color: Theme.of(context).dividerColor.withOpacity(0.45)),
                const SizedBox(height: 10),
                Text(
                  'Stay in touch',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textMuted,
                        letterSpacing: 0.4,
                      ),
                ),
                const SizedBox(height: 10),
                if (hasSocial)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      if (profile.facebookUrl != null)
                        _SocialIconButton(
                          tooltip: 'Facebook',
                          icon: FontAwesomeIcons.facebook,
                          iconColor: const Color(0xFF1877F2),
                          onPressed: () => onOpenUrl(profile.facebookUrl),
                        ),
                      if (profile.instagramUrl != null)
                        _SocialIconButton(
                          tooltip: 'Instagram',
                          icon: FontAwesomeIcons.instagram,
                          iconColor: const Color(0xFFE4405F),
                          onPressed: () => onOpenUrl(profile.instagramUrl),
                        ),
                      if (profile.whatsappUrl != null)
                        _SocialIconButton(
                          tooltip: 'WhatsApp',
                          icon: FontAwesomeIcons.whatsapp,
                          iconColor: const Color(0xFF25D366),
                          onPressed: () => onOpenUrl(profile.whatsappUrl),
                        ),
                    ],
                  )
                else
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: mutedFill,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.35)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      child: Row(
                        children: [
                          Icon(Icons.link_off_outlined, size: 20, color: AppColors.textMuted.withOpacity(0.85)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'No public social links for this profile.',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.35),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _photoPlaceholder() {
    return ColoredBox(
      color: Colors.grey.shade400,
      child: Icon(Icons.person, size: 52, color: Colors.grey.shade700),
    );
  }
}

class _SocialIconButton extends StatelessWidget {
  const _SocialIconButton({
    required this.tooltip,
    required this.icon,
    required this.iconColor,
    required this.onPressed,
  });

  final String tooltip;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: iconColor.withOpacity(0.12),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Tooltip(
            message: tooltip,
            child: FaIcon(icon, size: 26, color: iconColor),
          ),
        ),
      ),
    );
  }
}

class _CohortList extends StatelessWidget {
  const _CohortList({required this.cohorts});

  final List<CohortNames> cohorts;

  @override
  Widget build(BuildContext context) {
    final visible = cohorts.where((c) => c.names.any((n) => n.trim().isNotEmpty)).toList();
    if (visible.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'No names are listed for this section.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: visible.length,
      itemBuilder: (context, i) {
        final c = visible[i];
        final names = c.names.where((n) => n.trim().isNotEmpty).toList();
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(c.label, style: appHeadingStyle(context, fontSize: 18, weight: FontWeight.w600)),
                const Divider(height: 20),
                ...names.map(
                  (n) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.circle, size: 8, color: AppColors.teal.withOpacity(0.8)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            n,
                            style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
