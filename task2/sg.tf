resource "aws_security_group" "master_sg" {
  vpc_id = aws_vpc.main_vpc.id
  name   = "CY-master_sg"

  # Allow SSH access to the master node
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Restrict this to your IP for security
  }

  # Allow Kubernetes API access (6443) from the worker node
  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.private_subnet.cidr_block]
  }

  # Allow all egress traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "CY-master-sg"
  }
}

resource "aws_security_group" "worker_sg" {
  vpc_id = aws_vpc.main_vpc.id
  name   = "CY-worker_sg"

  # Allow SSH access from the master node
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.private_subnet.cidr_block]
  }

  # Allow kubelet/kube-proxy to communicate with the master node
  ingress {
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.private_subnet.cidr_block]
  }

  # Allow all egress traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "CY-worker-sg"
  }
}