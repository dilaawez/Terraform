output "vpc_id" {
  value = aws_vpc.mtc_vpc.id
}

output "vpc_cidr" {
  value = aws_vpc.mtc_vpc.cidr_block
}

output "vpc_subnets" {
  value = {
    "private" = aws_subnet.mtc_private_subnet.id
    "public"  = aws_subnet.mtc_public_subnet.id
  }

  #   {
  #     for subnet in aws_subnet.public :
  #     subnet_id => subnet.cidr_block
  #   }
}

output "aws_private_subnets" {
  value = aws_subnet.mtc_private_subnet

}

output "aws_route_table" {
  value = {
    "private" = aws_route_table.mtc_private_rt.id
    "public"  = aws_route_table.mtc_public_rt.id

  }

}

output "aws_security_group" {
  value   = {
    "name" = aws_security_group.mtc_sg.name
    "ingress" = aws_security_group.mtc_sg.ingress


}
}

output "aws_instance" {
 
  value = {
    "public_ip" = aws_instance.dev_node.public_ip
    "ami"  = aws_instance.dev_node.ami
    "key"  = aws_key_pair.mtckey_auth.public_key
}
}

output "aws_s3_bucket" {
  value = {
    "bucket" = aws_s3_bucket.terraform_backend.bucket
    # "key" = aws_s3_bucket.terraform_backend.key

}
}