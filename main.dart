import 'package:flutter/material.dart';

void main() {
  runApp(const RIISApp());
}

class RIISApp extends StatelessWidget {
  const RIISApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RIIS Social Media',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: const MainContainer(),
    );
  }
}

class MainContainer extends StatefulWidget {
  const MainContainer({super.key});

  @override
  _MainContainerState createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const FeedTab(),
    const ReelsTab(),
    const ChatTab(),
    const ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Feed'),
          BottomNavigationBarItem(icon: Icon(Icons.video_collection), label: 'Reels'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

// 1. फीड टैब (Feed with Content Safety Filter)
class FeedTab extends StatefulWidget {
  const FeedTab({super.key});

  @override
  _FeedTabState createState() => _FeedTabState();
}

class _FeedTabState extends State<FeedTab> {
  final List<Map<String, dynamic>> _posts = [
    {"user": "Abdulrihan", "city": "Moradabad", "likes": 1240, "isLiked": false, "caption": "Building RIIS app securely! 🚀"},
    {"user": "Israil", "city": "India", "likes": 850, "isLiked": false, "caption": "Clean code and safe platform. ✨"},
  ];

  final TextEditingController _captionController = TextEditingController();

  // गंदे या आपत्तिजनक शब्दों की लिस्ट (Auto-Moderation Check)
  final List<String> _badWords = ['badword', 'abuse', 'ganda', 'adult', 'nsfw', 'vulgar'];

  bool _containsBadContent(String text) {
    String lowerText = text.toLowerCase();
    for (String word in _badWords) {
      if (lowerText.contains(word)) {
        return true;
      }
    }
    return false;
  }

  void _addNewPost() {
    String text = _captionController.text;
    if (text.isEmpty) return;

    // अगर कोई गलत शब्द या गंदा कंटेंट पाया गया तो वीडियो/पोस्ट ऑटोमैटिक डिलीट/ब्लाक हो जाएगी
    if (_containsBadContent(text)) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('⚠️ Content Blocked'),
          content: const Text('Yeh post community guidelines ke khilaf hai aur ise automatically delete/block kar diya gaya hai!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      setState(() {
        _posts.insert(0, {
          "user": "Abdulrihan",
          "city": "Moradabad",
          "likes": 1,
          "isLiked": false,
          "caption": text,
        });
      });
      Navigator.pop(context);
    }
    _captionController.clear();
  }

  void _openUploadDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text('Create New Post', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: _captionController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Write a safe caption...',
            hintStyle: TextStyle(color: Colors.grey),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(onPressed: _addNewPost, child: const Text('Post')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RIIS Feed', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box_outlined, size: 28),
            onPressed: _openUpload_Dialog_Trigger,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _posts.length,
        itemBuilder: (context, index) {
          final p = _posts[index];
          return Card(
            margin: const EdgeInsets.all(8),
            color: Colors.grey[900],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: CircleAvatar(backgroundColor: Colors.blueAccent, child: Text(p['user'][0])),
                  title: Text(p['user'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  subtitle: Text(p['city'], style: const TextStyle(color: Colors.grey)),
                ),
                Container(
                  height: 180,
                  color: Colors.grey[800],
                  child: Center(child: Text('Secure Media ${index + 1} 🛡️', style: const TextStyle(color: Colors.white70))),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(p['isLiked'] ? Icons.favorite : Icons.favorite_border, color: p['isLiked'] ? Colors.red : Colors.white),
                        onPressed: () {
                          setState(() {
                            p['isLiked'] = !p['isLiked'];
                            p['isLiked'] ? p['likes']++ : p['likes']--;
                          });
                        },
                      ),
                      Text('${p['likes']}', style: const TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Text(p['caption'], style: const TextStyle(color: Colors.white)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _openUpload_Dialog_Trigger() {
    _openUploadDialog();
  }
}

// 2. रील्स टैब (Reels with Auto-Delete Guard)
class ReelsTab extends StatefulWidget {
  const ReelsTab({key}) : super(key: key);

  @override
  State<ReelsTab> createState() => _ReelsTabState();
}

class _ReelsTabState extends State<ReelsTab> {
  bool _isUploadingReel = false;
  String _statusMessage = "Reels Video Player Area 🎥 (AI Protected)";

  void _simulateReelUpload(bool isBadContent) {
    setState(() {
      _isUploadingReel = true;
    });

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isUploadingReel = false;
        if (isBadContent) {
          _statusMessage = "🚫 Violation Detected: Inappropriate video was automatically deleted by RIIS AI!";
        } else {
          _statusMessage = "✅ Reel uploaded successfully & verified safe!";
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                _statusMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
          if (_isUploadingReel)
            const Center(child: CircularProgressIndicator(color: Colors.blueAccent)),
          Positioned(
            top: 50,
            right: 20,
            child: PopupMenuButton<String>(
              icon: const Icon(Icons.video_call, color: Colors.white, size: 30),
              onSelected: (value) {
                if (value == 'clean') _simulateReelUpload(false);
                if (value == 'bad') _simulateReelUpload(true);
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'clean', child: Text('Upload Safe Reel')),
                const PopupMenuItem(value: 'bad', child: Text('Upload Vulgar/Bad Reel (Test Auto-Delete)')),
              ],
            ),
          ),
          Positioned(
            bottom: 30,
            right: 20,
            child: Column(
              children: const [
                Icon(Icons.favorite, color: Colors.red, size: 32),
                Text('10K', style: TextStyle(color: Colors.white)),
                SizedBox(height: 15),
                Icon(Icons.comment, color: Colors.white, size: 32),
                Text('420', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 3. चैट टैब (Chat)
class ChatTab extends StatefulWidget {
  const ChatTab({super.key});

  @override
  _ChatTabState createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> {
  final List<Map<String, dynamic>> _messages = [
    {"text": "Hello bhai! RIIS app secure aur fast ban gaya hai.", "isMe": false},
  ];
  final TextEditingController _ctrl = TextEditingController();

  void _send() {
    if (_ctrl.text.isNotEmpty) {
      setState(() {
        _messages.add({"text": _ctrl.text, "isMe": true});
        _ctrl.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('RIIS Chat'), backgroundColor: Colors.black),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, i) {
                bool isMe = _messages[i]['isMe'];
                return Container(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.blueAccent : Colors.grey[800],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(_messages[i]['text'], style: const TextStyle(color: Colors.white)),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            color: Colors.black,
            child: Row(
              children: [
                Expanded(child: TextField(controller: _ctrl, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(hintText: 'Type message...', border: InputBorder.none))),
                IconButton(icon: const Icon(Icons.send, color: Colors.blueAccent), onPressed: _send),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 4. प्रोफाइल टैब (Profile)
class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('RIIS Profile'), backgroundColor: Colors.black),
      body: Column(
        children: [
          const SizedBox(height: 20),
          const CircleAvatar(radius: 40, backgroundColor: Colors.blueAccent, child: Text('R', style: TextStyle(fontSize: 30, color: Colors.white))),
          const SizedBox(height: 10),
          const Text('Abdulrihan', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
          const Text('Moradabad, India 🚀', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 4, mainAxisSpacing: 4),
              itemCount: 6,
              itemBuilder: (context, index) => Container(color: Colors.grey[850], child: Center(child: Text('Post ${index + 1}', style: const TextStyle(color: Colors.white54)))),
            ),
          ),
        ],
      ),
    );
  }
}
