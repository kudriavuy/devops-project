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

resource "docker_container" "my_app_container" {
  name  = "terraform-flask-app"
  image = "my-devops-app:latest"

  ports {
    internal = 5000
    external = 5000
  }
}

output "container_status" {
  value       = "Контейнер успішно запущено! Відкрийте: http://localhost:5000"
  description = "Статус розгортання"
}