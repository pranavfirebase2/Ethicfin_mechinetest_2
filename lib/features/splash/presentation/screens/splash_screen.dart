import 'package:flutter/material.dart';
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
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
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
                  TextSpan(text: 'TO', style: TextStyle(color: Colors.white)),
                  TextSpan(text: 'D', style: TextStyle(color: Color(0xFFF95B56))),
                ],
              ),
            ),
            const SizedBox(width: 4),
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: Color(0xFFF95B56),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.check, 
                  color: Colors.black, 
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
