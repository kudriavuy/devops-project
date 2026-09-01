variable "db_name" {
  type        = string
  default     = "devops_db"
  description = "Назва бази даних"
}

variable "db_user" {
  type        = string
  default     = "postgres"
  description = "Користувач бази даних"
}

variable "db_password" {
  type        = string
  sensitive   = true
  description = "Пароль до бази даних (позначено як sensitive, щоб не відображався у логах)"
}

variable "app_image" {
  type        = string
  default     = "kudriavuy/my-devops-app:latest"
  description = "Образ вебдодатка"
}

variable "app_port" {
  type        = number
  default     = 5000
  description = "Зовнішній порт для Flask"
}