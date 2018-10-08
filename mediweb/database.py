from json import loads

from functools import partial


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