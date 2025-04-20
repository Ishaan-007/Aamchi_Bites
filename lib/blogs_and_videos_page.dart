import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class BlogsAndVideosPage extends StatefulWidget {
  const BlogsAndVideosPage({Key? key}) : super(key: key);

  @override
  State<BlogsAndVideosPage> createState() => _BlogsAndVideosPageState();
}

class _BlogsAndVideosPageState extends State<BlogsAndVideosPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Color primaryColor = const Color(0xFFF5A23D); // Orange
  final Color accentColor = const Color(0xFF1E8A7A); // Teal
  final Color lightBgColor = const Color(0xFFFCE8C7); // Light beige

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryColor,
        title: Row(
          children: [
            Text(
              'Buzz',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Bites',
              style: TextStyle(
                color: accentColor,
                fontSize: 30,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48),
          child: TabBar(
            controller: _tabController,
            indicatorColor: accentColor,
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            labelStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            tabs: [
              Tab(text: 'Instagram Videos'),
              Tab(text: 'Food Blogs'),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildInstagramVideosTab(),
          _buildFoodBlogsTab(),
        ],
      ),
    );
  }

  Widget _buildInstagramVideosTab() {
    List<Map<String, dynamic>> instagramVideos = [
      {
        'title': 'Mumbai Street Food Tour',
        'username': '@mumbaifoodlovers',
        'thumbnailUrl': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRNZ1eSjWfoi1VUpLj-sqGrMhRvgxlfYObxFg&s',
        'videoUrl': 'https://www.instagram.com/reel/DIdoVu0tzre/?igsh=MXRkeXAwcWl4MmhrNQ==',
        'likes': '12.5k',
        'views': '205k',
        'description': 'Exploring the best street food spots in Mumbai! From vada pav to pav bhaji, the flavors are incredible! 🤤 #MumbaiFood #StreetFood',
      },
      {
        'title': 'Best Seafood in Mumbai',
        'username': '@foodie_explorer',
        'thumbnailUrl': 'https://img.freepik.com/premium-vector/editable-text-effect-food-vlogger-3d-traditional-cartoon-style-template_69619-223.jpg?w=1380',
        'videoUrl': 'https://www.instagram.com/reel/Cuzi9xNIrDe/?igsh=MWZ3dXo5c3B5ZjkxaA==',
        'likes': '8.7k',
        'views': '126k',
        'description': 'Tasting the freshest seafood dishes at this hidden gem in Versova! The butter garlic crab is to die for! 🦀 #MumbaiSeafood',
      },
      {
        'title': 'South Indian Delights',
        'username': '@taste_of_india',
        'thumbnailUrl': 'https://i.ytimg.com/vi/9hub8lA63o0/hq720.jpg?sqp=-oaymwEhCK4FEIIDSFryq4qpAxMIARUAAAAAGAElAADIQj0AgKJD&rs=AOn4CLDoRooq5YmIic-1j67QCGvon-QMOw',
        'videoUrl': 'https://www.instagram.com/reel/DHQmaAtqFWJ/?igsh=MTFlaWpocHhwMXJucw==',
        'likes': '15.2k',
        'views': '310k',
        'description': 'The best South Indian breakfast in Mumbai! These dosas are crispy perfection with the most flavorful chutneys! 😋 #SouthIndianFood #MumbaiEats',
      },
      {
        'title': 'Hidden Dessert Spots',
        'username': '@sweettoothjourney',
        'thumbnailUrl': 'https://things2.do/blogs/wp-content/uploads/2025/03/pexels-photo-9201341-2.jpeg',
        'videoUrl': 'https://www.instagram.com/reel/DHQmaAtqFWJ/?igsh=MTFlaWpocHhwMXJucw==',
        'likes': '9.6k',
        'views': '178k',
        'description': 'Discovering Mumbai\'s best hidden dessert cafes! This chocolate soufflé will change your life! 🍫 #MumbaiDesserts #SweetTooth',
      },
    ];

    return Container(
      color: primaryColor,
      child: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: instagramVideos.length,
        itemBuilder: (context, index) {
          final video = instagramVideos[index];
          return _buildVideoCard(video);
        },
      ),
    );
  }

  Widget _buildVideoCard(Map<String, dynamic> video) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: lightBgColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Video thumbnail with play button
          Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: Image.network(
        video['thumbnailUrl'],
        width: double.infinity,
        height: 220,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          width: double.infinity,
          height: 220,
          color: Colors.black12,
          child: Center(
            child: Icon(Icons.broken_image, size: 40, color: Colors.grey),
          ),
        ),
      ),
              ),
              GestureDetector(
                onTap: () => _launchURL(video['videoUrl']),
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.play_arrow,
                    size: 40,
                    color: accentColor,
                  ),
                ),
              ),
            ],
          ),
          
          // Video details
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: accentColor,
                      radius: 16,
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      video['username'],
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    ),
                    Spacer(),
                    Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 16,
                    ),
                    SizedBox(width: 4),
                    Text(
                      video['likes'],
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(
                      Icons.visibility,
                      color: Colors.black54,
                      size: 16,
                    ),
                    SizedBox(width: 4),
                    Text(
                      video['views'],
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Text(
                  video['title'],
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  video['description'],
                  style: TextStyle(
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _launchURL(video['videoUrl']),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    minimumSize: Size(double.infinity, 0),
                  ),
                  child: Text(
                    "Watch on Instagram",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodBlogsTab() {
    List<Map<String, dynamic>> foodBlogs = [
      {
        'title': 'Mumbai Street Food 101',
        'author': 'A Chef\'s Tour',
        'imageUrl': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT7idmmZwR1X1ozXb3wNNHResHWbO8tvFS8rA&s',
        'blogUrl': 'https://achefstour.com/blog/mumbai-street-food-101',
        'date': 'April 15, 2025',
        'excerpt': 'Mumbai\'s street food scene is a vibrant tapestry of flavors, colors, and aromas that reflect the city\'s cultural diversity...',
      },
      {
        'title': 'Top 10 Must-Try Dishes in Mumbai',
        'author': 'Bombay Foodie',
        'imageUrl': 'https://recurpost.com/wp-content/uploads/2024/10/food-blog.png',
        'blogUrl': 'https://www.bombayfoodie.com/',
        'date': 'April 2, 2025',
        'excerpt': 'From the iconic Vada Pav to the delectable Pav Bhaji, Mumbai offers a culinary adventure unlike any other city...',
      },
      {
        'title': 'Hidden Gems: Mumbai\'s Secret Food Spots',
        'author': 'Bombay Foodie',
        'imageUrl': 'https://i.ytimg.com/vi/gOsOX_pwSUk/hq720.jpg?sqp=-oaymwEhCK4FEIIDSFryq4qpAxMIARUAAAAAGAElAADIQj0AgKJD&rs=AOn4CLAFXqPysDvmbX3CuMjxOxHwBbgTyQ',
        'blogUrl': 'https://www.bombayfoodie.com/',
        'date': 'March 28, 2025',
        'excerpt': 'Beyond the famous eateries are Mumbai\'s best-kept secrets. Discover local favorites tucked away in narrow lanes...',
      },
      {
        'title': 'The History of Mumbai\'s Iconic Dishes',
        'author': 'A Chef\'s Tour',
        'imageUrl': 'https://cdn.vox-cdn.com/thumbor/vIxfwurd2pxUgWZ2uMVgCo7hyFY=/0x504:4032x2520/fit-in/1200x600/cdn.vox-cdn.com/uploads/chorus_asset/file/25229412/Thakars.jpg',
        'blogUrl': 'https://achefstour.com/blog/mumbai-street-food-101',
        'date': 'March 15, 2025',
        'excerpt': 'Every iconic Mumbai dish has a fascinating story behind it. Learn about the cultural influences and historical events...',
      },
    ];

    return Container(
      color: primaryColor,
      child: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: foodBlogs.length,
        itemBuilder: (context, index) {
          final blog = foodBlogs[index];
          return _buildBlogCard(blog);
        },
      ),
    );
  }

  Widget _buildBlogCard(Map<String, dynamic> blog) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: lightBgColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Blog image
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Image.network(
        blog['imageUrl'],
        width: double.infinity,
        height: 220,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          width: double.infinity,
          height: 220,
          color: Colors.black12,
          child: Center(
            child: Icon(Icons.broken_image, size: 40, color: Colors.grey),
          ),
        ),
      ),
          ),
          
          // Blog details
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.restaurant,
                      color: accentColor,
                      size: 18,
                    ),
                    SizedBox(width: 6),
                    Text(
                      blog['author'],
                      style: TextStyle(
                        color: accentColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Spacer(),
                    Icon(
                      Icons.calendar_today,
                      color: Colors.black54,
                      size: 14,
                    ),
                    SizedBox(width: 4),
                    Text(
                      blog['date'],
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Text(
                  blog['title'],
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  blog['excerpt'],
                  style: TextStyle(
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _launchURL(blog['blogUrl']),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accentColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 10),
                        ),
                        child: Text(
                          "Read Full Article",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: accentColor),
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.bookmark_border,
                          color: accentColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $url')),
      );
    }
  }
}

// Add this to your main.dart file
void main() {
  runApp(const BuzzBitesApp());
}

class BuzzBitesApp extends StatelessWidget {
  const BuzzBitesApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Buzz Bites',
      theme: ThemeData(
        primaryColor: const Color(0xFFF5A23D),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFF5A23D),
          primary: const Color(0xFFF5A23D),
          secondary: const Color(0xFF1E8A7A),
        ),
        fontFamily: 'Georgia',
      ),
      home: const BlogsAndVideosPage(),
    );
  }
}