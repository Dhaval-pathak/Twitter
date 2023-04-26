import 'package:flutter/material.dart';

import '../models/tweet_model.dart';
import '../services/tweet_service.dart';

class TweetWall extends StatefulWidget {
  @override
  _TweetWallState createState() => _TweetWallState();
}

class _TweetWallState extends State<TweetWall> {
  late final TweetService _tweetService = TweetService();
  late Stream<List<Tweet>> _tweetsStream;

  @override
  void initState() {
    super.initState();
    _tweetsStream = _tweetService.getTweets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tweet Wall'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () {
              setState(() {
                _tweetsStream = _tweetService.getTweetsSortedByAuthor();
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  final authorController = TextEditingController();

                  return AlertDialog(
                    title: const Text('Filter by Author'),
                    content: TextField(
                      controller: authorController,
                      decoration: const InputDecoration(
                        labelText: 'Author',
                      ),
                    ),
                    actions: [
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: const Text('Filter'),
                        onPressed: () {
                          final author = authorController.text;
                          setState(() {
                            _tweetsStream = _tweetService.getTweetsFilteredByAuthor(author);
                          });
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Tweet>>(
        stream: _tweetsStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final tweets = snapshot.data!;

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _tweetsStream = _tweetService.getTweets();
              });
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              // height: 10,
              child: ListView.builder(
                itemCount: tweets.length,
                itemBuilder: (context, index) {
                  final tweet = tweets[index];
                  return Container(
                    width: 500,
                    child: ListTile(
                      title: Text('Tweeted by: ${tweet.author}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 90,
                              child: Text('${tweet.content}')),
                          Text(
                            '12:00 PM',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.favorite_border),
                                onPressed: () {},
                              ),
                              Text(
                                  // '${tweet.likes}'
                                '23'
                              ),
                              IconButton(
                                icon: const Icon(Icons.reply),
                                onPressed: () {},
                              ),
                              Text(
                                  // '${tweet.replies}'
                                '44'
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}