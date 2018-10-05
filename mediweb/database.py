from json import loads

from functools import partial


def load_users(user_db):
    with open(user_db) as file:
        return loads(file.read())


def _find_user(users, user_id):
    user = users[user_id]
    return user['name'], user['email'], user['authorized']


find_user = partial(_find_user, set(load_users('userdb.json')))


def add_user(payload):
    raise NotImplementedError("for future Brae, with love, past Brae <3")
