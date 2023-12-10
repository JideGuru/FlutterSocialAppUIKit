Map<String, dynamic> firebaseVariables = {
  'auth': false,
  'current-semester': '2',
  'current-year': '2023',
};

Map<String, dynamic> firebaseEssentialConsts = {
  'essentialHintTexts': {
    'nickname': [
      '닉네임을 입력해주세요.',
      'Nickname',
    ],
    'major': [
      '단과대학을 알려주세요.',
      'College',
    ],
    'sex': [
      '성별을 알려주세요.',
      'Sex',
    ],
    'studentNumber': [
      '학번을 알려주세요.',
      'Student Number',
    ],
    'dormitory': [
      '입주 예정 호관을 선택해주세요.',
      'Expected Residence Hall',
    ],
  },
  'essentialMaps': {
    'sex': {
      'korean': [
        '남성',
        '여성',
      ],
      'english': [
        'Male',
        'Female',
      ],
    },
    'dormitory': {
      'korean': [
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
      'english': [
        'Chambit',
        'Daedong',
        'Pyeonghwa',
        'Saebit',
        'Hanbit',
        'Changoui',
        'Haemin',
        'Ungbi(specialized campus)',
        'Cheongun(specialized campus)',
      ],
    },
    'major': {
      'korean': [
        '간호대학',
        '공과대학',
        '글로벌융합대학',
        '농업생명과학대학',
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
        '스마트팜학과',
        '한옥학과',
      ],
      'english': [
        'Nursing',
        'Engineering',
        'Global Frontier',
        'Agricultural Life Science',
        'Education',
        'Social Sciences',
        'Commerce',
        'Human Ecology',
        'Veterinary Medicine',
        'Pharmacy',
        'Arts',
        'Medicine',
        'Humanities',
        'Natural Science',
        'Dentistry',
        'Environmental & Bioresource Sciences',
        'Smart Farm',
        'Hanok',
      ],
    },
  },
  'dormitoryList': {
    'korean': {
      'male': [
        '참빛관',
        '대동관',
        '새빛1관',
        '한빛관',
        '창의관',
        '혜민관',
        '웅비관(특성화캠퍼스)',
        '청운관(특성화캠퍼스)',
      ],
      'female': [
        '참빛관',
        '평화관',
        '새빛2관',
        '창의관',
        '혜민관',
        '웅비관(특성화캠퍼스)',
        '청운관(특성화캠퍼스)',
      ],
    },
    'english': {
      'male': [
        'Chambit',
        'Daedong',
        'Saebit-1',
        'Hanbit',
        'Changoui',
        'Haemin',
        'Ungbi(specialized campus)',
        'Cheongun(specialized campus)',
      ],
      'female': [
        'Chambit',
        'Pyeonghwa',
        'Saebit-2',
        'Hanbit',
        'Changoui',
        'Haemin',
        'Ungbi(specialized campus)',
        'Cheongun(specialized campus)',
      ],
    },
  },
};

Map<String, dynamic> firebaseSurveyConsts = {
  'surveyHintTexts': {
    'smoking': [
      '흡연 여부를 알려주세요.',
      'Smoking',
    ],
    'sleepingHabits': [
      '잠버릇을 알려주세요.',
      'Sleeping Habits',
    ],
    'relationship': [
      '룸메이트와 맺고 싶은 관계를 알려주세요.',
      'Relationship',
    ],
    'sleepAt': [
      '취침 시간을 알려주세요.',
      'Sleep At',
    ],
    'roomCleaning': [
      '방 청소 주기를 알려주세요.',
      'Room Cleaning Cycle',
    ],
    'restroomCleaning': [
      '화장실 청소 주기를 알려주세요.',
      'Restroom Cleaning Cycle',
    ],
    'inviting': [
      '초대 선호도를 알려주세요.',
      'Invitation Preference',
    ],
    'sharing': [
      '물건 공유 선호도를 알려주세요.',
      'Sharing Preference',
    ],
    'calling': [
      '실내 통화 선호도를 알려주세요.',
      'Indoor Call Preference',
    ],
    'earphone': [
      '이어폰 사용 선호도를 알려주세요.',
      'Earphone Preference',
    ],
    'eating': [
      '실내 취식 선호도를 알려주세요.',
      'Indoor Eating Preference',
    ],
    'lateStand': [
      '늦은 스탠드 사용 선호도를 알려주세요.',
      'Late Stand Usage Preference',
    ],
  },
  'surveyMaps': {
    'smoking': {
      'korean': [
        '비흡연',
        '흡연',
      ],
      'english': [
        'Non-smoking',
        'smoking',
      ],
    },
    'sleepingHabits': {
      'korean': [
        '없음',
        '가끔 있음',
        '자주 있음',
        '항상 있음',
        '잘 모르겠음',
      ],
      'english': [
        'None',
        'Somtimes',
        'Often',
        'Always',
        "I don't know",
      ],
    },
    'relationship': {
      'korean': [
        '비즈니스 사이',
        '식사 하는 사이',
        '친한 친구 사이',
      ],
      'english': [
        'Business',
        'Eating together somtines',
        'Friendly',
      ],
    },
    'sleepAt': {
      'korean': [
        "오후 11시 이전",
        "오후 11시 ~ 오전 0시",
        "오전 0시 ~ 오전 1시",
        "오전 1시 ~ 오전 2시",
        "오전 2시 ~ 오전 3시",
        "오전 3시 이후",
        "매우 불규칙적인 시간",
      ],
      'english': [
        'Before 11pm',
        '11pm ~ 0am',
        '0am ~ 1am',
        '1am ~ 2am',
        '2am ~ 3am',
        'After 3am',
        'Irregularly',
      ],
    },
    'roomCleaning': {
      'korean': [
        "한달에 한 번 미만",
        "한달에 한 번",
        "격주일에 한 번",
        "일주일에 한 번",
        "일주일에 한 번 이상",
      ],
      'english': [
        'Less than once a month',
        'Once a month',
        'Once two weeks',
        'Once a week',
        'More than once a week',
      ],
    },
    'restroomCleaning': {
      'korean': [
        "한달에 한 번 미만",
        "한달에 한 번",
        "격주일에 한 번",
        "일주일에 한 번",
        "일주일에 한 번 이상",
      ],
      'english': [
        'Less than once a month',
        'Once a month',
        'Once two weeks',
        'Once a week',
        'More than once a week',
      ],
    },
    'inviting': {
      'korean': [
        '선호',
        '비선호',
      ],
      'english': [
        'Preferred',
        'Not preferred',
      ],
    },
    'sharing': {
      'korean': [
        '선호',
        '비선호',
      ],
      'english': [
        'Preferred',
        'Not preferred',
      ],
    },
    'calling': {
      'korean': [
        '선호',
        '비선호',
      ],
      'english': [
        'Preferred',
        'Not preferred',
      ],
    },
    'earphone': {
      'korean': [
        '선호',
        '비선호',
      ],
      'english': [
        'Preferred',
        'Not preferred',
      ],
    },
    'eating': {
      'korean': [
        '선호',
        '비선호',
      ],
      'english': [
        'Preferred',
        'Not preferred',
      ],
    },
    'lateStand': {
      'korean': [
        '선호',
        '비선호',
      ],
      'english': [
        'Preferred',
        'Not preferred',
      ],
    },
  },
};

Map<String, dynamic> firebaseConsts = {
  'app-name': 'Roomie',
  'weak-password': [
    '비밀번호가 취약합니다',
    'Weak password.',
  ],
  'already-registered': [
    '이미 가입된 계정입니다.',
    'Already registered.',
  ],
  'user-not-found': [
    '가입되지 않은 계정입니다.',
    'User not found.',
  ],
  'wrong-password': [
    '틀린 비밀번호입니다.',
    'Wrong password.',
  ],
  'reset-password': [
    '이메일로 비밀번호 재설정 링크를 전송했습니다.',
    'Please check your email to reset your password.',
  ],
  'close': [
    '닫기',
    'Close',
  ],
  'nickname': [
    '닉네임',
    'Your nickname',
  ],
  'korean-or-alphabet': [
    '한글 또는 알파벳으로만 표현해주세요.',
    'Please write in Korean or Alphabet',
  ],
  'less-than-ten': [
    '10 글자 이하로 표현해주세요.',
    'Please write in less than 10 leters',
  ],
  'write-university-email': [
    '학교 이메일 주소를 입력해주세요.',
    'Please fill out the university email'
  ],
  'invalid-email-format': [
    '유효하지 않은 이메일 형식입니다.',
    'Invalid email format',
  ],
  'not-university-email': [
    '학교 이메일 주소가 아닙니다.',
    'Not university email',
  ],
  'invalid-password-format': [
    '유효한 비밀번호를 입력해주세요.',
    'Invalid password format',
  ],
  'incorrect password': [
    '비밀번호가 다릅니다.',
    'Incorrect password',
  ],
  'auth-link': [
    '이메일로 인증 링크를 전송했습니다. 학교 메일 인증을 완료해주세요.',
    'Authentication link sent by email. Please complete the university mail certification.'
  ],
  'auth-link-again': [
    '이메일로 인증 링크를 다시 전송했습니다. 학교 메일 인증을 완료해주세요.',
    'Authentication link was sent back to the email. Please complete the university mail certification.'
  ],
  'forget-password': [
    '비밀번호를 잊으셨나요?',
    'Forget password?',
  ],
  'register': [
    '가입하기',
    'New start',
  ],
  'registered-already': [
    '계정이 있으신가요?',
    'Login',
  ],
  'login': [
    '로그인하기',
    'Login',
  ],
  'university-email': [
    '학교 이메일',
    'University email',
  ],
  'password': [
    '비밀번호',
    'Password',
  ],
  'submit': [
    '제출하기',
    'Submit',
  ],
  'chat': [
    '채팅',
    'Chat',
  ],
  'bookmark': [
    '즐겨찾기',
    'Bookmark',
  ],
  'unbookmark': [
    '즐겨찾기 해제',
    'Unbookmark',
  ],
  'leave': [
    '나가기',
    'Leave this conversation',
  ],
  'type-your-message': [
    '메시지를 작성해주세요.',
    'Please type your message here.',
  ],
  'saved': [
    '저장되었습니다',
    'Saved',
  ],
  'etc': [
    '룸메이트 후보들에게 추가로 전하고 싶은 말을 작성해보세요.',
    'Additional words',
  ],
  'evaluation': [
    '룸메이트는 어땠나요?',
    'How was your roommate?',
  ],
  'roomNumber': [
    '몇번 호실을 사용하셨나요?',
    'Which room did you use?',
  ],
  'recommended-profiles': [
    '추천 프로필',
    'Recommended profiles',
  ],
  'home': [
    '홈',
    'Home',
  ],
  'my-profile': [
    '내 프로필',
    'My profile',
  ],
  'setting': [
    '설정',
    'Setting',
  ],
  'finding': [
    '룸메이트를 구하는 중인가요?',
    'Finding',
  ],
  'yes': [
    '네',
    'Yes',
  ],
  'no': [
    '아니요',
    'No',
  ],
  'modify': [
    '아래에서 설문을 수정할 수 있습니다.',
    'You can modify the surey below.',
  ],
  'details': [
    '자세히 보기',
    'Details',
  ],
  'introduction': [
    '룸메이트 후보들에게 나에 대해 알려주세요.',
    'Please explain yourself to the roommates candidates.',
  ],
  'read': [
    '읽음',
    'read',
  ],
  'commonality': [
    '이런 점이 비슷해요',
    'Comm',
  ],
  'difference': [
    '이런 점이 달라요',
    'Diff',
  ],
  'profile': [
    '프로필',
    'Profile',
  ],
};
