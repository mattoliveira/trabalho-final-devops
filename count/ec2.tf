resource "aws_instance" "web" {
  instance_type = "t3.micro"
  ami           = "${lookup(var.aws_amis, var.aws_region)}"

  count = var.qtd_ec2

  subnet_id              = "${random_shuffle.random_subnet.result[0]}"
  vpc_security_group_ids = ["${aws_security_group.allow-ssh.id}"]
  key_name               = "${var.KEY_NAME}"

  provisioner "file" {
    source = "${path.module}/script.sh"
    destination = "/tmp/script.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/script.sh",
      "sudo /tmp/script.sh"
    ]
  }

  connection {
    user        = "${var.INSTANCE_USERNAME}"
    private_key = "${file("${var.PATH_TO_KEY}")}"
    host = "${self.public_dns}"
  }

  tags = {
    Name = "${format("nginx-%s-%03d" ,"${terraform.workspace}",count.index + 1)}"
  }
}