// lib/app/routes.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mastawekia_app/features/auth/data/models/user_model.dart';
import 'package:mastawekia_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:mastawekia_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:mastawekia_app/features/auth/presentation/screens/login_screen.dart';
import 'package:mastawekia_app/features/auth/presentation/screens/register_screen.dart';
import 'package:mastawekia_app/features/jobs/presentation/screens/client_dashboard_screen.dart';
import 'package:mastawekia_app/features/jobs/presentation/screens/seeker_feed_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String seekerHome = '/seeker-home';
  static const String clientHome = '/client-home';

  static GoRouter createRouter(AuthCubit authCubit) {
    return GoRouter(
      initialLocation: login,
      refreshListenable: GoRouterRefreshStream(authCubit.stream),
      redirect: (BuildContext context, GoRouterState state) {
        final authState = authCubit.state;
        final isLoggingIn = state.matchedLocation == login;
        final isRegistering = state.matchedLocation == register;

        if (authState is Unauthenticated || authState is AuthInitial || authState is AuthFailure) {
          return (isLoggingIn || isRegistering) ? null : login;
        }

        if (authState is Authenticated) {
          final targetHome = authState.user.role == UserRole.client
              ? clientHome
              : seekerHome;

          if (isLoggingIn || isRegistering) {
            return targetHome;
          }
        }

        return null;
      },
      routes: [
        GoRoute(
          path: login,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: register,
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: seekerHome,
          builder: (context, state) => const SeekerFeedScreen(),
        ),
        GoRoute(
          path: clientHome,
          builder: (context, state) => const ClientDashboardScreen(),
        ),
      ],
    );
  }
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    stream.listen((_) => notifyListeners());
  }
}