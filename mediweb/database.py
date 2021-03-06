from functools import partial
from json import loads
from time import time


def send_purchase(name, email, comments, user=None):
    # please forgive me, I swear it's UQClouds fault
    from google.cloud import firestore
    db = firestore.Client.from_service_account_json('mediroo.json')
    collection = db.collection(u'signup')
    collection.add({
       u'name': name,
       u'email': email,
       u'comments': comments,
       u'registered': time(),
       u'user': user
    })


def get_purchases():
    # please forgive me, I swear it's UQClouds fault
    from google.cloud import firestore
    db = firestore.Client.from_service_account_json('mediroo.json')
    collection = db.collection(u'signup')
    docs = collection.get()

    result = []
    for doc in docs:
        result.append(doc.to_dict())

    return result


def load_users(user_db='userdb.json'):
    """Read a json user database file and return a dictionary"""
    with open(user_db) as file:
        return loads(file.read())


def _find_user(users, user_id):
    """Find a user given a [users] dictionary and a [user_id] to search for"""
    if user_id not in users:
        return None

    user = users[user_id]
    return user['name'], user['email'], user['authorized']


find_user = partial(_find_user, load_users())


def add_user(payload):
    raise NotImplementedError("for future Brae, with love, past Brae <3")
