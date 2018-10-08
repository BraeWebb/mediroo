from database import find_user, add_user


class User:
    def __init__(self, user_id, name=None, email=None):
        if user_id is not None:
            self.name, self.email, self.authorized = find_user(user_id)
        else:
            self.name, self.email, self.authorized = name, email, False

    @classmethod
    def register(cls, payload):
        return cls(None, name=payload['name'], email=payload['email'])

    @staticmethod
    def is_registered(user_id):
        return find_user(user_id) is not None
