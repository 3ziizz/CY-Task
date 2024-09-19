resource "aws_instance" "k8s_worker" {
  count = var.worker_count
  ami           = "ami-066784287e358dad1"
  instance_type =  var.instance_type
  subnet_id     = aws_subnet.private_subnet.id
  key_name      = var.key_name
  vpc_security_group_ids = [ aws_security_group.worker_sg.id ]

  tags = {
    Name = "K8s-Worker"
  }

    user_data              = file("userdata-worker.sh")

}
