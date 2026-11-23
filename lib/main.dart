import 'package:android_dev/core/auth/auth_service.dart';
import 'package:android_dev/screens/auth_screen.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/main_screen.dart';

void main() => runApp(const ProviderScope(child: MainApp()));

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) => const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AuthGate(),
      );
}

/// Shows the login screen when logged out and the app when logged in.
/// Login/logout write the Sessions table; this rebuilds from its stream.
class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      ref.watch(currentUserProvider).when(
            loading: () => const Scaffold(
                body: Center(child: CircularProgressIndicator())),
            error: (error, _) =>
                Scaffold(body: Center(child: Text('Database error: $error'))),
            data: (user) =>
                user == null ? const AuthScreen() : const MainScreen(),
          );
}
