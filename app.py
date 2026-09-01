import os
import time
import psycopg2
from flask import Flask

app = Flask(__name__)

DB_HOST = os.environ.get('DB_HOST', 'localhost')
DB_NAME = os.environ.get('DB_NAME', 'devops_db')
DB_USER = os.environ.get('DB_USER', 'postgres')
DB_PASSWORD = os.environ.get('DB_PASSWORD', 'postgres')

def get_db_connection():
    if app.config.get('TESTING'):
        return None

    try:
        conn = psycopg2.connect(
            host=DB_HOST,
            database=DB_NAME,
            user=DB_USER,
            password=DB_PASSWORD
        )
        return conn 
    except Exception as e:
        print(f"БД недоступна: {e}")
        return None

def init_db():
    conn = get_db_connection()
    if conn:
        cur = conn.cursor()
        cur.execute('''
            CREATE TABLE IF NOT EXISTS visits (
                id SERIAL PRIMARY KEY,
                count INTEGER NOT NULL
            );
        ''')
        cur.execute('SELECT COUNT(*) FROM visits;')
        if cur.fetchone()[0] == 0:
            cur.execute('INSERT INTO visits (count) VALUES (0);')
        conn.commit()
        cur.close()
        conn.close()


@app.route('/')
def hello():
    conn = get_db_connection()
    if conn:
        cur = conn.cursor()
        cur.execute('UPDATE visits SET count = count + 1 RETURNING count;')
        count = cur.fetchone()[0]
        conn.commit()
        cur.close()
        conn.close()
        return f"Hello from DevOps Pipeline! Переглядів сторінки: {count}"
    else:
        return "Hello from DevOps Pipeline! (Режим тестування або без БД)"

if __name__ == '__main__':
    time.sleep(2)
    init_db()
    app.run(host='0.0.0.0', port=5000)