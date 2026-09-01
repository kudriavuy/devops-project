terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.0"
    }
  }
}

provider "docker" {
  host = "unix:///home/volodymyr/.docker/desktop/docker.sock"
}

# 1. Мережа
resource "docker_network" "app_net" {
  name = "app_network"
}

# 2. Сховище
resource "docker_volume" "pgdata" {
  name = "postgres_data"
}

# 3. Образ PostgreSQL
resource "docker_image" "postgres" {
  name = "postgres:15-alpine"
}

# 4. Контейнер PostgreSQL
resource "docker_container" "postgres" {
  name  = "postgres_db"
  image = docker_image.postgres.image_id

  env = [
    "POSTGRES_DB=${var.db_name}",
    "POSTGRES_USER=${var.db_user}",
    "POSTGRES_PASSWORD=${var.db_password}"
  ]

  networks_advanced {
    name = docker_network.app_net.name
  }

  volumes {
    volume_name    = docker_volume.pgdata.name
    container_path = "/var/lib/postgresql/data"
  }
}

# 5. Образ додатку
resource "docker_image" "app" {
  name         = var.app_image
  keep_locally = false
}

# 6. Контейнер Flask
resource "docker_container" "app" {
  name  = "flask_app"
  image = docker_image.app.image_id

  ports {
    internal = 5000
    external = var.app_port
  }

  env = [
    "DB_HOST=postgres_db",
    "DB_NAME=${var.db_name}",
    "DB_USER=${var.db_user}",
    "DB_PASSWORD=${var.db_password}"
  ]

  networks_advanced {
    name = docker_network.app_net.name
  }

  depends_on = [
    docker_container.postgres
  ]
}