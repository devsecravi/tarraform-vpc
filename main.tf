resource  "aws_vpc" "main"{

     cidr_block = var.cidr_block
     instance_tenancy = "default"

     enable_dns_hostnames = "true"

     tags = local.final_vpc_tags
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = local.final_gw_tags

}

resource "aws_subnet" "public" {
  count = length(var.public_cidr_block)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_cidr_block[count.index]
  availability_zone  = local.az_info[count.index]

  tags = merge(
       local.common_tags,
       {
           Name = "${var.project}-${var.env}-public-${local.az_info[count.index]}"
       },
       var.public_subnets
  )
}

resource "aws_subnet" "private" {
  count = length(var.private_cidr_block)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_cidr_block[count.index]
  availability_zone  = local.az_info[count.index]

  tags = merge(
       local.common_tags,
       {
           Name = "${var.project}-${var.env}-private-${local.az_info[count.index]}"
       },
       var.private_subnets
  )
}

resource "aws_subnet" "database" {
  count = length(var.database_cidr_block)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.database_cidr_block[count.index]
  availability_zone  = local.az_info[count.index]

  tags = merge(
       local.common_tags,
       {
           Name = "${var.project}-${var.env}-database-${local.az_info[count.index]}"
       },
       var.database_subnets
  )
}