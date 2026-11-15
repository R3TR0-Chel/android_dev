import 'package:android_dev/screens/home_screen/models/comment_model.dart';
import 'package:android_dev/screens/home_screen/models/post_model.dart';
import 'package:android_dev/screens/home_screen/models/story_model.dart';

String _avatar(int id) => 'https://i.pravatar.cc/150?img=$id';
// Unsplash photo IDs (picsum.photos isn't reachable from this network).
const _photoIds = {
  'issykkul': '1507525428034-b723cf961d3e',
  'coffee': '1495474472287-4d71bcdd2085',
  'mountains': '1464822759023-fed622ff2c3b',
  'flutter': '1517694712202-14dd9538aa97',
  'plov': '1504674900247-0877df9cc836',
  'citynight': '1519681393784-d120267933ba',
  'puppy': '1543466835-00a7907e9de1',
  'library': '1481627834876-b7833e8f5570',
  'painting': '1579546929518-9e396f3cc809',
  'football': '1522202176988-66273c2fd55f',
  'songkol': '1501785888041-af3ef285b470',
  'keyboard': '1517245386807-bb43f82c33c4',
  'bakery': '1509042239860-f550ce710b93',
  'concert': '1540039155733-5bb30b53aa14',
  'snowboard': '1506744038136-46273834b3fb',
  'garden': '1441974231531-c6227db76b6e',
  'hackathon': '1497633762265-9d179a990aa6',
  'horses': '1469474968028-56623f02e42e',
  'sunset': '1500530855697-b586d89ba3ee',
  'graduation': '1511671782779-c97d3d27a1d4',
};

String _image(String key) =>
    'https://images.unsplash.com/photo-${_photoIds[key]}?w=600&h=600&fit=crop';

CommentModel _c(String username, int avatarId, String text) =>
    CommentModel(username: username, avatarUrl: _avatar(avatarId), text: text);

final List<StoryModel> mockStories = [
  StoryModel(username: 'aida.k', avatarUrl: _avatar(1)),
  StoryModel(username: 'timur_dev', avatarUrl: _avatar(3)),
  StoryModel(username: 'nurlan', avatarUrl: _avatar(5)),
  StoryModel(username: 'aliya.art', avatarUrl: _avatar(9)),
  StoryModel(username: 'beka_92', avatarUrl: _avatar(11)),
  StoryModel(username: 'dana.travels', avatarUrl: _avatar(16)),
  StoryModel(username: 'erlan.fit', avatarUrl: _avatar(12)),
  StoryModel(username: 'saule', avatarUrl: _avatar(20)),
  StoryModel(username: 'arman.photo', avatarUrl: _avatar(14)),
  StoryModel(username: 'kamila', avatarUrl: _avatar(23)),
];

