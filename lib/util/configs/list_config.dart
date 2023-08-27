List<String> sexList = [
  '남성',
  '여성',
];

List<String> dormitoryList = [
  '참빛관',
  '대동관',
  '평화관',
  '새빛관',
  '한빛관',
  '창의관',
  '혜민관',
  '웅비관(특성화캠퍼스)',
  '청운관(특성화캠퍼스)',
];

List<String> studentNumberList =
    List.generate(10, (index) => (23 - index).toString());

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

List<String> essentialList = [
  'nickname',
  'sex',
  'dormitory',
  'studentNumber',
  'major',
  'roommate',
  'confidence',
];

List<String> questionList = [
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
  'etc',
];

List<String> tagList = [
  '전체',
  '흡연',
  '잠버릇',
  '관계',
  '취침시간',
  '방 청소',
  '화장실 청소',
  '초대',
  '공유',
  '전화',
  '이어폰',
  '취식',
  '스탠드',
];

Map<String, List<String>> answerList = {
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
