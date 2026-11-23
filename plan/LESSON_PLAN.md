Here’s the shape we’re aiming for: the UI watches Riverpod providers, providers call the local data service, and the service reads and writes drift. The UI never talks to the database directly.

ProfileTab
   ↓ watches
profilePostsProvider ──→ LocalDataService ──→ Drift database
   ↓ calls
profileControllerProvider.notifier

The current LocalDataService already has the storage operations. The feed is still backed by demo data, so the next step is replacing that demo source with database-backed providers.

## How reads should work

For data that can change, expose a stream from the service and convert it to a Riverpod StreamProvider:

final profilePostsProvider = StreamProvider<List<CachedPost>>((ref) {
  return ref.watch(localDataServiceProvider).watchPosts();
});

Then ProfileTab watches it and handles loading, error, and data states:

final postsAsync = ref.watch(profilePostsProvider);

return postsAsync.when(
  loading: () => const Center(child: CircularProgressIndicator()),
  error: (error, stack) => Center(child: Text('Could not load posts: $error')),
  data: (posts) => /* render posts */,
);

Drift’s watch() stream emits again after database writes. Riverpod listens to that stream and rebuilds the widget, so the profile updates automatically.

## How writes should work

Use a Riverpod notifier for actions. It calls the service; after a successful write, the drift stream emits the updated rows.

class ProfileController extends Notifier<void> {
  @override
  void build() {}

  Future<void> saveProfile(UserProfilesCompanion profile) {
    return ref.read(localDataServiceProvider).saveProfile(profile);
  }
}

final profileControllerProvider =
    NotifierProvider<ProfileController, void>(ProfileController.new);

A UI action calls the notifier:

ref.read(profileControllerProvider.notifier).saveProfile(
  UserProfilesCompanion.insert(
    id: 'me',
    nickname: 'alimhan',
    avatarUrl: const Value('https://example.com/avatar.jpg'),
  ),
);

That write updates the database. Any widget watching the corresponding stream provider then rebuilds with the new profile.

## A practical wiring order

1. Add watchProfile(id) to LocalDataService, returning a stream for one profile.
2. Add a StreamProvider.family for a profile and another for the signed-in user’s posts.
3. Add notifiers for creating a post and updating a profile. Keep validation and UI messages in the screen; keep persistence calls in the notifier/service path.
4. Change ProfileTab to watch those providers instead of using the hardcoded nickname/avatar and feed demo data.
5. Change the feed provider to watch cached posts. For refreshes, fetch remote data and upsert it into drift; the UI still watches the database stream.

One design choice to make before changing the code: should profile and post data initially be seeded with the current demo values, or should the profile show an empty state until the user creates data?