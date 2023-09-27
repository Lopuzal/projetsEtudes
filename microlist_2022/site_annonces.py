import sqlite3
import init_db
from flask import Flask, render_template, request, g, session, redirect, url_for

def get_db_connection():
    conn = sqlite3.connect('database.db')
    conn.row_factory = sqlite3.Row
    return conn

site_annonces = Flask(__name__)
site_annonces.secret_key = 'BAD_SECRET_KEY'

#Page d'accueil
@site_annonces.route('/', methods=['GET', 'POST'])
def index():
    g.conn = get_db_connection() #Connexion à la base de données 
    
    #Récupère les annonces selons certains critères
    titre = request.args.get('titre')
    idCategorie = request.args.get('idcat')
    idRegion = request.args.get('idregion')
    ordre = request.args.get('ordre')
    requete = 'SELECT * FROM Annonces WHERE 1'

    if titre not in [None,""]:
        requete += ' AND titre LIKE \'%'+ titre + '%\''
    if idCategorie not in [None,""]:
        requete += ' AND idCategorie=' + idCategorie
    if idRegion not in [None,""]:
        requete += ' AND idRegion=' + idRegion
    if ordre == "0":
        requete += ' ORDER BY prix'
    if ordre == "1":
        requete += 'ORDER BY dateAnnonce'
    
    print(requete)
    annonces = g.conn.execute(requete).fetchall()
    
    categories = g.conn.execute('SELECT * FROM Categories').fetchall()

    regions = g.conn.execute('SELECT * FROM Regions').fetchall()

    g.conn.close()


    return render_template('index.html', annonces=annonces, recherche=titre, categories=categories, regions=regions, session=session)

#Page d'inscription
@site_annonces.route('/inscription', methods=['GET','POST'])
def inscription():
    if request.method == 'POST':
        g.conn = get_db_connection() #Connexion à la base de données

        cur = g.conn.cursor()

        #Insère l'utilisateur et son mot de passe dans la base de données
        cur.execute("INSERT INTO Coordonees (utilisateur, email, mdp, telephone) VALUES (?, ?, ?, ?)",
        (request.form['utilisateur'],request.form['email'] , request.form['mdp'], request.form['telephone']))

        g.conn.commit() #Applications des modifications à la base de données
        g.conn.close() #Déconnexion de la base de données
        return render_template('inscription_succes.html')
    else:
        return render_template('inscription.html')

#Page de connexion, redirige vers la page d'accueil un fois connecté
@site_annonces.route('/connexion', methods = ['GET', 'POST'])
def connexion():
    g.conn = get_db_connection() #Connexion à la base de données
    print("aa")
    if request.method == 'POST':

        cur = g.conn.cursor()

        #Requête qui récupère l'enregistrement      utilisateur:mot de passe     dans la base de données
        cur.execute("SELECT COUNT(*) FROM Coordonees WHERE utilisateur = ? and mdp = ?", (request.form['utilisateur'],request.form['mdp']))
        verif_user = cur.fetchone()

        if verif_user[0] == 0:
            g.conn.close()
            return render_template('echec_post.html')

        session['utilisateur'] = request.form['utilisateur']
        return redirect(url_for('index'))
    return render_template('connexion.html')

#Page de déconnexion, redirige vers la page de connexion si l'utilisateur n'est pas connecté
@site_annonces.route('/deconnexion', methods = ['GET', 'POST'])
def deconnexion():
    if 'utilisateur' in session:
        session.pop('utilisateur')
    else:
        return redirect(url_for('connexion'))
    return redirect(url_for('index'))

#Page pour publier une annonce
@site_annonces.route('/publierannonce', methods=['GET', 'POST'])
def publierannonce():
    g.conn = get_db_connection() #Connexion à la base de données

    if request.method == 'POST':
        cur = g.conn.cursor()
        
        #Vérifie si l'utilisateur est bien connecté
        if 'utilisateur' not in session:
            g.conn.close()
            return render_template('echec_post.html')
        
        #Insère le l'annonce dans la base de données
        cur.execute("INSERT INTO Annonces (titre,ville,description,idRegion,idCategorie,codePostal,auteur,prix) VALUES (?,?,?,?,?,?,?,?)",
        (request.form['titre'],request.form['ville'],request.form['description'],int(request.form['idRegion']),int(request.form['idCategorie']),request.form['codePostal'],session['utilisateur'],request.form['prix']))


        g.conn.commit() #Application des modifications sur la base de données
    
    categories = g.conn.execute("SELECT * FROM Categories").fetchall()
    regions = g.conn.execute("SELECT * FROM Regions").fetchall()
    g.conn.close() #Déconnexion de la base de données
    return render_template('publierannonce.html', categories=categories, regions=regions, session=session)

#Affiche une annonce simple
@site_annonces.route('/voirannonce', methods=['GET', 'POST'])
def voirannonce():
    g.conn = get_db_connection() #Connexion à la base de données
    
    #Recuperation de l'annonce avec l'identifiant idAnnonce
    print(request.args.get('idannonce'))
    annonce = g.conn.execute("SELECT * FROM Annonces NATURAL JOIN Coordonees NATURAL JOIN Categories NATURAL JOIN Regions WHERE idAnnonce=?",(request.args.get('idannonce'),)).fetchone()
    print(annonce)
    g.conn.close() #Déconnexion de la base de données
    return render_template('voirannonce.html', annonce=annonce, session=session)

if __name__ == "__main__":
    site_annonces.run(host='0.0.0.0', port='5000', debug=True)