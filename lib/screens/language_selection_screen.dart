import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/locale_provider.dart';
import 'onboarding_screen.dart';
import 'package:animations/animations.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  Locale? _selectedLocale;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Theme.of(context).primaryColor, Colors.green.shade900],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 60),
              const Icon(Icons.language, size: 80, color: Colors.white),
              const SizedBox(height: 20),
              const Text(
                'Select Language',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'ভাষা বাছনি কৰক',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 22,
                ),
              ),
              const Spacer(),
              _buildLanguageCard(
                'English',
                'English',
                const Locale('en'),
                Icons.abc,
              ),
              const SizedBox(height: 20),
              _buildLanguageCard(
                'অসমীয়া',
                'Assamese',
                const Locale('as'),
                Icons.translate,
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Theme.of(context).primaryColor,
                      padding: const EdgeInsets.all(18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: _selectedLocale == null
                        ? null
                        : () {
                            Provider.of<LocaleProvider>(context, listen: false)
                                .setLocale(_selectedLocale!);
                            Navigator.of(context).pushReplacement(
                              PageRouteBuilder(
                                pageBuilder: (context, animation, secondaryAnimation) =>
                                    const OnboardingScreen(),
                                transitionsBuilder:
                                    (context, animation, secondaryAnimation, child) {
                                  return SharedAxisTransition(
                                    animation: animation,
                                    secondaryAnimation: secondaryAnimation,
                                    transitionType: SharedAxisTransitionType.horizontal,
                                    child: child,
                                  );
                                },
                              ),
                            );
                          },
                    child: const Text(
                      'Continue / আগবাঢ়ক',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageCard(String title, String subtitle, Locale locale, IconData icon) {
    bool isSelected = _selectedLocale == locale;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedLocale = locale;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 30),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withAlpha(26),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.white : Colors.white24,
            width: 2,
          ),
          boxShadow: isSelected
              ? [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))]
              : [],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 40,
              color: isSelected ? Theme.of(context).primaryColor : Colors.white,
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: isSelected ? Theme.of(context).primaryColor : Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: isSelected ? Theme.of(context).primaryColor.withAlpha(179) : Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const Spacer(),
            if (isSelected)
              Icon(Icons.check_circle, color: Theme.of(context).primaryColor),
          ],
        ),
      ),
    );
  }
}
