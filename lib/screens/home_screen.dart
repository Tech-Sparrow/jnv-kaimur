import 'dart:async';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../data/batch_data.dart';
import '../data/models.dart';
import '../theme/app_theme.dart';
import '../theme/app_theme_scope.dart';
import '../widgets/batch_photo_gallery.dart';
import '../widgets/navodaya_anthem_player.dart';
import '../widgets/section_header.dart';
import 'house_screen.dart';
import 'privacy_policy_screen.dart';
import 'terms_of_use_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _keyHero = GlobalKey();
  final GlobalKey _keyAbout = GlobalKey();
  final GlobalKey _keyBoys = GlobalKey();
  final GlobalKey _keyGirls = GlobalKey();
  final GlobalKey _keyGallery = GlobalKey();

  bool _showFab = false;
  String _appVersionLabel = '';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadPackageInfo();
  }

  Future<void> _loadPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    if (!mounted) return;
    setState(() {
      _appVersionLabel = '${info.version} (${info.buildNumber})';
    });
  }

  void _onScroll() {
    final show = _scrollController.offset > 180;
    if (show != _showFab) setState(() => _showFab = show);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _scrollTo(GlobalKey key) async {
    final ctx = key.currentContext;
    if (ctx == null) return;
    await Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeInOut,
      alignment: 0.05,
    );
  }

  int _crossAxisCount(double width) {
    if (width >= 1100) return 4;
    if (width >= 700) return 2;
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(context),
      floatingActionButton: _showFab
          ? FloatingActionButton.small(
              onPressed: () => _scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOutCubic,
              ),
              backgroundColor: AppColors.teal,
              child: const Icon(Icons.keyboard_arrow_up, color: Colors.white),
            )
          : null,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 0,
            backgroundColor: Colors.transparent,
            flexibleSpace: Container(decoration: BoxDecoration(gradient: appBarGradient)),
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  BatchData.appLogoAsset,
                  height: 30,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const SizedBox(width: 30, height: 30),
                ),
                const SizedBox(width: 10),
                const Text(
                  'JNVK 2k10+LE',
                  style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.w300),
                ),
              ],
            ),
            actions: [
              IconButton(
                tooltip: 'About',
                icon: const Icon(Icons.info_outline),
                onPressed: () => _scrollTo(_keyAbout),
              ),
            ],
          ),
          SliverToBoxAdapter(child: _Hero(key: _keyHero, onGetStarted: () => _scrollTo(_keyAbout))),
          SliverToBoxAdapter(
            child: KeyedSubtree(
              key: _keyAbout,
              child: _AboutSection(),
            ),
          ),
          SliverToBoxAdapter(child: _CtaBanner()),
          SliverToBoxAdapter(
            child: KeyedSubtree(
              key: _keyBoys,
              child: _HouseGridSection(
                title: 'Boys',
                description: 'Below are the boys, grouped by house. · ${BatchData.batchIdentityShort}',
                isGirls: false,
                crossAxisCount: _crossAxisCount,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: KeyedSubtree(
              key: _keyGirls,
              child: _HouseGridSection(
                title: 'Girls',
                description: 'Below are the girls, grouped by house. · ${BatchData.batchIdentityShort}',
                isGirls: true,
                crossAxisCount: _crossAxisCount,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: KeyedSubtree(
              key: _keyGallery,
              child: const BatchPhotoGallerySection(),
            ),
          ),
          SliverToBoxAdapter(
            child: _Footer(
              onHome: () => _scrollTo(_keyHero),
              onPrivacyPolicy: () {
                Navigator.of(context).push<void>(
                  MaterialPageRoute<void>(builder: (_) => const PrivacyPolicyScreen()),
                );
              },
              onTermsOfUse: () {
                Navigator.of(context).push<void>(
                  MaterialPageRoute<void>(builder: (_) => const TermsOfUseScreen()),
                );
              },
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final themeController = AppThemeScope.of(context);

    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(gradient: appBarGradient),
              child: const Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'JNV Kaimur\nBatch 2k10 + LE',
                  style: TextStyle(color: Colors.white, fontSize: 20, height: 1.3),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                children: [
                  _DrawerGroupCard(
                    title: 'Navigate',
                    icon: Icons.navigation_outlined,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.home_outlined),
                          title: const Text('Home'),
                          onTap: () {
                            Navigator.pop(context);
                            _scrollTo(_keyHero);
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.groups_outlined),
                          title: const Text('Boys'),
                          onTap: () {
                            Navigator.pop(context);
                            _scrollTo(_keyBoys);
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.groups_2_outlined),
                          title: const Text('Girls'),
                          onTap: () {
                            Navigator.pop(context);
                            _scrollTo(_keyGirls);
                          },
                        ),
                      ],
                    ),
                  ),
                  _DrawerGroupCard(
                    title: BatchData.batchIdentityShort,
                    icon: Icons.school_outlined,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.info_outline),
                          title: const Text('About the batch'),
                          onTap: () {
                            Navigator.pop(context);
                            _scrollTo(_keyAbout);
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.photo_library_outlined),
                          title: const Text('Photo gallery'),
                          onTap: () {
                            Navigator.pop(context);
                            _scrollTo(_keyGallery);
                          },
                        ),
                      ],
                    ),
                  ),
                  _DrawerGroupCard(
                    title: 'Houses',
                    icon: Icons.home_work_outlined,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (final h in House.values)
                          ListTile(
                            leading: const Icon(Icons.home_work_outlined),
                            title: Text(h.label),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute<void>(builder: (_) => HouseScreen(house: h)),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                  _DrawerGroupCard(
                    title: 'Appearance',
                    icon: Icons.palette_outlined,
                    child: ListenableBuilder(
                      listenable: themeController,
                      builder: (context, _) {
                        final mode = themeController.themeMode;
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            RadioListTile<ThemeMode>(
                              dense: true,
                              visualDensity: VisualDensity.compact,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                              title: const Text('Light'),
                              value: ThemeMode.light,
                              groupValue: mode,
                              onChanged: (v) {
                                if (v != null) themeController.setThemeMode(v);
                              },
                            ),
                            RadioListTile<ThemeMode>(
                              dense: true,
                              visualDensity: VisualDensity.compact,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                              title: const Text('Dark'),
                              value: ThemeMode.dark,
                              groupValue: mode,
                              onChanged: (v) {
                                if (v != null) themeController.setThemeMode(v);
                              },
                            ),
                            RadioListTile<ThemeMode>(
                              dense: true,
                              visualDensity: VisualDensity.compact,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                              title: const Text('System default'),
                              value: ThemeMode.system,
                              groupValue: mode,
                              onChanged: (v) {
                                if (v != null) themeController.setThemeMode(v);
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
              child: Card(
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  child: Text(
                    'House rosters are available offline in this app.',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Card(
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (_appVersionLabel.isNotEmpty)
                        Text(
                          'Version $_appVersionLabel',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      if (_appVersionLabel.isNotEmpty) const SizedBox(height: 8),
                      Text(
                        '© Tech Sparrow',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerGroupCard extends StatelessWidget {
  const _DrawerGroupCard({
    required this.title,
    required this.child,
    required this.icon,
  });

  final String title;
  final Widget child;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Card(
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 4),
              child: Row(
                children: [
                  Icon(icon, size: 20, color: cs.primary),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: cs.primary,
                        ),
                  ),
                ],
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({super.key, required this.onGetStarted});

  final VoidCallback onGetStarted;

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.sizeOf(context).height;
    final heroHeight = (h * 0.52).clamp(340.0, 560.0);

    return SizedBox(
      height: heroHeight,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/img/hero-bg.jpg',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(color: AppColors.teal.withOpacity(0.35)),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.green.withOpacity(0.82),
                  AppColors.teal.withOpacity(0.82),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Welcome to JNV Kaimur',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: _heroTitleSize(context),
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'We are ${BatchData.batchIdentityShort}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: _heroSubtitleSize(context),
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Card(
                    color: Colors.white.withOpacity(0.18),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.white.withOpacity(0.35)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.location_city_outlined, color: Colors.white, size: 22),
                          const SizedBox(width: 10),
                          Text(
                            'JNV Kaimur · ${BatchData.aboutTitle}',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: _heroSubtitleSize(context) * 0.88,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'This app lists students from Batch 2k10, including lateral-entry students.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: _heroCaptionSize(context),
                      color: Colors.white.withOpacity(0.95),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 28),
                  OutlinedButton(
                    onPressed: onGetStarted,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white, width: 2),
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                      shape: const StadiumBorder(),
                    ),
                    child: const Text('Get Started', style: TextStyle(letterSpacing: 1)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _heroTitleSize(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    if (w < 360) return 22;
    if (w < 600) return 26;
    return 40;
  }

  double _heroSubtitleSize(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    if (w < 360) return 16;
    if (w < 600) return 18;
    return 22;
  }

  double _heroCaptionSize(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return w < 400 ? 13 : 15;
  }
}

class _AboutSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: sectionBackground(context),
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            children: [
              const SectionHeader(
                title: 'About Us',
                description: '${BatchData.batchIdentityShort} · JNV Kaimur',
              ),
              Card(
                clipBehavior: Clip.antiAlias,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final wide = constraints.maxWidth >= 800;
                    const photo = _AboutBatchPhoto(assetPath: BatchData.aboutGroupPhotoAsset);

                    if (wide) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Expanded(
                            flex: 5,
                            child: AspectRatio(
                              aspectRatio: 1.05,
                              child: photo,
                            ),
                          ),
                          Expanded(
                            flex: 6,
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: _AboutCopy(),
                            ),
                          ),
                        ],
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const AspectRatio(
                          aspectRatio: 16 / 10,
                          child: photo,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                          child: _AboutCopy(),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AboutBatchPhoto extends StatelessWidget {
  const _AboutBatchPhoto({required this.assetPath});

  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => openAssetImageFullscreen(context, assetPath),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              assetPath,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => ColoredBox(
                color: Colors.grey.shade300,
                child: const Center(child: Text('Batch photo')),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.58),
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 20, 12, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.zoom_in_map_rounded, color: Colors.white.withOpacity(0.95), size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'Tap — zoom & save',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.95),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AboutCopy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(BatchData.aboutTitle, style: appHeadingStyle(context, fontSize: 26)),
        const SizedBox(height: 8),
        const Text(
          BatchData.aboutSubtitle,
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, height: 1.35),
        ),
        const SizedBox(height: 16),
        Text(BatchData.aboutBody, style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.65)),
      ],
    );
  }
}

class _CtaBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: 36,
        horizontal: MediaQuery.sizeOf(context).width < 400 ? 16 : 32,
      ),
      decoration: BoxDecoration(gradient: appBarGradient),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Card(
            color: Colors.white.withOpacity(0.12),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.white.withOpacity(0.28)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
              child: Column(
                children: [
                  Text(
                    BatchData.batchIdentityShort,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    BatchData.ctaTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    BatchData.ctaBody,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white.withOpacity(0.95), height: 1.55, fontSize: 16),
                  ),
                  const NavodayaAnthemPlayer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HouseGridSection extends StatelessWidget {
  const _HouseGridSection({
    required this.title,
    required this.description,
    required this.isGirls,
    required this.crossAxisCount,
  });

  final String title;
  final String description;
  final bool isGirls;
  final int Function(double width) crossAxisCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isGirls ? Theme.of(context).colorScheme.surface : sectionBackground(context),
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 12),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              SectionHeader(
                title: title,
                descriptionWidget: isGirls
                    ? RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
                          children: [
                            TextSpan(text: '$description '),
                            TextSpan(
                              text: '(Grouping may not reflect original house assignments.)',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      )
                    : null,
                description: isGirls ? null : description,
              ),
              LayoutBuilder(
                builder: (context, constraints) {
                  final n = crossAxisCount(constraints.maxWidth);
                  const roster = BatchData.houses;
                  return Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.center,
                    children: roster.map((r) {
                      final cohorts = isGirls ? r.girlsByCohort : r.boysByCohort;
                      return SizedBox(
                        width: _tileWidth(constraints.maxWidth, n),
                        child: _HouseCard(
                          house: r.house,
                          cohorts: cohorts,
                          isGirlsSection: isGirls,
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _tileWidth(double maxWidth, int columns) {
    const gap = 16.0;
    final inner = maxWidth - 24;
    return (inner - gap * (columns - 1)) / columns;
  }
}

class _HouseCard extends StatefulWidget {
  const _HouseCard({
    required this.house,
    required this.cohorts,
    required this.isGirlsSection,
  });

  final House house;
  final List<CohortNames> cohorts;
  final bool isGirlsSection;

  @override
  State<_HouseCard> createState() => _HouseCardState();
}

class _HouseCardState extends State<_HouseCard> {
  static const String _girlsHouseDetailsUnavailable =
      'Full house detail pages with photos are not available for the girls’ section.';

  static const Duration _girlsSnackBarDebounce = Duration(milliseconds: 400);

  Timer? _girlsSnackBarTimer;

  @override
  void dispose() {
    _girlsSnackBarTimer?.cancel();
    super.dispose();
  }

  void _onGirlsHouseDetailsPressed() {
    _girlsSnackBarTimer?.cancel();
    _girlsSnackBarTimer = Timer(_girlsSnackBarDebounce, () {
      _girlsSnackBarTimer = null;
      if (!mounted) return;
      final messenger = ScaffoldMessenger.of(context);
      messenger.clearSnackBars();
      messenger.showSnackBar(
        const SnackBar(content: Text(_girlsHouseDetailsUnavailable)),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final visible = widget.cohorts.where((c) => c.names.any((n) => n.trim().isNotEmpty)).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.house.label,
              textAlign: TextAlign.center,
              style: appHeadingStyle(context, fontSize: 20, weight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            for (final c in visible) ...[
              Text(
                c.label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textMuted,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 6),
              ...c.names.where((n) => n.trim().isNotEmpty).map(
                    (n) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text(
                        n,
                        style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 15, height: 1.35),
                      ),
                    ),
                  ),
              const SizedBox(height: 8),
            ],
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                if (widget.isGirlsSection) {
                  _onGirlsHouseDetailsPressed();
                  return;
                }
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(builder: (_) => HouseScreen(house: widget.house)),
                );
              },
              child: const Text('House details'),
            ),
          ],
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({
    required this.onHome,
    required this.onPrivacyPolicy,
    required this.onTermsOfUse,
  });

  final VoidCallback onHome;
  final VoidCallback onPrivacyPolicy;
  final VoidCallback onTermsOfUse;

  static ButtonStyle _linkStyle() {
    return TextButton.styleFrom(
      foregroundColor: Colors.white.withOpacity(0.88),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      minimumSize: Size.zero,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF121416),
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Card(
            elevation: 6,
            shadowColor: Colors.black54,
            color: const Color(0xFF1C2225),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: BorderSide(color: AppColors.teal.withOpacity(0.35)),
            ),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(18)),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF232B2E),
                    Color(0xFF15191B),
                  ],
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '© JNV Kaimur Batch 2k10 · All rights reserved.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white.withOpacity(0.65), fontSize: 12, height: 1.35),
                  ),
                  const SizedBox(height: 12),
                  Divider(height: 1, color: Colors.white.withOpacity(0.12)),
                  const SizedBox(height: 10),
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 4,
                    runSpacing: 6,
                    children: [
                      TextButton(
                        onPressed: onHome,
                        style: _linkStyle(),
                        child: const Text('Home'),
                      ),
                      _FooterDot(),
                      TextButton(
                        onPressed: onPrivacyPolicy,
                        style: _linkStyle(),
                        child: const Text('Privacy Policy'),
                      ),
                      _FooterDot(),
                      TextButton(
                        onPressed: onTermsOfUse,
                        style: _linkStyle(),
                        child: const Text('Terms of Use'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FooterDot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Text('·', style: TextStyle(color: Colors.white.withOpacity(0.35), fontSize: 14, height: 1)),
    );
  }
}
