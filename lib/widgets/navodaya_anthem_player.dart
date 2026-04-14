import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../data/batch_data.dart';

/// Local MP3 player for the Navodaya anthem: play / pause / stop, loop, seek.
/// Stops when the app goes to background or is closed.
class NavodayaAnthemPlayer extends StatefulWidget {
  const NavodayaAnthemPlayer({super.key});

  @override
  State<NavodayaAnthemPlayer> createState() => _NavodayaAnthemPlayerState();
}

class _NavodayaAnthemPlayerState extends State<NavodayaAnthemPlayer> with WidgetsBindingObserver {
  late final AudioPlayer _player;
  final List<StreamSubscription<dynamic>> _subs = [];

  bool _ready = false;
  bool _loop = false;
  String? _error;

  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _player = AudioPlayer();
    _load();
  }

  Future<void> _load() async {
    try {
      await _player.setAudioSource(AudioSource.asset(BatchData.navodayaAnthemAsset));
      if (!mounted) return;
      setState(() {
        _ready = true;
        _error = null;
      });
      _subs.add(_player.durationStream.listen((d) {
        if (mounted) setState(() => _duration = d ?? Duration.zero);
      }));
      _subs.add(_player.positionStream.listen((p) {
        if (mounted) setState(() => _position = p);
      }));
      _subs.add(_player.playerStateStream.listen((_) {
        if (mounted) setState(() {});
      }));
    } catch (_) {
      if (mounted) {
        setState(() {
          _error = 'Could not load audio.';
          _ready = false;
        });
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      unawaited(_player.stop());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    for (final s in _subs) {
      unawaited(s.cancel());
    }
    unawaited(_player.dispose());
    super.dispose();
  }

  Future<void> _togglePlay() async {
    if (!_ready) return;
    if (_player.playing) {
      await _player.pause();
    } else {
      await _player.play();
    }
  }

  Future<void> _stop() async {
    await _player.stop();
    await _player.seek(Duration.zero);
  }

  Future<void> _toggleLoop() async {
    final next = !_loop;
    setState(() => _loop = next);
    await _player.setLoopMode(next ? LoopMode.one : LoopMode.off);
  }

  Future<void> _onSeek(double v) async {
    if (!_ready || _duration == Duration.zero) return;
    await _player.seek(Duration(milliseconds: v.round()));
  }

  String _fmt(Duration d) {
    final t = d.inSeconds;
    final m = t ~/ 60;
    final s = t % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final playing = _ready && _player.playing;
    final maxMs = _duration.inMilliseconds > 0 ? _duration.inMilliseconds.toDouble() : 1.0;
    final posMs = _position.inMilliseconds.clamp(0, _duration.inMilliseconds).toDouble();

    if (_error != null) {
      return Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Text(
          _error!,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 13),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: !_ready ? null : _togglePlay,
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(playing ? 0.28 : 0.95),
                  foregroundColor: playing ? Colors.white : const Color(0xFF1A8A8E),
                  minimumSize: const Size(48, 48),
                  maximumSize: const Size(48, 48),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                iconSize: 28,
                icon: Icon(playing ? Icons.pause_rounded : Icons.play_arrow_rounded),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: !_ready ? null : _stop,
                style: IconButton.styleFrom(
                  foregroundColor: Colors.white.withOpacity(0.95),
                  backgroundColor: Colors.white.withOpacity(0.15),
                  minimumSize: const Size(48, 48),
                  maximumSize: const Size(48, 48),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                iconSize: 28,
                tooltip: 'Stop',
                icon: const Icon(Icons.stop_rounded),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: !_ready ? null : _toggleLoop,
                style: IconButton.styleFrom(
                  foregroundColor: _loop ? const Color(0xFFB8FFFB) : Colors.white.withOpacity(0.85),
                  backgroundColor: _loop ? Colors.white.withOpacity(0.22) : Colors.white.withOpacity(0.1),
                  minimumSize: const Size(48, 48),
                  maximumSize: const Size(48, 48),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                iconSize: 28,
                tooltip: _loop ? 'Loop on' : 'Loop off',
                icon: Icon(_loop ? Icons.repeat_one_rounded : Icons.repeat_rounded),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                _fmt(_position),
                style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 12),
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 3,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
                  ),
                  child: Slider(
                    value: posMs.clamp(0.0, maxMs),
                    max: maxMs,
                    onChanged: !_ready || _duration == Duration.zero ? null : _onSeek,
                    activeColor: Colors.white,
                    inactiveColor: Colors.white.withOpacity(0.35),
                  ),
                ),
              ),
              Text(
                _fmt(_duration),
                style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
