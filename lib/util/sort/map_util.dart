List<String> getMinValueKeys(Map<String, double> map, int n) {
  if (map.isEmpty) {
    return [];
  }

  // Map을 값 기준으로 오름차순으로 정렬
  var sortedEntries = map.entries.toList()
    ..sort((a, b) => a.value.compareTo(b.value));

  // n보다 작은 값을 사용해야 함
  int count = n < sortedEntries.length ? n : sortedEntries.length;

  // 하위 n개 항목의 key 추출
  List<String> keysWithMinValues =
      sortedEntries.sublist(0, count).map((entry) => entry.key).toList();

  return keysWithMinValues;
}

List<String> getMaxValueKeys(Map<String, double> map, int n) {
  if (map.isEmpty) {
    return [];
  }

  // Map을 값 기준으로 내림차순으로 정렬
  var sortedEntries = map.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));

  // n보다 작은 값을 사용해야 함
  int count = n < sortedEntries.length ? n : sortedEntries.length;

  // 상위 n개 항목의 key 추출
  List<String> keysWithMaxValues =
      sortedEntries.sublist(0, count).map((entry) => entry.key).toList();

  return keysWithMaxValues;
}

double sumMapValues(Map<String, double> map) {
  if (map.isEmpty) {
    return 0;
  }

  double sum = 0;
  map.forEach((key, value) {
    sum += value;
  });

  return sum;
}