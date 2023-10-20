resource "aws_instance" "monitored_server" {
  count                = 2
  ami                  = data.aws_ami.ami.id
  instance_type        = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.instance_profile.name
  security_groups      = [aws_security_group.sg.name]

  user_data = file("./scripts/user_data.sh")

  tags = {
    Name = "monitored-server-${count.index + 1}"
  }
}