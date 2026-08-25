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

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

    tags = merge(
          local.common_tags,
          {
              Name = "${var.project}-${var.env}-public"
          },
          var.public_route_table
    )
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

    tags = merge(
          local.common_tags,
          {
              Name = "${var.project}-${var.env}-private"
          },
          var.private_route_table
    )
}

resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id

    tags = merge(
          local.common_tags,
          {
              Name = "${var.project}-${var.env}-database"
          },
          var.database_route_table
    )
}


resource "aws_route_table_association" "public" {
  count = length(var.public_cidr_block)
  subnet_id      = aws_subnet.publi[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count = length(var.private_cidr_block)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "database" {
  count = length(var.database_cidr_block)
  subnet_id      = aws_subnet.database[count.index].id
  route_table_id = aws_route_table.database.id
}

resource "aws_route" "public" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.gw.id
}

resource "aws_eip" "nat" {

  domain   = "vpc"
  tags = merge(

       local.common_tags,
       {
           Name = "${var.project}-{var.env}-nat";
       },
       var.eip_tags
  )
   
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id

  tags = merge(
        local.common_tags,
        {
           Name = "${var.project}-${var.env}"
        },
        var.ng_tags
  )

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.main]
}

