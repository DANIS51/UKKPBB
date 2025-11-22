import 'package:flutter/material.dart';
import 'package:ukk_danis/service/login_page.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({super.key});

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _textSlideAnimation;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();

    // ANIMASI
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _scaleAnimation =
        Tween<double>(begin: 0.6, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
    ));

    _fadeAnimation =
        Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
    ));

    _rotationAnimation =
        Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
    ));

    _pulseAnimation =
        Tween<double>(begin: 1.0, end: 1.1).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.6, 1.0, curve: Curves.easeInOut),
    ))..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _controller.forward(from: 0.6);
        }
      });

    _textSlideAnimation =
        Tween<double>(begin: 30, end: 0).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.5, 0.8, curve: Curves.easeOut),
    ));

    _shimmerAnimation =
        Tween<double>(begin: -2.0, end: 2.0).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.7, 1.0, curve: Curves.easeInOut),
    ))..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse(from: 0.7);
        } else if (status == AnimationStatus.dismissed) {
          _controller.forward(from: 0.7);
        }
      });

    _controller.forward();

    // PINDAH OTOMATIS KE LOGIN
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F1419), Color(0xFF1A2332)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // LOGO dengan animasi rotasi dan pulse
                  AnimatedBuilder(
                    animation: Listenable.merge([_rotationAnimation, _pulseAnimation]),
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _rotationAnimation.value * 0.1,
                        child: Transform.scale(
                          scale: _pulseAnimation.value,
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E88E5).withOpacity(0.15),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF1E88E5).withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 20,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.shopping_bag,
                              size: 90,
                              color: Color(0xFF1E88E5),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  // TEXT ANIMASI dengan slide dan shimmer effect
                  AnimatedBuilder(
                    animation: Listenable.merge([_textSlideAnimation, _shimmerAnimation]),
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _textSlideAnimation.value),
                        child: ShaderMask(
                          shaderCallback: (bounds) {
                            return const LinearGradient(
                              colors: [Colors.white, Colors.blue, Colors.white],
                              stops: [0.0, 0.5, 1.0],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ).createShader(bounds);
                          },
                          child: const Text(
                            "Marketplace Sekolah",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 30),

                  // LOADING INDICATOR
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return SizedBox(
                        width: 200,
                        child: LinearProgressIndicator(
                          value: _controller.value > 0.6 ? (_controller.value - 0.6) / 0.4 : 0.0,
                          backgroundColor: Colors.white.withOpacity(0.2),
                          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF1E88E5)),
                        ),
                      );
                    },
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