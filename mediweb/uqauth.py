# For accessing uq single sign-on session data
from ast import literal_eval as process_json
# context manager
from functools import wraps

from flask import Flask, flash
from flask import redirect, request, session, abort

from user import User

app = Flask(__name__, static_url_path='/static')


def unauthorized_handler():
    """
    Handles saving the users current page and redirecting to the login page.
    """
    flash('You must be logged in to view that page')
    session['next_url'] = request.path
    return redirect('/login/')


def global_user():
    """
    Process user object for all views to use
    """
    return dict(user=get_current_user())


def get_current_user():
    """
    Process user object for all views to use
    """
    user_id = request.environ.get('HTTP_X_UQ_USER')
    if user_id:
        if User.is_registered(user_id):
            return User(user_id)
        else:
            payload = process_json(request.environ.get('HTTP_X_KVD_PAYLOAD'))
            return User.register(payload)
    else:
        return None


def login_required(func):
    """
    Wrapper for pages which require a logged in user to access.
    """
    @wraps(func)
    def decor(*args, **kwargs):
        if get_current_user() is None:
            return unauthorized_handler()
        else:
            return func(*args, **kwargs)

    return decor


def authorized_access(func):
    """
    Wrapper for pages which require an authorized account to access.
    """
    @wraps(func)
    def decor(*args, **kwargs):
        print(get_current_user())
        if get_current_user() is None:
            return unauthorized_handler()
        elif not get_current_user().authorized:
            return abort(403)
        else:
            return func(*args, **kwargs)

    return decor


def login():
    user_id = request.environ.get('HTTP_X_UQ_USER')
    # If the user is not logged in with UQ Single Sign-on redirect to login
    if user_id:
        # Once the user is logged in, direct to their previous page
        if session.get('next_url'):
            return redirect(session['next_url'])
        else:
            return redirect('/')
    else:
        return redirect('https://api.uqcloud.net/login/https://tilde.uqcloud.net/login')


def payload_view():
    # For debugging purposes
    return request.environ.get('HTTP_X_KVD_PAYLOAD')
