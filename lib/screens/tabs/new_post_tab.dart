import 'package:android_dev/screens/home_screen/state/feed_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

class NewPostTab extends ConsumerStatefulWidget {
  const NewPostTab({super.key});

  @override
  ConsumerState<NewPostTab> createState() => _NewPostTabState();
}

class _NewPostTabState extends ConsumerState<NewPostTab> {
  final _formKey = GlobalKey<FormState>();
  final _imageUrl = TextEditingController();
  final _caption = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _imageUrl.dispose();
    _caption.dispose();
    super.dispose();
  }

  Future<void> _share() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    try {
      await ref.read(feedControllerProvider).createPost(
            imageUrl: _imageUrl.text.trim(),
            caption: _caption.text.trim(),
          );
      _imageUrl.clear();
      _caption.clear();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post saved to your device.')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('New post')),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextFormField(
                controller: _imageUrl,
                keyboardType: TextInputType.url,
                decoration: const InputDecoration(labelText: 'Image URL'),
                validator: (value) {
                  final uri = Uri.tryParse(value?.trim() ?? '');
                  return uri != null && uri.hasAuthority && uri.scheme.startsWith('http')
                      ? null
                      : 'Enter a valid image URL.';
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _caption,
                decoration: const InputDecoration(labelText: 'Caption'),
                maxLines: 4,
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'A caption is required.'
                    : null,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _isSaving ? null : _share,
                child: Text(_isSaving ? 'Saving…' : 'Share post'),
              ),
            ],
          ),
        ),
      );
}
