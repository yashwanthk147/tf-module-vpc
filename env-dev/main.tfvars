env = "dev"


vpc = {
  main = {
    vpc_cidr = "172.19.0.0/16"

    public_subnets = {
      public-az1 = {
        name = "public-az1"
        cidr_block = "172.19.0.0/24"
        availability_zone = "ap-south-1a"
      }

      public-az2 = {
        name = "public-az2"
        cidr_block =  "172.19.1.0/24"
        availability_zone = "ap-south-1b"
      }
    }

    private_subnets = {
      pvt-az1-01 = {
        name = "pvt-az1-01"
        cidr_block = "172.19.2.0/24"
        availability_zone = "ap-south-1a"
      }

      pvt-az1-02 = {
        name = "pvt-az1-02"
        cidr_block = "172.19.3.0/24"
        availability_zone = "ap-south-1a"
      }

      pvt-az2-03 = {
        name = "pvt-az2-03"
        cidr_block = "172.19.4.0/24"
        availability_zone = "ap-south-1b"
      }

      pvt-az2-04 = {
        name = "pvt-az2-04"
        cidr_block = "172.19.5.0/24"
        availability_zone = "ap-south-1b"
      }

    }
 }

}