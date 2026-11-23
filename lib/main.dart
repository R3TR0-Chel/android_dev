import 'package:android_dev/core/background/notifications.dart';
import 'package:android_dev/core/background/workers.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workmanager/workmanager.dart';
import 'screens/main_screen.dart';

Future <void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await AppNotifications.init();
  await Workmanager().initialize(callbackDispatcher);
  runApp(ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) => const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MainScreen(),
      );
}
