import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:klaussified/core/routes/route_names.dart';
import 'package:klaussified/core/theme/colors.dart';
import 'package:klaussified/business_logic/theme/theme_bloc.dart';
import 'package:klaussified/business_logic/theme/theme_event.dart';
import 'package:klaussified/business_logic/theme/theme_state.dart';

class LandingPageScreen extends StatelessWidget {
  const LandingPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;

    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF1a1a1a)
          : AppColors.backgroundLight,
      body: Column(
        children: [
          // Navigation Bar
          _buildNavBar(context, isMobile),

          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1400),
                  child: Column(
                    children: [
                      // Main Hero Section
                      _buildHeroSection(context, isMobile),

                      const SizedBox(height: 4),

                      // Four Info Cards
                      _buildInfoCardsSection(context, isMobile),

                      const SizedBox(height: 4),

                      // CTA Section
                      _buildCTASection(context, isMobile),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavBar(BuildContext context, bool isMobile) {
    return Container(
      color: Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF2d2d2d)
          : AppColors.snowWhite,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 48,
        vertical: 16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo + Brand + About
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.christmasRed,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.card_giftcard,
                  size: 24,
                  color: AppColors.snowWhite,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Klaussified',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.christmasRed,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              if (!isMobile) ...[
                const SizedBox(width: 24),
                // Dark Mode Toggle
                BlocBuilder<ThemeBloc, ThemeState>(
                  builder: (context, state) {
                    final isDark = state.isDark;
                    return IconButton(
                      icon: Icon(
                        isDark ? Icons.light_mode : Icons.dark_mode,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : AppColors.textPrimary,
                      ),
                      onPressed: () {
                        context.read<ThemeBloc>().add(const ThemeToggleRequested());
                      },
                    );
                  },
                ),
                const SizedBox(width: 12),
                TextButton(
                  onPressed: () => context.push('/about'),
                  child: Text(
                    'About',
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ],
          ),

          // Auth Buttons
          if (!isMobile)
            Row(
              children: [
                TextButton(
                  onPressed: () => context.go(RouteNames.login),
                  child: Text(
                    'Login',
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () => context.go(RouteNames.register),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.christmasRed,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    'Create Account',
                    style: TextStyle(
                      color: AppColors.snowWhite,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            )
          else
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Dark Mode Toggle for Mobile
                BlocBuilder<ThemeBloc, ThemeState>(
                  builder: (context, state) {
                    final isDark = state.isDark;
                    return IconButton(
                      icon: Icon(
                        isDark ? Icons.light_mode : Icons.dark_mode,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : AppColors.textPrimary,
                      ),
                      onPressed: () {
                        context.read<ThemeBloc>().add(const ThemeToggleRequested());
                      },
                    );
                  },
                ),
                // Menu Button
                IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    showModalBottomSheet(
                  context: context,
                  builder: (context) => Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.info_outline),
                          title: const Text('About'),
                          onTap: () {
                            Navigator.pop(context);
                            context.push('/about');
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.login),
                          title: const Text('Login'),
                          onTap: () {
                            Navigator.pop(context);
                            context.go(RouteNames.login);
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.person_add),
                          title: const Text('Create Account'),
                          onTap: () {
                            Navigator.pop(context);
                            context.go(RouteNames.register);
                          },
                        ),
                      ],
                    ),
                  ),
                );
                  },
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context, bool isMobile) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 48,
        vertical: isMobile ? 16 : 48,
      ),
      child: Container(
        padding: EdgeInsets.all(isMobile ? 32 : 64),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.christmasRed,
            AppColors.christmasRed.withValues(alpha: 0.85),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.christmasRed.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: isMobile
          ? Column(
              children: [
                // Logo
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.snowWhite.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.card_giftcard,
                    size: 80,
                    color: AppColors.snowWhite,
                  ),
                ),
                const SizedBox(height: 32),
                // Main Headline
                Text(
                  'Secret Santa Made Easy',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: AppColors.snowWhite,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                // Subheading
                Text(
                  'No more stressing over confusing spreadsheets, chasing forgotten deadlines, or the awkward panic of buying a gift with zero ideas. Let Klaussified simplify your Secret Santa, so you can focus on the fun.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.snowWhite.withValues(alpha: 0.95),
                        height: 1.6,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                // CTA Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => context.go(RouteNames.register),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.snowWhite,
                      foregroundColor: AppColors.christmasRed,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Start Your Secret Santa',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppColors.christmasRed,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Left: Logo + Branding
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.snowWhite.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.card_giftcard,
                          size: 120,
                          color: AppColors.snowWhite,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 64),
                // Right: Content
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Secret Santa Made Easy',
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                              color: AppColors.snowWhite,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'No more stressing over confusing spreadsheets, chasing forgotten deadlines, or the awkward panic of buying a gift with zero ideas. Let Klaussified simplify your Secret Santa, so you can focus on the fun.',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppColors.snowWhite.withValues(alpha: 0.95),
                              height: 1.6,
                            ),
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: () => context.go(RouteNames.register),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.snowWhite,
                          foregroundColor: AppColors.christmasRed,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 48,
                            vertical: 18,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Start Your Secret Santa',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: AppColors.christmasRed,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
      ),
    );
  }

  Widget _buildInfoCardsSection(BuildContext context, bool isMobile) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 48),
      child: isMobile
          ? Column(
              children: [
                _buildInfoCard(
                  context,
                  icon: Icons.info_outline,
                  title: 'What is Klaussified?',
                  description:
                      'Klaussified is a modern Secret Santa platform that makes organizing gift exchanges effortless. Create groups, invite friends, and let our smart algorithm handle the rest.',
                ),
                const SizedBox(height: 16),
                _buildInfoCard(
                  context,
                  icon: Icons.how_to_reg,
                  title: 'How It Works',
                  description:
                      'Create a group, invite participants via email, set your budget and reveal date. Once everyone joins, start the draw and each person gets their Secret Santa assignment.',
                ),
                const SizedBox(height: 16),
                _buildInfoCard(
                  context,
                  icon: Icons.favorite,
                  title: 'What You Can Do',
                  description:
                      'Set gift preferences, share hobbies and wishes, and coordinate with your group. Everything you need for a perfect Secret Santa experience.',
                ),
                const SizedBox(height: 16),
                _buildInfoCard(
                  context,
                  icon: Icons.star,
                  title: 'Extra Tips',
                  description:
                      'Complete your profile with preferences early. Check gift suggestions regularly. Keep the secret until reveal day. Most importantly - have fun!',
                ),
              ],
            )
          : _buildResponsiveGrid(context),
    );
  }

  Widget _buildResponsiveGrid(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMedium = screenWidth < 1200;

    if (isMedium) {
      // 2 columns for tablet
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _buildInfoCard(
                  context,
                  icon: Icons.info_outline,
                  title: 'What is Klaussified?',
                  description:
                      'Klaussified is a modern Secret Santa platform that makes organizing gift exchanges effortless. Create groups, invite friends, and let our smart algorithm handle the rest.',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInfoCard(
                  context,
                  icon: Icons.how_to_reg,
                  title: 'How It Works',
                  description:
                      'Create a group, invite participants via email, set your budget and reveal date. Once everyone joins, start the draw and each person gets their Secret Santa assignment.',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _buildInfoCard(
                  context,
                  icon: Icons.favorite,
                  title: 'What You Can Do',
                  description:
                      'Set gift preferences, share hobbies and wishes, and coordinate with your group. Everything you need for a perfect Secret Santa experience.',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInfoCard(
                  context,
                  icon: Icons.star,
                  title: 'Extra Tips',
                  description:
                      'Complete your profile with preferences early. Check gift suggestions regularly. Keep the secret until reveal day. Most importantly - have fun!',
                ),
              ),
            ],
          ),
        ],
      );
    } else {
      // 4 columns for desktop
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: _buildInfoCard(
              context,
              icon: Icons.info_outline,
              title: 'What is Klaussified?',
              description:
                  'Klaussified is a modern Secret Santa platform that makes organizing gift exchanges effortless. Create groups, invite friends, and let our smart algorithm handle the rest.',
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildInfoCard(
              context,
              icon: Icons.how_to_reg,
              title: 'How It Works',
              description:
                  'Create a group, invite participants via email, set your budget and reveal date. Once everyone joins, start the draw and each person gets their Secret Santa assignment.',
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildInfoCard(
              context,
              icon: Icons.favorite,
              title: 'What You Can Do',
              description:
                  'Set gift preferences, share hobbies and wishes, and coordinate with your group. Everything you need for a perfect Secret Santa experience.',
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildInfoCard(
              context,
              icon: Icons.star,
              title: 'Extra Tips',
              description:
                  'Complete your profile with preferences early. Check gift suggestions regularly. Keep the secret until reveal day. Most importantly - have fun!',
            ),
          ),
        ],
      );
    }
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: AppColors.christmasRed,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.christmasGreen,
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Text(
                description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white.withValues(alpha: 0.9)
                          : AppColors.textSecondary,
                      height: 1.3,
                    ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCTASection(BuildContext context, bool isMobile) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 48,
        vertical: isMobile ? 16 : 48,
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(isMobile ? 24 : 32),
        height: isMobile ? null : 140,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.christmasGreen,
              AppColors.christmasGreen.withValues(alpha: 0.85),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.christmasGreen.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Ready to organize your Secret Santa?',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.snowWhite,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(RouteNames.register),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.snowWhite,
                foregroundColor: AppColors.christmasGreen,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                'Join Klaussified',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.christmasGreen,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Everything is free',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.snowWhite.withValues(alpha: 0.85),
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

