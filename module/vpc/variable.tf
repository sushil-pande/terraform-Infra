variable vpc_cidr_block {
  type = "map"
  default = {
    "dev"   = "10.0.0.0/16"
    //"stage" = "10.20.0.0/16"
    //"prod"  = "10.30.0.0/16"
  }
}

variable public_sub1_cidr_block {
  type = "map"
  default = {
    "dev"   = "10.0.1.0/24"
    //"stage" = "10.20.1.0/24"
    //"prod"  = "10.30.1.0/24"
  }
}

variable public_sub2_cidr_block {
  type = "map"
  default = {
    "dev"   = "10.0.2.0/24"
    //"stage" = "10.20.2.0/24"
    //"prod"  = "10.30.2.0/24"
  }
}

variable private_sub1_cidr_block {
  type = "map"
  default = {
    "dev"   = "10.0.3.0/24"
    //"stage" = "10.20.3.0/24"
    //"prod"  = "10.30.3.0/24"
  }
}

variable private_sub2_cidr_block {
  type = "map"
  default = {
    "dev"   = "10.0.4.0/24"
    //"stage" = "10.20.4.0/24"
    //"prod"  = "10.30.4.0/24"
  }
}

variable "env" {}

variable "region" {}

variable "vpc_id" {}