final List<PostModel> mockPosts = [
  PostModel(
    imageUrl: _image('issykkul'),
    description: 'Sunrise over Issyk-Kul. Worth waking up at 5am 🌅',
    likeCount: 124,
    comments: [
      _c('aida.k', 1, 'Absolutely stunning!'),
      _c('nurlan', 5, 'Going there next summer for sure'),
    ],
  ),
  PostModel(
    imageUrl: _image('coffee'),
    description: 'Monday fuel ☕ Who else needs three cups to start the week?',
    likeCount: 58,
    comments: [
      _c('timur_dev', 3, 'Three? Rookie numbers'),
      _c('saule', 20, 'Where is this café?'),
      _c('beka_92', 11, 'Looks cozy'),
    ],
  ),
  PostModel(
    imageUrl: _image('mountains'),
    description: 'Ala-Archa trail, 14 km round trip. Legs are gone.',
    likeCount: 210,
    comments: [_c('erlan.fit', 12, 'Great pace, see you on the next hike')],
  ),
  PostModel(
    imageUrl: _image('flutter'),
    description: 'First Flutter app running on a real device 🚀',
    likeCount: 87,
    comments: [
      _c('timur_dev', 3, 'Welcome to the club!'),
      _c('kamila', 23, 'Hot reload is magic'),
    ],
  ),
  PostModel(
    imageUrl: _image('plov'),
    description: 'Sunday plov with the family. Recipe in stories!',
    likeCount: 301,
    comments: [
      _c('dana.travels', 16, 'Save me a plate 😋'),
      _c('aliya.art', 9, 'Recipe please!!'),
    ],
  ),
  PostModel(
    imageUrl: _image('citynight'),
    description: 'Bishkek lights after the rain.',
    likeCount: 76,
    comments: [_c('arman.photo', 14, 'Nice long exposure, what settings?')],
  ),
  PostModel(
    imageUrl: _image('puppy'),
    description: 'Meet Bars, the newest member of our family 🐶',
    likeCount: 455,
    comments: [
      _c('saule', 20, 'Sooo cute'),
      _c('aida.k', 1, 'I need to meet him'),
      _c('beka_92', 11, 'Bars is a strong name'),
    ],
  ),
  PostModel(
    imageUrl: _image('library'),
    description: 'Exam week mode: on. Wish me luck 📚',
    likeCount: 39,
    comments: [_c('nurlan', 5, 'You got this!')],
  ),
  PostModel(
    imageUrl: _image('painting'),
    description: 'Finished my first oil painting after two months of work.',
    likeCount: 189,
    comments: [
      _c('aliya.art', 9, 'The colors are beautiful'),
      _c('kamila', 23, 'Are you selling it?'),
    ],
  ),
  PostModel(
    imageUrl: _image('football'),
    description: 'Won the university cup final 3–1 ⚽🏆',
    likeCount: 267,
    comments: [
      _c('erlan.fit', 12, 'What a game!'),
      _c('timur_dev', 3, 'That second goal 🔥'),
    ],
  ),
  PostModel(
    imageUrl: _image('songkol'),
    description: 'Two nights in a yurt at Son-Kul. No signal, no problem.',
    likeCount: 342,
    comments: [_c('dana.travels', 16, 'Adding this to my list')],
  ),
  PostModel(
    imageUrl: _image('keyboard'),
    description: 'New mechanical keyboard. My neighbors hate it.',
    likeCount: 64,
    comments: [
      _c('timur_dev', 3, 'Which switches?'),
      _c('beka_92', 11, 'Clicky gang'),
    ],
  ),
  PostModel(
    imageUrl: _image('bakery'),
    description: 'Fresh tandoor bread straight from the bazaar.',
    likeCount: 98,
    comments: [_c('saule', 20, 'Nothing beats warm nan')],
  ),
  PostModel(
    imageUrl: _image('concert'),
    description: 'Last night’s concert was unreal 🎸',
    likeCount: 143,
    comments: [
      _c('kamila', 23, 'I was there too!'),
      _c('arman.photo', 14, 'Great shot from the crowd'),
    ],
  ),
  PostModel(
    imageUrl: _image('snowboard'),
    description: 'Karakol slopes are in perfect shape this week 🏂',
    likeCount: 220,
    comments: [_c('erlan.fit', 12, 'Going this weekend!')],
  ),
  PostModel(
    imageUrl: _image('garden'),
    description: 'Grandma’s garden is blooming again 🌷',
    likeCount: 115,
    comments: [
      _c('aida.k', 1, 'So many colors'),
      _c('nurlan', 5, 'Say hi to her from me'),
    ],
  ),
  PostModel(
    imageUrl: _image('hackathon'),
    description: '36 hours, 4 people, 1 working demo. We placed 2nd!',
    likeCount: 178,
    comments: [
      _c('timur_dev', 3, 'Congrats team!'),
      _c('beka_92', 11, 'What did you build?'),
    ],
  ),
  PostModel(
    imageUrl: _image('horses'),
    description: 'Horse riding in Chon-Kemin valley 🐎',
    likeCount: 203,
    comments: [_c('dana.travels', 16, 'Dream trip')],
  ),
  PostModel(
    imageUrl: _image('sunset'),
    description: 'Ended the day on the rooftop. Grateful.',
    likeCount: 92,
    comments: [
      _c('saule', 20, 'Beautiful sky'),
      _c('aliya.art', 9, 'Painting this one'),
    ],
  ),
  PostModel(
    imageUrl: _image('graduation'),
    description: 'Officially a graduate! Thank you to everyone who helped 🎓',
    likeCount: 512,
    comments: [
      _c('kamila', 23, 'So proud of you!'),
      _c('erlan.fit', 12, 'Congratulations!'),
      _c('arman.photo', 14, 'Big day 🎉'),
    ],
  ),
];
