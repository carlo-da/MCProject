import 'package:flutter/material.dart';
import 'widgets/custom_header.dart';
import 'package:http/http.dart' as http;
import 'package:dart_rss/dart_rss.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsFeedScreen extends StatefulWidget {
  const NewsFeedScreen({super.key});

  @override
  State<NewsFeedScreen> createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {
  List<RssItem> _articles = [];
  DateTime? _lastUpdated;
  bool _loading = true;

  final List<String> _rssUrls = [
    "https://www.bleepingcomputer.com/feed/",
    "https://www.csoonline.com/index.rss",
    "https://www.securityweek.com/rss",
  ];

  @override
  void initState() {
    super.initState();
    _fetchAllFeeds();
  }

  Future<void> _fetchAllFeeds() async {
    setState(() {
      _loading = true;
    });

    List<RssItem> allItems = [];

    try {
      for (final url in _rssUrls) {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final feed = RssFeed.parse(response.body);
          allItems.addAll(feed.items);
        }
      }

      // Optional: sort by publication date descending
      allItems.sort((a, b) {
        final dateA = a.pubDate != null ? DateTime.tryParse(a.pubDate!) : null;
        final dateB = b.pubDate != null ? DateTime.tryParse(b.pubDate!) : null;
        if (dateA == null && dateB == null) return 0;
        if (dateA == null) return 1;
        if (dateB == null) return -1;
        return dateB.compareTo(dateA);
      });

      setState(() {
        _articles = allItems;
        _lastUpdated = DateTime.now();
      });
    } catch (e) {
      debugPrint("Error fetching RSS: $e");
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _launchURL(String? url) async {
    if (url != null && await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const CustomHeader(title: "Cybersecurity News"),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              "Get the latest reports and news about cybersecurity and online safety.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: Colors.black54,
              ),
            ),
          ),
          if (_lastUpdated != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                "Last updated: ${_lastUpdated!.hour.toString().padLeft(2, '0')}:${_lastUpdated!.minute.toString().padLeft(2, '0')}:${_lastUpdated!.second.toString().padLeft(2, '0')}",
                style: const TextStyle(fontSize: 12, color: Colors.black45),
              ),
            ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _fetchAllFeeds,
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: _articles.length,
                      itemBuilder: (context, index) {
                        final item = _articles[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: GestureDetector(
                            onTap: () => _launchURL(item.link),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.title ?? "No title",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  if (item.pubDate != null)
                                    Text(
                                      item.pubDate!,
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.black54),
                                    ),
                                  if (item.description != null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        item.description!,
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                ],
                              ),
                            ),
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
