import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dart_rss/dart_rss.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'widgets/custom_header.dart';

class NewsFeedScreen extends StatefulWidget {
  const NewsFeedScreen({super.key});

  @override
  _NewsFeedScreenState createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {
  List<RssItem> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadCachedArticles(); // load cached first
    _fetchRSS(); // then fetch latest
  }

  Future<void> _loadCachedArticles() async {
    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString('cachedArticles');
    if (cached != null) {
      final List decoded = jsonDecode(cached);
      setState(() {
        _items = decoded.map((e) => RssItem(
              title: e['title'],
              link: e['link'],
              pubDate: e['pubDate'],
            )).toList();
        _loading = false;
      });
    }
  }

  Future<void> _fetchRSS() async {
    const feedUrl = "https://feeds.feedburner.com/TheHackersNews";
    try {
      final response = await http.get(Uri.parse(feedUrl));
      if (response.statusCode == 200) {
        final rssFeed = RssFeed.parse(response.body);
        setState(() {
          _items = rssFeed.items;
          _loading = false;
        });

        // cache the articles
        final prefs = await SharedPreferences.getInstance();
        prefs.setString(
            'cachedArticles',
            jsonEncode(rssFeed.items.map((item) => {
                  'title': item.title,
                  'link': item.link,
                  'pubDate': item.pubDate,
                }).toList()));
      } else {
        setState(() {
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _openLink(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const CustomHeader(title: "Cybersecurity News"),
          Expanded(
            child: _loading && _items.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _fetchRSS,
                    child: ListView.builder(
                      itemCount: _items.length,
                      itemBuilder: (context, index) {
                        final item = _items[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 3,
                          child: ListTile(
                            title: Text(
                              item.title ?? "No title",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87),
                            ),
                            subtitle: Text(
                              item.pubDate ?? "",
                              style: const TextStyle(color: Colors.black54),
                            ),
                            onTap: () {
                              if (item.link != null) {
                                _openLink(item.link!);
                              }
                            },
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
