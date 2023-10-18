# Create an EC2 role
resource "aws_iam_role" "ec2_role" {
  name = "ec2-secretsmanager-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# Create the instance profile to be assigned to the EC2
resource "aws_iam_instance_profile" "instance_profile" {
  name = "monitoring-instance-profile"
  role = aws_iam_role.ec2_role.name
}


# Create policy to allow EC2 instances to access the secret
resource "aws_iam_policy" "secret_access_policy" {
  name        = "SecretAccessPolicy"
  description = "Policy to allow EC2 instances to access the secret"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "secretsmanager:GetSecretValue",
        Resource = aws_secretsmanager_secret.grafana_secret.arn
      }
    ]
  })
}

# Attach policy to EC2 role
resource "aws_iam_policy_attachment" "attach_secret_policy" {
  name       = "secretsmanager-attachment"
  policy_arn = aws_iam_policy.secret_access_policy.arn
  roles      = [aws_iam_role.ec2_role.name]
}