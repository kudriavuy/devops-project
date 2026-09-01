output "app_url" {
    value        = "http://localhost:${var.app_port}"
    description  = "Адреса для доступу до додатка"
}

output "prometheus_url" {
    value       = "http://localhost:9090"
    description = "Панель Prometheus"
}

output "grafana_url" {
    value       = "http://localhost:3000"
    description = "Панель Grafana (Логін: admin / Пароль: admin)"
}