from flask import Flask

from uqauth import global_user, login_required, authorized_access
from uqauth import payload_view, login

app = Flask(__name__)
app.secret_key = 'placeholder secret'
app.context_processor(global_user)
app.url_map.strict_slashes = False

app.add_url_rule('/payload', 'payload', payload_view)
app.add_url_rule('/login', 'login', login)


@app.route('/')
def index():
    return 'Hello World!'


@app.route('/admin')
@authorized_access
def admin():
    return 'Successfully authenticated!'


if __name__ == '__main__':
    app.run()
