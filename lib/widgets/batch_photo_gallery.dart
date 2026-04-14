import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../data/batch_data.dart';
import '../data/user_gallery_store.dart';
import '../theme/app_theme.dart';
import 'section_header.dart';

enum GallerySlideKind { asset, file }

class GallerySlide {
  const GallerySlide._(this.kind, this.path);
  const GallerySlide.asset(String path) : this._(GallerySlideKind.asset, path);
  const GallerySlide.file(String path) : this._(GallerySlideKind.file, path);

  final GallerySlideKind kind;
  final String path;

  bool get isUserFile => kind == GallerySlideKind.file;
}

/// Horizontal carousel of batch photos + user-added photos; tap opens fullscreen with zoom and save.
class BatchPhotoGallerySection extends StatefulWidget {
  const BatchPhotoGallerySection({super.key});

  @override
  State<BatchPhotoGallerySection> createState() => _BatchPhotoGallerySectionState();
}

class _BatchPhotoGallerySectionState extends State<BatchPhotoGallerySection> {
  late final PageController _controller;
  int _index = 0;
  List<String> _userPaths = [];

  List<GallerySlide> get _slides {
    final assets = BatchData.galleryImages.map(GallerySlide.asset).toList();
    final files = _userPaths.map(GallerySlide.file).toList();
    return [...assets, ...files];
  }

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 0.86);
    _loadUser();
  }

  Future<void> _loadUser() async {
    final paths = await UserGalleryStore.loadPaths();
    if (!mounted) return;
    setState(() => _userPaths = paths);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickPhotos() async {
    if (kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Adding photos from this device is not supported on web.')),
      );
      return;
    }
    final picker = ImagePicker();
    final files = await picker.pickMultiImage(imageQuality: 92);
    if (files.isEmpty || !mounted) return;
    await UserGalleryStore.addFromPicker(files);
    await _loadUser();
    if (!mounted) return;
    setState(() {
      _index = _slides.length - 1;
    });
    if (_slides.isNotEmpty) {
      await _controller.animateToPage(
        _index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Added ${files.length} photo${files.length == 1 ? '' : 's'}.')),
      );
    }
  }

  Future<void> _removeUserSlide(GallerySlide slide) async {
    if (!slide.isUserFile) return;
    await UserGalleryStore.removePath(slide.path);
    await _loadUser();
    if (!mounted) return;
    setState(() {
      if (_index >= _slides.length && _slides.isNotEmpty) {
        _index = _slides.length - 1;
      } else if (_slides.isEmpty) {
        _index = 0;
      }
    });
  }

  void _openFullscreen(BuildContext context, int initialIndex) {
    final slides = _slides;
    if (slides.isEmpty) return;
    Navigator.of(context).push<void>(
      PageRouteBuilder<void>(
        opaque: false,
        barrierColor: Colors.black87,
        pageBuilder: (context, animation, secondary) {
          return FadeTransition(
            opacity: animation,
            child: _GalleryFullscreenPage(
              slides: slides,
              initialIndex: initialIndex,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final slides = _slides;
    final w = MediaQuery.sizeOf(context).width;
    final cardHeight = (w * 0.48).clamp(220.0, 340.0);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 12),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              const SectionHeader(
                title: 'Gallery',
                description:
                    '${BatchData.batchIdentityShort} — bundled photos and your own picks. Swipe sideways, then tap.',
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: _pickPhotos,
                icon: const Icon(Icons.add_photo_alternate_outlined),
                label: const Text('Add photos from your device'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.teal,
                  side: const BorderSide(color: AppColors.teal),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
              const SizedBox(height: 12),
              if (slides.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    'No photos yet. Use the button above to add some from your library.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                )
              else ...[
                SizedBox(
                  height: cardHeight + 28,
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: slides.length,
                    onPageChanged: (i) => setState(() => _index = i),
                    itemBuilder: (context, i) {
                      final slide = slides[i];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
                        child: _GalleryCard(
                          slide: slide,
                          onOpen: () => _openFullscreen(context, i),
                          onRemove: slide.isUserFile ? () => _removeUserSlide(slide) : null,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(slides.length, (i) {
                    final active = i == _index;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: active ? 22 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: active ? AppColors.teal : AppColors.teal.withOpacity(0.35),
                      ),
                    );
                  }),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Opens a bundled asset in the same fullscreen viewer as the gallery (pinch-zoom + save).
void openAssetImageFullscreen(BuildContext context, String assetPath) {
  Navigator.of(context).push<void>(
    PageRouteBuilder<void>(
      opaque: false,
      barrierColor: Colors.black87,
      pageBuilder: (context, animation, secondary) {
        return FadeTransition(
          opacity: animation,
          child: _GalleryFullscreenPage(
            slides: [GallerySlide.asset(assetPath)],
            initialIndex: 0,
          ),
        );
      },
    ),
  );
}

class _GalleryCard extends StatelessWidget {
  const _GalleryCard({
    required this.slide,
    required this.onOpen,
    this.onRemove,
  });

  final GallerySlide slide;
  final VoidCallback onOpen;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(18);
    return Material(
      color: Colors.transparent,
      elevation: 6,
      shadowColor: Colors.black26,
      borderRadius: borderRadius,
      child: InkWell(
        onTap: onOpen,
        borderRadius: borderRadius,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: borderRadius,
            child: Stack(
              fit: StackFit.expand,
              children: [
                _thumb(slide),
                if (onRemove != null)
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Material(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(20),
                      child: InkWell(
                        onTap: onRemove,
                        borderRadius: BorderRadius.circular(20),
                        child: const Padding(
                          padding: EdgeInsets.all(6),
                          child: Icon(Icons.close, color: Colors.white, size: 20),
                        ),
                      ),
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
                          Colors.black.withOpacity(0.55),
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(14, 24, 14, 12),
                      child: Row(
                        children: [
                          Icon(Icons.touch_app_outlined, color: Colors.white.withOpacity(0.95), size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              slide.isUserFile ? 'Yours · tap for full screen' : 'Tap for full screen',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.95),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
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
        ),
      ),
    );
  }

  Widget _thumb(GallerySlide slide) {
    if (slide.kind == GallerySlideKind.asset) {
      return Image.asset(
        slide.path,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => ColoredBox(
          color: Colors.grey.shade300,
          child: const Icon(Icons.broken_image_outlined, size: 48),
        ),
      );
    }
    return Image.file(
      File(slide.path),
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => ColoredBox(
        color: Colors.grey.shade300,
        child: const Icon(Icons.broken_image_outlined, size: 48),
      ),
    );
  }
}

class _GalleryFullscreenPage extends StatefulWidget {
  const _GalleryFullscreenPage({
    required this.slides,
    required this.initialIndex,
  });

  final List<GallerySlide> slides;
  final int initialIndex;

  @override
  State<_GalleryFullscreenPage> createState() => _GalleryFullscreenPageState();
}

class _GalleryFullscreenPageState extends State<_GalleryFullscreenPage> {
  late final PageController _pageController;
  late int _current;

  @override
  void initState() {
    super.initState();
    _current = widget.initialIndex.clamp(0, widget.slides.length - 1);
    _pageController = PageController(initialPage: _current);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _saveCurrent() async {
    if (kIsWeb) {
      _toast('Saving is not available on web.');
      return;
    }
    final ok = await _ensureSavePermission();
    if (!ok) {
      _toast('Photo access was denied. Enable it in Settings to save images.');
      return;
    }
    final slide = widget.slides[_current];
    try {
      final Uint8List bytes;
      if (slide.kind == GallerySlideKind.asset) {
        final data = await rootBundle.load(slide.path);
        bytes = data.buffer.asUint8List();
      } else {
        bytes = await File(slide.path).readAsBytes();
      }
      final name = 'jnvk_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final dynamic result = await ImageGallerySaver.saveImage(
        bytes,
        quality: 100,
        name: name,
      );
      final success = result is Map && result['isSuccess'] == true;
      if (!mounted) return;
      _toast(success ? 'Saved to gallery' : 'Could not save image');
    } catch (_) {
      if (mounted) _toast('Could not save image');
    }
  }

  Future<bool> _ensureSavePermission() async {
    if (Platform.isIOS) {
      final s = await Permission.photosAddOnly.request();
      if (s.isGranted) return true;
      final p = await Permission.photos.request();
      return p.isGranted;
    }
    if (Platform.isAndroid) {
      final photos = await Permission.photos.request();
      if (photos.isGranted) return true;
      final storage = await Permission.storage.request();
      return storage.isGranted;
    }
    return true;
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: widget.slides.length,
              onPageChanged: (i) => setState(() => _current = i),
              itemBuilder: (context, i) {
                final slide = widget.slides[i];
                return InteractiveViewer(
                  minScale: 0.8,
                  maxScale: 4,
                  child: Center(
                    child: slide.kind == GallerySlideKind.asset
                        ? Image.asset(
                            slide.path,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) =>
                                const Icon(Icons.broken_image, color: Colors.white54, size: 64),
                          )
                        : Image.file(
                            File(slide.path),
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) =>
                                const Icon(Icons.broken_image, color: Colors.white54, size: 64),
                          ),
                  ),
                );
              },
            ),
            Positioned(
              top: 4,
              left: 4,
              right: 4,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white24,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: _saveCurrent,
                    tooltip: 'Save to gallery',
                    icon: const Icon(Icons.download_rounded),
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.teal.withOpacity(0.9),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            if (widget.slides.length > 1)
              Positioned(
                bottom: 16,
                left: 0,
                right: 0,
                child: Text(
                  '${_current + 1} / ${widget.slides.length}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
