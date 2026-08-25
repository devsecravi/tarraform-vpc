variable "project" {
   
     type  = string
}

variable "env" {
     type = string
}

variable "cidr_block" {

     type = string
     default = "10.0.0.0/16"
}

variable "vpc_tags" {
    
      type = map
      default = {}
}

variable "gw_tags" {
    type = map
    default = {}
}

variable "public_cidr_block" {
       type = list
       default = ["10.0.1.0/24","10.0.2.0/24"]
}
variable "private_cidr_block" {
       type = list
       default = ["10.0.11.0/24","10.0.12.0/24"]
}
variable "database_cidr_block" {
       type = list
       default = ["10.0.21.0/24","10.0.22.0/24"]
}

variable "public_subnets"{
    default = {}
}

variable "private_subnets"{
    default = {}
}

variable "database_subnets"{
    default = {}
}

variable "public_route_table" {

       type = map
       default = {}
}

variable "private_route_table" {

       type = map
       default = {}
}

variable "database_route_table" {

       type = map
       default = {}
}

variable "eip_tags"{
     type = map
     default = {}
}

variable "ng_tags" {

       type = map
       default = {}
}

variable "is_peering_connection" {

      type = bool
      default = "false"
}
