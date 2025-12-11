import 'package:flutter/material.dart';
import 'package:hiatunisie/constant.dart';
import 'package:hiatunisie/views/splash/splash_view.dart';
import 'package:hiatunisie/widgets/smart_scaffold.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // Initialize animation controller
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);

    // Initialize animation
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

  }

 

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return SmartScaffold(
      body: Center(
        child: Consumer<SplashViewModel>(
          builder: (context, viewModel, _) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipOval(
                child: Image.asset(
                    'images/icon_hia.png',
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    return AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4.0),
                          width: 10.0,
                          height: 10.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _animation.value > (index * 0.3) ? kMainColor.withOpacity(0.8) : gray,
                          ),
                        );
                      },
                    );
                  }),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
