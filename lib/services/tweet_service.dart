import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/tweet_model.dart';

class TweetService {
  final CollectionReference _tweetsCollection =
  FirebaseFirestore.instance.collection('tweets');

  Stream<List<Tweet>> getTweets() {
    return _tweetsCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Tweet.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    });
  }
  // final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
  Stream<List<Tweet>> getTweetsSortedByAuthor() {
    return _tweetsCollection
        .orderBy('author')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Tweet.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    });
  }
  Stream<List<Tweet>> getTweetsFilteredByAuthor(String author) {
    return _tweetsCollection
        .where('author', isEqualTo: author)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Tweet.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    });
  }

  }
