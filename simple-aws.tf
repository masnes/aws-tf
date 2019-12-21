provider "aws" {
  profile = "default"
  region  = "us-west-2"
}

resource "aws_key_pair" "standard" {
  key_name   = "old-laptop-default"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDEnjGTmDBk5NmUbZwrr5Ymn+iSHozHWYucBvnew83toQYxC3cNN4qXqI/P4Owa6uYBQSmtUDdg+Ar8NyaW5rH74RuuEeijYEg3cklKv8kKwUQYOyh2+fe9FFB1IVeD5U4rnWFKYt6t2N2BbiqxJfqDMPtrjBEnl9dfBllMQGfpxReAEDRYi22jYgDSg0wBwKnBNYbR8zA42JFnduqYDij6AQVZbC9zrsfkl+Vs4xxuHutmzMARwmjSi45WqE1wD4TxuLWyblzW9CKMz6wcUbbAzHL5dWOUEg3J9x31uU67/mAXW2b1C27FTaOIgKrkVZNjlM9PEpfAPiDkHEm0wslH masnes@arch"
}

resource "aws_security_group" "apex_apartment" {
  name        = "apex_apartment"
  description = "all access needs from my apex apartment"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["73.78.216.54/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "linux_academy_playground" {
  ami             = "ami-047f9f2f5072dd073"
  instance_type   = "a1.medium"
  key_name        = "old-laptop-default"
  security_groups = ["apex_apartment"]
}

output "conn" {
  value = aws_instance.linux_academy_playground.public_dns
}
