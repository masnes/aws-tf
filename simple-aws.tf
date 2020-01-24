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

  # NFS
  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["73.78.216.54/32"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "intraconnected" {
  name        = "intraconnected"
  description = "Allow members to connect to each other"

  # NFS
  ingress {
    from_port = 2049
    to_port   = 2049
    protocol  = "tcp"
    self      = true
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = -1
    self      = true
  }
}


resource "aws_instance" "linux_academy_playground_server" {
  ami             = "ami-047f9f2f5072dd073"
  instance_type   = "a1.medium"
  key_name        = "old-laptop-default"
  security_groups = [aws_security_group.apex_apartment.name, aws_security_group.intraconnected.name]

  root_block_device {
    encrypted = true
  }

  ebs_block_device {
    device_name = "/dev/xvdb"
    volume_size = 30
    encrypted   = true
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    host        = self.public_ip
    private_key = file("/home/masnes/.ssh/id_rsa")
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum -y install vim"
    ]
  }
}

#resource "aws_instance" "linux_academy_playground_client" {
#  ami             = "ami-047f9f2f5072dd073"
#  instance_type   = "a1.medium"
#  key_name        = "old-laptop-default"
#  security_groups = [aws_security_group.apex_apartment.name, aws_security_group.intraconnected.name]
#}


output "conn_serv" {
  value = aws_instance.linux_academy_playground_server.public_dns
}

#output "conn_cli" {
#  value = aws_instance.linux_academy_playground_client.public_dns
#}
