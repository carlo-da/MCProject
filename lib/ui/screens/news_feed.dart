import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dart_rss/dart_rss.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsFeedScreen extends StatefulWidget {
  @override
  _NewsFeedScreenState createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> with SingleTickerProviderStateMixin {
  List<RssItem> articles = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRSS();
  }

  Future<void> fetchRSS() async {
    final feeds = [
      "https://feeds.feedburner.com/TheHackersNews",
      "https://krebsonsecurity.com/feed/",
      "https://www.darkreading.com/rss.xml",
    ];

    try {
      List<RssItem> allItems = [];
      for (final url in feeds) {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final rssFeed = RssFeed.parse(response.body);
          allItems.addAll(rssFeed.items);
        }
      }

      setState(() {
        articles = allItems.take(20).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      print("Error fetching RSS: $e");
    }
  }

  String getSourceName(RssItem item) {
    if (item.source?.url == "https://feeds.feedburner.com/TheHackersNews") {
      return "The Hacker News";
    } else if (item.source?.url == "https://krebsonsecurity.com/feed/") {
      return "Krebs on Security";
    } else if (item.source?.url == "https://www.darkreading.com/rss.xml") {
      return "Dark Reading";
    }
    return "Unknown";
  }

  Future<void> openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open the article')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cybersecurity News"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: fetchRSS,
              child: ListView.builder(
                padding: EdgeInsets.all(12),
                itemCount: articles.length,
                itemBuilder: (context, index) {
                  final article = articles[index];
                  // Animation: delay each card slightly based on index
                  return TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: Duration(milliseconds: 300 + index * 100),
                    builder: (context, double value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, (1 - value) * 20),
                          child: child,
                        ),
                      );
                    },
                    child: Card(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                      child: ListTile(
                        contentPadding: EdgeInsets.all(12),
                        leading: article.enclosure?.url != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  article.enclosure!.url!,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Icon(Icons.article, color: Colors.lightBlue, size: 50),
                        title: Text(
                          article.title ?? "No title",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 4),
                            Text(
                              article.description ?? "No description",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 6),
                            Text(
                              '${article.pubDate ?? ''} • ${getSourceName(article)}',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                        onTap: () {
                          if (article.link != null) openUrl(article.link!);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
