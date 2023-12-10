import firebase_admin
from firebase_admin import credentials, firestore
import pandas as pd
import random

cred_path = '/Users/rkdbg/Codes/Roomie_util/roomie-v2-firebase-adminsdk-u8bjm-7308e3d665.json'
csv_file_path = '/Users/rkdbg/Codes/Roomie_util/lifePattern.csv'

# Firebase 서비스 계정 키 JSON 파일 경로
cred = credentials.Certificate(cred_path)

# Firebase 앱 초기화
firebase_admin.initialize_app(cred)

# Firestore 클라이언트 초기화
db = firestore.client()

# CSV 파일 경로
csv = csv_file_path

# CSV 파일 읽기
data = pd.read_csv(csv)

answer_list = {
    'smoking': [
    '비흡연',
    '흡연',
  ],
  'sleepingHabits': [
    '없음',
    '가끔 있음',
    '자주 있음',
    '항상',
    '본인이 잠버릇이 있는지 잘 모르겠음',
  ],
  'relationship': [
    '비즈니스 관계',
    '의무식 or 야식 같이 먹는 정도',
    '친한 친구',
  ],
  'sleepAt': [
    "22:00 ~ 23:00",
    "23:00 ~ 00:00",
    "00:00 ~ 01:00",
    "01:00 ~ 02:00",
    "02:00 ~ 04:00",
    "04:00 이후",
    "매우 불규칙적",
  ],
  'roomCleaning': [
    "한달에 1번",
    "2주에 1번",
    "일주일에 1~2번",
    "일주일에 3번 이상",
    "매일",
  ],
  'restroomCleaning': [
    "한달에 1번",
    "2주에 1번",
    "일주일에 1~2번",
    "일주일에 3번 이상",
    "매일",
  ],
  'inviting': [
    '가능',
    '불가능',
  ],
  'sharing': [
    '가능',
    '불가능',
  ],
  'calling': [
    '가능',
    '불가능',
  ],
  'earphone': [
    '가능',
    '불가능',
  ],
  'eating': [
    '가능',
    '불가능',
  ],
  'lateStand': [
    '가능',
    '불가능',
  ],
}

csv_fields = ['name', 'sex', 'dormitory', 'college', 'smoking', 'sleeping_habit', 'sleeptime', 'cleaning', 'relationship', 'room_eating', 'room_share', 'room_call', 'room_earphone', 'room_stand', 'room_invite',]
firestore_fields = ['nickname', 'sex', 'dormitory', 'major', 'smoking', 'sleepingHabits', 'sleepAt', 'roomCleaning', 'relationship', 'eating', 'sharing', 'calling', 'earphone', 'lateStand', 'inviting',]

def random_answer(key):
    return random.randint(0, answer_list[key].__len__() - 1)

def users_v2_init():
  for index, row in data.iterrows():
      survey = {}
      for c, f in zip(csv_fields, firestore_fields):
          survey[f] = row[c]
          if f in answer_list: 
              if survey[f] in answer_list[f]:  survey[f] = answer_list[f].index(survey[f])
              else: survey[f] = random_answer(f)

      survey['restroomCleaning'] = survey['roomCleaning']
      survey['etc'] = 'from CSV'
      survey['tag'] = 0
      survey['studentNumber'] = str(random.randint(18, 23))

      if survey['sex'] == '남성': survey['sex'] = 0
      else : survey['sex'] = 1


      # db.collection('users-v2').document(f"{survey['nickname']}@jbnu.ac.kr").set({})
      # db.collection('chats').document(f"{survey['nickname']}@jbnu.ac.kr").set({})

      db.collection('users-v2').document(f"{survey['nickname']}@jbnu.ac.kr").update({
          f"2023.2.me" : survey
      })
  print("데이터가 Firestore에 저장되었습니다.")

def users_v2_set(email):
    db.collection('users-v2').document(email).set({})

def weights_init():
    weights = {}
    for key in answer_list.keys():
        weights[key] = 0
    db.collection('weights').document('weights').update(weights)
    print("가중치가 초기화되었습니다.")