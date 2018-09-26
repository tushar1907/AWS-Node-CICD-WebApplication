#!/bin/bash
create_vpc = $(aws ec2 create-vpc --cidr-block 10.0.0.0/16)
echo $create_vpc

