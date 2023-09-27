DROP TABLE IF EXISTS posts;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS topics;

CREATE TABLE posts (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    user INTEGER,
    idtopic INTEGER,
    content TEXT NOT NULL,
    FOREIGN KEY(user) REFERENCES users(username)
    FOREIGN KEY(idtopic) REFERENCES topics(id)
);

CREATE TABLE users (
    username TEXT PRIMARY KEY,
    mdp TEXT NOT NULL
);

CREATE TABLE topics (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    topicname TEXT NOT NULL,
    author TEXT NOT NULL,
    FOREIGN KEY(author) REFERENCES users(username)
)

