import 'package:flutter/material.dart';
import 'package:jnvk/data/batch_data.dart';
import 'package:jnvk/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _animationController, curve: Curves.easeIn);

    _animationController.forward();

    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute<void>(builder: (context) => const HomeScreen()),
      );
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final shortestSide = size.shortestSide;
    // Scale logo and text with screen size, clamped for very small/large devices
    final logoSize = (shortestSide * 0.45).clamp(120.0, 280.0);
    final spacing = (shortestSide * 0.06).clamp(16.0, 32.0);
    final fontSize = (shortestSide * 0.055).clamp(14.0, 28.0);

    return Scaffold(
      backgroundColor: Colors.greenAccent.withOpacity(0.9),
      body: FadeTransition(
        opacity: _animation,
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      BatchData.appLogoAsset,
                      width: logoSize,
                      height: logoSize,
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.medium,
                      errorBuilder: (_, __, ___) => Icon(
                        Icons.school_outlined,
                        size: logoSize * 0.5,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: spacing),
                    Text(
                      "JNV Kaimur",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
