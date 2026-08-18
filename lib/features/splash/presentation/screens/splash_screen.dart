import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common_background.dart';
import '../../../../features/tasks/presentation/screens/task_list_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const TaskListScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CommonBackground(
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RichText(
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 56, 
                  fontWeight: FontWeight.bold, 
                  letterSpacing: 2, 
                  fontFamily: 'sans-serif',
                ),
                children: [
                  TextSpan(text: 'TO', style: TextStyle(color: Colors.black87)),
                  TextSpan(text: 'D', style: TextStyle(color: AppTheme.secondaryColor)),
                ],
              ),
            ),
            const SizedBox(width: 4),
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: AppTheme.secondaryColor,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.check, 
                  color: Colors.white, 
                  size: 32, 
                  weight: 900,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
