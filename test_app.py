import pytest
from app import app

@pytest.fixture
def client():
    app.config['TESTING'] = True
    with app.test_client() as client:
        yield client

def test_hello_route(client):
    """Перевіряє, чи сервер відповідає статусом 200 та повертає текст."""
    response = client.get('/')
    assert response.status_code == 200
    assert b"Hello" in response.data