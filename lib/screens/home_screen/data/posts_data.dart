import '../models/comment_model.dart';
import '../models/post_model.dart';

final List<PostModel> postsData = [
  PostModel(
    imageUrl: 'https://picsum.photos/id/1011/600/600',
    likeCount: 125,
    description: 'Beautiful view 🌿',
    comments: [
      CommentModel(
        id: 'c1',
        username: 'anna',
        avatarUrl: 'https://i.pravatar.cc/150?img=1',
        text: 'So beautiful!',
        likeCount: 5,
      ),
      CommentModel(
        id: 'c2',
        username: 'maria',
        avatarUrl: 'https://i.pravatar.cc/150?img=2',
        text: 'I love this place ❤️',
        likeCount: 2,
      ),
    ],
  ),

  PostModel(
    imageUrl: 'https://picsum.photos/id/1025/600/600',
    likeCount: 89,
    description: 'Weekend mood 🐶',
    comments: [
      CommentModel(
        id: 'c3',
        username: 'alex',
        avatarUrl: 'https://i.pravatar.cc/150?img=3',
        text: 'Cute!',
        likeCount: 7,
      ),
    ],
  ),

  PostModel(
    imageUrl: 'https://picsum.photos/id/1035/600/600',
    likeCount: 214,
    description: 'Nature is always a good idea 🌲',
    comments: [
      CommentModel(
        id: 'c4',
        username: 'sara',
        avatarUrl: 'https://i.pravatar.cc/150?img=4',
        text: 'Amazing photo',
        likeCount: 4,
      ),
    ],
  ),

  PostModel(
    imageUrl: 'https://picsum.photos/id/1040/600/600',
    likeCount: 176,
    description: 'Travel memories ✈️',
    comments: [
      CommentModel(
        id: 'c5',
        username: 'david',
        avatarUrl: 'https://i.pravatar.cc/150?img=5',
        text: 'Where is this?',
        likeCount: 3,
      ),
    ],
  ),

  PostModel(
    imageUrl: 'https://picsum.photos/id/1050/600/600',
    likeCount: 98,
    description: 'Perfect morning ☀️',
    comments: [
      CommentModel(
        id: 'c6',
        username: 'lisa',
        avatarUrl: 'https://i.pravatar.cc/150?img=6',
        text: 'Love the atmosphere',
        likeCount: 1,
      ),
    ],
  ),

  PostModel(
    imageUrl: 'https://picsum.photos/id/106/600/600',
    likeCount: 301,
    description: 'Just enjoying the moment ✨',
    comments: [
      CommentModel(
        id: 'c7',
        username: 'kate',
        avatarUrl: 'https://i.pravatar.cc/150?img=7',
        text: 'Beautiful!',
        likeCount: 9,
      ),
    ],
  ),

  PostModel(
    imageUrl: 'https://picsum.photos/id/1074/600/600',
    likeCount: 156,
    description: 'A little adventure 🏔️',
    comments: [
      CommentModel(
        id: 'c8',
        username: 'julia',
        avatarUrl: 'https://i.pravatar.cc/150?img=8',
        text: 'This looks amazing!',
        likeCount: 6,
      ),
    ],
  ),

  PostModel(
    imageUrl: 'https://picsum.photos/id/1080/600/600',
    likeCount: 243,
    description: 'Coffee time ☕',
    comments: [
      CommentModel(
        id: 'c9',
        username: 'emma',
        avatarUrl: 'https://i.pravatar.cc/150?img=9',
        text: 'My favorite kind of morning',
        likeCount: 8,
      ),
    ],
  ),

  PostModel(
    imageUrl: 'https://picsum.photos/id/1084/600/600',
    likeCount: 67,
    description: 'Little details matter 🤍',
    comments: [
      CommentModel(
        id: 'c10',
        username: 'olivia',
        avatarUrl: 'https://i.pravatar.cc/150?img=10',
        text: 'So aesthetic',
        likeCount: 4,
      ),
    ],
  ),

  PostModel(
    imageUrl: 'https://picsum.photos/id/1081/600/600',
    likeCount: 189,
    description: 'City lights 🌃',
    comments: [
      CommentModel(
        id: 'c11',
        username: 'lucas',
        avatarUrl: 'https://i.pravatar.cc/150?img=11',
        text: 'The city looks beautiful',
        likeCount: 5,
      ),
    ],
  ),

  PostModel(
    imageUrl: 'https://picsum.photos/id/1082/600/600',
    likeCount: 112,
    description: 'A peaceful day 🌊',
    comments: [
      CommentModel(
        id: 'c12',
        username: 'mia',
        avatarUrl: 'https://i.pravatar.cc/150?img=12',
        text: 'So peaceful',
        likeCount: 2,
      ),
    ],
  ),

  PostModel(
    imageUrl: 'https://picsum.photos/id/1083/600/600',
    likeCount: 278,
    description: 'Exploring new places 🗺️',
    comments: [
      CommentModel(
        id: 'c13',
        username: 'noah',
        avatarUrl: 'https://i.pravatar.cc/150?img=13',
        text: 'I want to go there!',
        likeCount: 7,
      ),
    ],
  ),

  PostModel(
    imageUrl: 'https://picsum.photos/id/109/600/600',
    likeCount: 145,
    description: 'Fresh air and sunshine 🌞',
    comments: [
      CommentModel(
        id: 'c14',
        username: 'sofia',
        avatarUrl: 'https://i.pravatar.cc/150?img=14',
        text: 'Perfect weather',
        likeCount: 3,
      ),
    ],
  ),

  PostModel(
    imageUrl: 'https://picsum.photos/id/110/600/600',
    likeCount: 221,
    description: 'Weekend escape 🌴',
    comments: [
      CommentModel(
        id: 'c15',
        username: 'leo',
        avatarUrl: 'https://i.pravatar.cc/150?img=15',
        text: 'Looks like a dream',
        likeCount: 6,
      ),
    ],
  ),

  PostModel(
    imageUrl: 'https://picsum.photos/id/111/600/600',
    likeCount: 76,
    description: 'Simple moments 🤍',
    comments: [
      CommentModel(
        id: 'c16',
        username: 'chloe',
        avatarUrl: 'https://i.pravatar.cc/150?img=16',
        text: 'Love this!',
        likeCount: 2,
      ),
    ],
  ),

  PostModel(
    imageUrl: 'https://picsum.photos/id/112/600/600',
    likeCount: 334,
    description: 'Sunset 🌅',
    comments: [
      CommentModel(
        id: 'c17',
        username: 'james',
        avatarUrl: 'https://i.pravatar.cc/150?img=17',
        text: 'What a sunset!',
        likeCount: 12,
      ),
    ],
  ),

  PostModel(
    imageUrl: 'https://picsum.photos/id/113/600/600',
    likeCount: 91,
    description: 'Good vibes only ✨',
    comments: [
      CommentModel(
        id: 'c18',
        username: 'amelia',
        avatarUrl: 'https://i.pravatar.cc/150?img=18',
        text: 'Love the vibes',
        likeCount: 4,
      ),
    ],
  ),

  PostModel(
    imageUrl: 'https://picsum.photos/id/114/600/600',
    likeCount: 267,
    description: 'Another beautiful day 🌸',
    comments: [
      CommentModel(
        id: 'c19',
        username: 'ben',
        avatarUrl: 'https://i.pravatar.cc/150?img=19',
        text: 'Beautiful!',
        likeCount: 8,
      ),
    ],
  ),

  PostModel(
    imageUrl: 'https://picsum.photos/id/115/600/600',
    likeCount: 198,
    description: 'Keep smiling 😊',
    comments: [
      CommentModel(
        id: 'c20',
        username: 'ella',
        avatarUrl: 'https://i.pravatar.cc/150?img=20',
        text: 'This made my day',
        likeCount: 5,
      ),
    ],
  ),
];