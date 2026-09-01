terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.0"
    }
  }
}

provider "docker" {}

# 1. Спільна внутрішня мережа
resource "docker_network" "app_net" {
  name = "app_network"
}

# 2. Сховище (Volume) для постійного збереження даних PostgreSQL
resource "docker_volume" "pgdata" {
  name = "postgres_data"
}

# 3. Образ PostgreSQL
resource "docker_image" "postgres" {
  name = "postgres:15-alpine"
}

# 4. Контейнер бази даних
resource "docker_container" "postgres" {
  name  = "postgres_db"
  image = docker_image.postgres.image_id

  env = [
    "POSTGRES_DB=devops_db",
    "POSTGRES_USER=postgres",
    "POSTGRES_PASSWORD=postgres"
  ]

  networks_advanced {
    name = docker_network.app_net.name
  }

  volumes {
    volume_name    = docker_volume.pgdata.name
    container_path = "/var/lib/postgresql/data"
  }
}

# 5. Наш Docker-образ з Docker Hub
resource "docker_image" "app" {
  name         = "kudriavuy/my-devops-app:latest"
  keep_locally = false
}

# 6. Контейнер Flask додатку
resource "docker_container" "app" {
  name  = "flask_app"
  image = docker_image.app.image_id

  ports {
    internal = 5000
    external = 5000
  }

  env = [
    "DB_HOST=postgres_db",
    "DB_NAME=devops_db",
    "DB_USER=postgres",
    "DB_PASSWORD=postgres"
  ]

  networks_advanced {
    name = docker_network.app_net.name
  }

  depends_on = [
    docker_container.postgres
  ]
}