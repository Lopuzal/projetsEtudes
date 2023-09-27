import sqlite3
import init_db
#Toutes les bibliotheques dont nous aurons besoin
from flask import Flask, render_template, request, g, session, redirect, url_for

def get_db_connection():
    conn = sqlite3.connect('database.db')
    conn.row_factory = sqlite3.Row
    return conn

forum = Flask(__name__)
forum.secret_key = 'CLE_NON_SECURISEE'

#Page d'accueil
@forum.route('/', methods=['GET', 'POST'])
def index():
    g.conn = get_db_connection() #Connexion à la base de données

    if request.method == 'POST':
        cur = g.conn.cursor()
        
        if 'username' not in session:
            g.conn.close()
            return render_template('echec_post.html')
        
        #Insère le topic dans la base de données
        cur.execute("INSERT INTO topics (topicname,author) VALUES (?,?)", (request.form['topicname'],session['username']))
        idtopic = cur.lastrowid
        cur.execute("INSERT INTO posts (user,content,idtopic) VALUES (?,?,?)", (session['username'], request.form['content'],idtopic))

        g.conn.commit() #Application des modifications sur la base de données

    #Requete qui récuperère les sujets
    topics = g.conn.execute('SELECT * FROM topics').fetchall()
    g.conn.close()


    return render_template('index.html', topics=topics, session=session)

#Page d'inscription
@forum.route('/inscription', methods=['GET','POST'])
def inscription():
    if request.method == 'POST':
        g.conn = get_db_connection() #Connexion à la base de données

        cur = g.conn.cursor()

        #Insère l'utilisateur et son mot de passe dans la base de données
        cur.execute("INSERT INTO users (username, mdp) VALUES (?, ?)",
            (request.form['username'], request.form['password'])
            )

        g.conn.commit() #Applications des modifications à la base de données
        g.conn.close() #Déconnexion de la base de données
        return render_template('inscription_succes.html')
    else:
        return render_template('inscription.html')

#Page de connexion, redirige vers la page d'accueil un fois connecté
@forum.route('/connexion', methods = ['GET', 'POST'])
def connexion():
    g.conn = get_db_connection() #Connexion à la base de données

    if request.method == 'POST':

        cur = g.conn.cursor()

        #Requête qui récupère l'enregistrement      utilisateur:mot de passe     dans la base de données
        cur.execute("SELECT COUNT(*) FROM users WHERE username = ? and mdp = ?", (request.form['username'],request.form['password']))
        verif_user = cur.fetchone()

        if verif_user[0] == 0:
            g.conn.close()
            return render_template('echec_post.html')

        session['username'] = request.form['username']
        return redirect(url_for('index'))
    return render_template('connexion.html')

#Page de déconnexion, redirige vers la page de connexion si l'utilisateur n'est pas connecté
@forum.route('/deconnexion', methods = ['GET', 'POST'])
def deconnexion():
    if 'username' in session:
        session.pop('username')
    else:
        return redirect(url_for('connexion'))
    return redirect(url_for('index'))

#Page listant les messages d'un sujet, le sujet est passé en paramètre dans l'url "idtopic"
@forum.route('/viewposts', methods=['GET', 'POST'])
def viewposts():
    g.conn = get_db_connection() #Connexion à la base de données

    if request.method == 'POST':
        cur = g.conn.cursor()
        
        #Vérifie si l'utilisateur est bien connecté
        if 'username' not in session:
            g.conn.close()
            return render_template('echec_post.html')
        
        #Insère le post dans la base de données
        cur.execute("INSERT INTO posts (user,content,idtopic) VALUES (?,?,?)", (session['username'],request.form['content'],request.args.get('idtopic')))

        g.conn.commit() #Application des modifications sur la base de données
    
    topicname = g.conn.execute("SELECT topicname FROM topics WHERE id = ?", (request.args.get('idtopic'))).fetchone()[0]
    posts = g.conn.execute("SELECT * FROM posts WHERE idtopic = ?", (request.args.get('idtopic'))).fetchall()
    g.conn.close() #Déconnexion de la base de données
    return render_template('viewposts.html',topicname=topicname, posts=posts, session=session)


if __name__ == "__main__":
    forum.run(host='0.0.0.0', port='5000', debug=True)