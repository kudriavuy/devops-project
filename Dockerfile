#Беремо легку версію Python як основу
FROM python:3.10-slim

#Вказуємо робочу папку всередині контейнера
WORKDIR /app

#Копіюємо файл із залежностями та встановлюємо їх
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

#Копіюємо весь інший код у контейнер
COPY . .

#Вказуємо, що додаток працює на порту 5000
EXPOSE 5000

#Команда, яка запустить додаток при старті контейнера
CMD ["python", "app.py"]