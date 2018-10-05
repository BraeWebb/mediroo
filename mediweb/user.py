from database import find_user, add_user


class User:
    def __init__(self, user_id):
        self.name, self.email, self.authorized = find_user(user_id)

    @staticmethod
    def register(payload):
        add_user(payload)

    @staticmethod
    def is_registered(user_id):
        return True
