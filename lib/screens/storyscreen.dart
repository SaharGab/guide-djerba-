import 'package:flutter/material.dart';
import 'package:projet_pfe/models/models.dart';
import 'package:projet_pfe/screens/detailsscreen.dart';

class StoryScreen extends StatefulWidget {
  final List<DataModel> stories; // Liste des histoires
  final int initialStoryIndex; // Index de départ

  StoryScreen({
    Key? key,
    required this.stories,
    this.initialStoryIndex = 0, // Commencez par la première histoire par défaut
  }) : super(key: key);

  @override
  _StoryScreenState createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen>
    with SingleTickerProviderStateMixin {
  bool isFavorited = false;
  late AnimationController _progressAnimationController;
  late PageController _pageController;
  int _currentStoryIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentStoryIndex = widget.initialStoryIndex;
    _pageController = PageController(initialPage: _currentStoryIndex);
    _progressAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );
    _progressAnimationController.addListener(() {
      setState(() {});
    });

    _progressAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (_currentStoryIndex < widget.stories.length - 1) {
          _goToNextStory();
        } else {
          Navigator.of(context)
              .pop(); // Retour à l'écran d'accueil s'il n'y a pas d'autre histoire
        }
      }
    });

    _progressAnimationController.forward();
  }

  void _goToNextStory() {
    setState(() {
      _currentStoryIndex++;
    });
    _pageController.animateToPage(
      _currentStoryIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    _progressAnimationController.reset();
    _progressAnimationController.forward();
  }

  @override
  void dispose() {
    _progressAnimationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _toggleFavorite() {
    setState(() {
      isFavorited = !isFavorited;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () {
          Navigator.of(context)
              .pop(); // Retour à l'écran d'accueil lorsque l'utilisateur tape sur l'écran
        },
        behavior: HitTestBehavior.opaque,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: LinearProgressIndicator(
                value: _progressAnimationController.value,
                backgroundColor: const Color.fromARGB(255, 194, 190, 190),
                color: const Color.fromARGB(255, 17, 17, 17),
                minHeight: 2.0,
              ),
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundImage:
                    NetworkImage(widget.stories[_currentStoryIndex].imageUrl),
              ),
              title: Text(
                widget.stories[_currentStoryIndex].title,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
              trailing: IconButton(
                icon: Icon(
                  isFavorited ? Icons.favorite : Icons.favorite_border,
                  color: isFavorited ? Colors.red : Colors.white,
                ),
                onPressed: _toggleFavorite,
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics:
                    NeverScrollableScrollPhysics(), // Disable swipe to navigate
                itemCount: widget.stories.length,
                itemBuilder: (context, index) {
                  return Image.network(
                    widget.stories[index].imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Text(
                          'Could not load the image',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Accédez à l'histoire actuelle en utilisant _currentStoryIndex
                  DataModel currentStory = widget.stories[_currentStoryIndex];

                  // Naviguez vers DetailScreen avec les détails de l'histoire actuelle
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DetailScreen(dataModel: currentStory),
                    ),
                  );
                },
                child: const Text('More Details',
                    style: TextStyle(
                        color: Color.fromARGB(255, 18, 120, 171),
                        fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
