import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  late Map<String, dynamic> chatMaps;
  late List<String> orderedEmails;

  Chat.fromFirestore(DocumentSnapshot snapshot) {
    chatMaps = snapshot.data() as Map<String, dynamic>;
    var orderedEmailsOnlyTime = getLateTimeKeys(chatMaps, chatMaps.length);
    List<String> orderedMarkedEmails = [];
    List<String> orderedUnmarkedEmails = [];
    for (var email in orderedEmailsOnlyTime) {
      if (!(chatMaps[email] as Map<String, dynamic>).containsKey('marked')) {
        orderedUnmarkedEmails.add(email);
      } else if (chatMaps[email]['marked'])
        orderedMarkedEmails.add(email);
      else
        orderedUnmarkedEmails.add(email);
    }
    orderedEmails = List.from(orderedMarkedEmails)
      ..addAll(orderedUnmarkedEmails);
  }

  List<String> getLateTimeKeys(Map<String, dynamic> map, int length) {
    List<String> keys = [];
    if (map.isEmpty || map.length < length) return keys;
    var sortedEntries = map.entries.toList()
      ..sort((a, b) {
        var aChats = a.value['chats'] as List;
        var aLatestTime = (aChats.last['time'] as Timestamp).toDate();
        var bChats = b.value['chats'] as List;
        var bLatestTime = (bChats.last['time'] as Timestamp).toDate();

        return bLatestTime.compareTo(aLatestTime);
      });
    keys = sortedEntries.sublist(0, length).map((entry) => entry.key).toList();
    return keys;
  }
}
