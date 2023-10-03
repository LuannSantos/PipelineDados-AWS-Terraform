
data "aws_vpc" "default_vpc" {
  default = true
} 


data "aws_route_table" "default_route_table" {
  vpc_id = data.aws_vpc.default_vpc.id
}


resource "aws_vpc_endpoint" "s3" {
  vpc_id       = data.aws_vpc.default_vpc.id
  service_name = "com.amazonaws.us-east-1.s3"

  route_table_ids = [data.aws_route_table.default_route_table.id]
}

