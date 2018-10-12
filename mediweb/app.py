from flask import Flask, render_template as render, request, jsonify
from flask_cors import CORS, cross_origin

from uqauth import global_user, login_required, authorized_access
from uqauth import payload_view, login, logout
from database import send_purchase, get_purchases

app = Flask(__name__)
app.secret_key = 'placeholder secret'
app.context_processor(global_user)
app.url_map.strict_slashes = False
cors = CORS(app, resources={r"/api": {"origins": "*"}})
app.config['CORS_HEADERS'] = 'Content-Type'

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
@cross_origin(origin='*', headers=['Content- Type', 'Authorization'])
def submit_purchase():
    send_purchase(request.form.get('name'), request.form.get('email'), request.form.get('comments'))
    return jsonify({"message": "Submitted Data"})


@app.route('/api/users')
@cross_origin(origin='*', headers=['Content- Type', 'Authorization'])
def get_users():
    return jsonify({
        "users": get_purchases()
    })

@app.route('/admin')
#@authorized_access
def admin():
    return render('admin.html')


if __name__ == '__main__':
    app.run()
