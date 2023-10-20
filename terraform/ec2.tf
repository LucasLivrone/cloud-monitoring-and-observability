resource "aws_instance" "monitored_server" {
  count                = 2
  ami                  = data.aws_ami.ami.id
  instance_type        = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.instance_profile.name
  security_groups      = [aws_security_group.sg.name]

  user_data = <<-EOT
  #!/bin/bash

  # Use the instance hostname in prometheus.yml file so Grafana can differentiate between multiple EC2 hosts
  EC2_HOSTNAME=$(hostname -i)
  sed -i "s/{{EC2_HOSTNAME}}/$EC2_HOSTNAME/g" /home/ec2-user/prometheus.yml

  # Fetch Grafana secrets from AWS Secrets Manager
  GRAFANA_SECRETS=$(aws secretsmanager get-secret-value --secret-id GRAFANA-SECRETS --query SecretString --output text)

  # Parse the JSON and extract specific secrets
  GRAFANA_ENDPOINT=$(jq -r '.GRAFANA_ENDPOINT' <<< "$GRAFANA_SECRETS")
  GRAFANA_USER=$(jq -r '.GRAFANA_USER' <<< "$GRAFANA_SECRETS")
  GRAFANA_PASSWORD=$(jq -r '.GRAFANA_PASSWORD' <<< "$GRAFANA_SECRETS")

  # Update Grafana secrets in prometheus.yml file
  sed -i "s#{{GRAFANA_ENDPOINT}}#$GRAFANA_ENDPOINT#g" /home/ec2-user/prometheus.yml
  sed -i "s/{{GRAFANA_USER}}/$GRAFANA_USER/g" /home/ec2-user/prometheus.yml
  sed -i "s/{{GRAFANA_PASSWORD}}/$GRAFANA_PASSWORD/g" /home/ec2-user/prometheus.yml

  # Run containers
  cd /home/ec2-user/
  sudo docker-compose up -d
  EOT


  tags = {
    Name = "monitored-server-${count.index + 1}"
  }
}