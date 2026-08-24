locals {

        common_tags = {

               project = var.project
               environment = var.env
               terraform = "true"
        }
        az_info= slice(data.aws_availability_zones.available.names,0,2)

        final_vpc_tags = merge(
                local.common_tags,
                {
                    Name = "${var.project}-${var.env}"
                },
                var.vpc_tags
        )
        final_gw_tags = merge(
              local.common_tags,
              {
                    Name = "${var.project}-${var.env}"
              },
              var.gw_tags
        )

}



