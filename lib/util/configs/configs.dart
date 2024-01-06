String appName = '';

Map<String, dynamic> variables = {
  'current-year': '',
  'current-semester': '',
  'auth': false,
};

Map<String, String> consts = {};

List<String> essentialKeys = [
  'status',
  'nickname',
  'major',
  'sex',
  'studentNumber',
  'language',
  'token',
  'notification',
  'designLevel',
  'tag',
  'dormitory',
  'roomNumber',
];

Map<String, String> essentialHintTexts = {
  'nickname': 'nickname hint text',
  'major': 'major hint text',
  'sex': 'sex hint text',
  'studentNumber': 'studentNumber hint text',
  'dormitory': 'dormitory hint text',
};

List<String> surveyKeys = [
  'smoking',
  'sleepingHabits',
  'relationship',
  'sleepAt',
  'roomCleaning',
  'restroomCleaning',
  'inviting',
  'sharing',
  'calling',
  'earphone',
  'eating',
  'lateStand',
];

Map<String, String> surveyHintTexts = {
  'smoking': 'smoking hint text',
  'sleepingHabits': 'sleepingHabits hint text',
  'relationship': 'relationship hint text',
  'sleepAt': 'sleepAt hint text',
  'roomCleaning': 'roomCleaning hint text',
  'restroomCleaning': 'restroomCleaning hint text',
  'inviting': 'inviting hint text',
  'sharing': 'sharing hint text',
  'calling': 'calling hint text',
  'earphone': 'earphone hint text',
  'eating': 'eating hint text',
  'lateStand': 'lateStand hint text',
};

Map<String, List<dynamic>> essentialMaps = {
  'sex': [
    '남성',
    '여성',
  ],
  'dormitory': [
    '참빛관',
    '대동관',
    '평화관',
    '새빛관',
    '한빛관',
    '창의관',
    '혜민관',
    '웅비관(특성화캠퍼스)',
    '청운관(특성화캠퍼스)',
  ],
  'major': [
    '간호대학',
    '공과대학',
    '글로벌융합대학',
    '글로벌프론티어칼리지',
    '농업생명과학대학',
    '법과대학',
    '사범대학',
    '사회과학대학',
    '상과대학',
    '생활과학대학',
    '수의과대학',
    '약학대학',
    '예술대학',
    '의과대학',
    '인문대학',
    '자연과학대학',
    '치과대학',
    '환경생명자원대학'
  ],
  'studentNumber': [],
};

Map<String, List<dynamic>> surveyMaps = {
  'smoking': [
    '비흡연',
    '흡연',
  ],
  'sleepingHabits': [
    '없음',
    '가끔 있음',
    '자주 있음',
    '항상 있음',
    '잘 모르겠음',
  ],
  'relationship': [
    '비즈니스 사이',
    '식사 하는 사이',
    '친한 친구 사이',
  ],
  'sleepAt': [
    "오후 11시 이전",
    "오후 11시 ~ 오전 0시",
    "오전 0시 ~ 오전 1시",
    "오전 1시 ~ 오전 2시",
    "오전 2시 ~ 오전 3시",
    "오전 3시 이후",
    "매우 불규칙적인 시간",
  ],
  'roomCleaning': [
    "한달에 한 번 미만",
    "한달에 한 번",
    "격주일에 한 번",
    "일주일에 한 번",
    "일주일에 한 번 이상",
  ],
  'restroomCleaning': [
    "한달에 한 번 미만",
    "한달에 한 번",
    "격주일에 한 번",
    "일주일에 한 번",
    "일주일에 한 번 이상",
  ],
  'inviting': [
    '선호',
    '비선호',
  ],
  'sharing': [
    '선호',
    '비선호',
  ],
  'calling': [
    '선호',
    '비선호',
  ],
  'earphone': [
    '선호',
    '비선호',
  ],
  'eating': [
    '선호',
    '비선호',
  ],
  'lateStand': [
    '선호',
    '비선호',
  ],
};

List<List<String>> dormitoryList = [
  [
    '참빛관',
    '대동관',
    '새빛1관',
    '한빛관',
    '창의관',
    '혜민관',
    '웅비관(특성화캠퍼스)',
    '청운관(특성화캠퍼스)',
  ],
  [
    '참빛관',
    '평화관',
    '새빛2관',
    '창의관',
    '혜민관',
    '웅비관(특성화캠퍼스)',
    '청운관(특성화캠퍼스)',
  ],
];

List<String> majorList = [
  '간호대학',
  '공과대학',
  '글로벌융합대학',
  '글로벌프론티어칼리지',
  '농업생명과학대학',
  '법과대학',
  '사범대학',
  '사회과학대학',
  '상과대학',
  '생활과학대학',
  '수의과대학',
  '약학대학',
  '예술대학',
  '의과대학',
  '인문대학',
  '자연과학대학',
  '치과대학',
  '환경생명자원대학',
];

List<String> studentNumberList = [];

Map<String, String> tagMaps = {
  'total': '전체',
  'smoking': '흡연',
  'sleepingHabits': '잠버릇',
  'relationship': '관계',
  'sleepAt': '취침시간',
  'roomCleaning': '방 청소',
  'restroomCleaning': '화장실 청소',
  'inviting': '초대',
  'sharing': '공유',
  'calling': '전화',
  'earphone': '이어폰',
  'eating': '취식',
  'lateStand': '스탠드',
};

Map<String, String> detailHintTexts = {
  'email': '계정',
  'nickname': '닉네임',
  'major': '단과대학',
  'sex': '성별',
  'studentNumber': '학번',
  'dormitory': '호관',
  'smoking': '흡연',
  'sleepingHabits': '잠버릇',
  'relationship': '관계',
  'sleepAt': '취침시간',
  'roomCleaning': '방 청소',
  'restroomCleaning': '화장실 청소',
  'inviting': '초대',
  'sharing': '공유',
  'calling': '전화',
  'earphone': '이어폰',
  'eating': '취식',
  'lateStand': '스탠드',
  'etc': '전하고 싶은 말',
};
