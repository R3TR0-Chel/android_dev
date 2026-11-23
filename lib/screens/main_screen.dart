import "package:android_dev/screens/tabs/home_tab.dart";
import "package:android_dev/screens/tabs/search_tab.dart";
import "package:android_dev/screens/tabs/profile_tab.dart";
import "package:android_dev/screens/tabs/new_post_tab.dart";
import "package:android_dev/screens/tabs/activity_tab.dart";
import "package:android_dev/widgets/animated_indexed_stack.dart";
import "package:material_ui/material_ui.dart";

class MainScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  static const _pages = [
    HomeTab(),
    SearchTab(),
    NewPostTab(),
    ActivityTab(),
    ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.add_box), label: 'New post'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Activity',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
      body: AnimatedIndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
    );
  }
}
