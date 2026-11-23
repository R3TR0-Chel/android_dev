import 'package:android_dev/core/background/notifications.dart';
import 'package:android_dev/core/background/workers.dart';
import 'package:material_ui/material_ui.dart';

/// Bottom sheet for turning the periodic "new likes" notification on and off.
class LikesDigestSheet extends StatefulWidget {
  const LikesDigestSheet({super.key});

  static Future<void> show(BuildContext context) => showModalBottomSheet<void>(
        context: context,
        showDragHandle: true,
        builder: (_) => const LikesDigestSheet(),
      );

  @override
  State<LikesDigestSheet> createState() => _LikesDigestSheetState();
}

class _LikesDigestSheetState extends State<LikesDigestSheet> {
  bool? _enabled; // null while we ask WorkManager

  @override
  void initState() {
    super.initState();
     LikeDigestScheduler.isRunning().then((value) {
      if (mounted) setState(() => _enabled = value);
    });
  }

  Future<bool> _ensurePermission() async {
    final granted = await AppNotifications.requestPermission();
    if (!granted && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Allow notifications in Settings to get the digest.')),
      );
    }
    return granted;
  }

  Future<void> _toggle(bool value) async {
    if (value && !await _ensurePermission()) return;
    value ? await LikeDigestScheduler.start() : await LikeDigestScheduler.stop();
    if (mounted) setState(() => _enabled = value);
  }

  Future<void> _testNow() async {
    if (!await _ensurePermission()) return;
    await LikeDigestScheduler.runOnce();
    if (!mounted) return;
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Scheduled. Close the app — the notification arrives in ~10 s.')),
    );
  }

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SwitchListTile(
                secondary: const Icon(Icons.favorite_border),
                title: const Text('New likes digest'),
                subtitle: const Text('Background check about every 15 minutes'),
                value: _enabled ?? false,
                onChanged: _enabled == null ? null : _toggle,
              ),
              ListTile(
                leading: const Icon(Icons.timer_outlined),
                title: const Text('Test it now'),
                subtitle: const Text('Run the same task once, 10 seconds from now'),
                onTap: _testNow,
              ),
            ],
          ),
        ),
      );
}
