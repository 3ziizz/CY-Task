resource "aws_instance" "k8s_master" {
  ami           = "ami-066784287e358dad1"
  subnet_id     = aws_subnet.public_subnet.id
  instance_type =  var.instance_type
  key_name      = var.key_name
  vpc_security_group_ids = [ aws_security_group.master_sg.id ]

  associate_public_ip_address = true

  tags = {
    Name = "CY-K8s-Master"
  }

  user_data  = file("userdata-master.sh")
  
}