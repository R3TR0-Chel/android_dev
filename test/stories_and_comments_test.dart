import 'package:android_dev/screens/content/post_widget.dart';
import 'package:android_dev/screens/home_screen/models/post_model.dart';
import 'package:android_dev/screens/home_screen/models/story_model.dart';
import 'package:android_dev/widgets/stories_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('stories show usernames without vertical overflow', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(
            textScaler: TextScaler.linear(2),
          ),
          child: Scaffold(
            body: StoriesList(
              stories: List.generate(
                8,
                (index) => StoryModel(
                  username: 'user_$index',
                  avatarUrl: 'https://example.com/avatar_$index.png',
                  imageUrl: 'https://example.com/story_$index.png',
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('user_0'), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);
    expect(
      tester.widget<ListView>(find.byType(ListView)).scrollDirection,
      Axis.horizontal,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('comment submission updates once and displays immediately', (
    tester,
  ) async {
    final post = PostModel(
      imageUrl: 'https://example.com/post.png',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PostWidget(post: post),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.comment));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'A new comment');
    await tester.tap(find.byIcon(Icons.send));
    await tester.tap(find.byIcon(Icons.send));
    await tester.pumpAndSettle();

    expect(post.comments, hasLength(1));
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is RichText &&
            widget.text.toPlainText().contains('A new comment'),
      ),
      findsOneWidget,
    );
    Navigator.of(tester.element(find.text('Comments'))).pop();
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
