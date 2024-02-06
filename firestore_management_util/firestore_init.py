import firebase_admin
from firebase_admin import credentials, firestore
import pandas as pd
import random

cred_path = 'firestore_management_util/roomie-v2-firebase-adminsdk-u8bjm-2609db046f.json'

# Firebase 서비스 계정 키 JSON 파일 경로
cred = credentials.Certificate(cred_path)

# Firebase 앱 초기화
firebase_admin.initialize_app(cred)

# Firestore 클라이언트 초기화
db = firestore.client()

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


def users_v2_init():
  col = db.collection('users-v2')
  for doc in col:
    doc.reference.delete()
  
  col = db.collection('chats-v2')
  for doc in col:
    doc.reference.delete()

def weights_init():
    weights = {}
    for key in answer_list.keys():
        weights[key] = 0
    db.collection('weights').document('weights').update(weights)
    print("가중치가 초기화되었습니다.")
    

weights_init()