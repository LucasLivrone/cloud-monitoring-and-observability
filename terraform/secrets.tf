resource "aws_secretsmanager_secret" "grafana_secret" {
  name = "GRAFANA-SECRETS"
}

resource "aws_secretsmanager_secret_version" "grafana_secret_version" {
  secret_id = aws_secretsmanager_secret.grafana_secret.id
  secret_string = jsonencode({
    GRAFANA_ENDPOINT = var.grafana_endpoint,
    GRAFANA_USER     = var.grafana_user,
    GRAFANA_PASSWORD = var.grafana_password
  })
}