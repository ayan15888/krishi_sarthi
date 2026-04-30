import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/locale_provider.dart';
import 'auth/login_screen.dart';
import 'package:animations/animations.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final List<Map<String, String>> pages = [
      {
        'title': l10n.onboardingTitle1,
        'desc': l10n.onboardingDesc1,
        'icon': 'agriculture'
      },
      {
        'title': l10n.onboardingTitle2,
        'desc': l10n.onboardingDesc2,
        'icon': 'wb_sunny'
      },
      {
        'title': l10n.onboardingTitle3,
        'desc': l10n.onboardingDesc3,
        'icon': 'recommend'
      },
    ];

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 40,
            right: 20,
            child: Consumer<LocaleProvider>(
              builder: (context, localeProvider, child) {
                return DropdownButton<Locale>(
                  value: localeProvider.locale,
                  underline: const SizedBox(),
                  icon: const Icon(Icons.language, color: Colors.grey),
                  onChanged: (Locale? newLocale) {
                    if (newLocale != null) {
                      localeProvider.setLocale(newLocale);
                    }
                  },
                  items: const [
                    DropdownMenuItem(
                      value: Locale('en'),
                      child: Text('EN'),
                    ),
                    DropdownMenuItem(
                      value: Locale('as'),
                      child: Text('AS'),
                    ),
                  ],
                );
              },
            ),
          ),
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: pages.length,
            itemBuilder: (context, index) {
              return OnboardingPage(
                title: pages[index]['title']!,
                description: pages[index]['desc']!,
                icon: pages[index]['icon']!,
              );
            },
          ),
          Positioned(
            bottom: 50,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => _complete(context),
                  child: Text(l10n.skip),
                ),
                Row(
                  children: List.generate(
                    pages.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.all(4),
                      width: _currentPage == index ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: _currentPage == index
                            ? Theme.of(context).primaryColor
                            : Colors.grey.withAlpha(77),
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  onPressed: () {
                    if (_currentPage == pages.length - 1) {
                      _complete(context);
                    } else {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.fastOutSlowIn,
                      );
                    }
                  },
                  child: Text(_currentPage == pages.length - 1
                      ? l10n.getStarted
                      : l10n.next),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _complete(BuildContext context) {
    Provider.of<AuthProvider>(context, listen: false).completeOnboarding();
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SharedAxisTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            transitionType: SharedAxisTransitionType.horizontal,
            child: child,
          );
        },
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final String icon;

  const OnboardingPage({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TweenAnimationBuilder(
            duration: const Duration(milliseconds: 800),
            tween: Tween<double>(begin: 0.8, end: 1.0),
            builder: (context, double value, child) {
              return Transform.scale(scale: value, child: child);
            },
            child: Icon(
              _getIconData(icon),
              size: 150,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 40),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  IconData _getIconData(String name) {
    switch (name) {
      case 'agriculture':
        return Icons.agriculture;
      case 'wb_sunny':
        return Icons.wb_sunny;
      case 'recommend':
        return Icons.recommend;
      default:
        return Icons.help;
    }
  }
}
