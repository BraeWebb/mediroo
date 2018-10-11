from flask import Flask, render_template as render, request, jsonify

from uqauth import global_user, login_required, authorized_access
from uqauth import payload_view, login, logout
from database import send_purchase

app = Flask(__name__)
app.secret_key = 'placeholder secret'
app.context_processor(global_user)
app.url_map.strict_slashes = False

app.add_url_rule('/admin/payload', 'payload', payload_view)
app.add_url_rule('/admin/login', 'login', login)
app.add_url_rule('/admin/logout', 'logout', logout)


@app.route('/landing')
def landing():
    return render('landing.html')


@app.route('/purchase')
def purchase():
    return render('purchase.html')


@app.route('/api/purchase', methods=["POST"])
def submit_purchase():
    send_purchase(request.form.get('name'), request.form.get('email'), request.form.get('comments'))
    return jsonify({"message": "Submitted Data"})

@app.route('/api/users')
def get_users():
    return jsonify({
        "users": [{
                "name": "james",
                "email": "james@mediroo.com",
                "registered": 1539129600,
                "comments": "I love Mediroo"
            },
            {
                "name": "Abhi",
                "email": "Abhi@gmail.com",
                "registered": 1538956800,
                "comments": "Best scrum master 2018"
            },
            {
                "name": "nick",
                "email": "nick@gmail.com",
                "registered": 1539275005,
                "comments": "I make websites"
            }
        ]
    })

@app.route('/admin')
#@authorized_access
def admin():
    return render('admin.html')
    #return 'Successfully authenticated!'


if __name__ == '__main__':
    app.run()
