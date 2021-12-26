#!/bin/bash

echo "Creating VPC..."

aws ec2 create-vpc --cidr-block 192.168.0.0/16 --tag-specifications 'ResourceType=vpc,Tags=[{Key=Name,Value=VPC-dev}]' > /dev/null 2>&1

VPC=$(aws ec2 describe-vpcs --filters 'Name=cidr,Values=192.168.0.0/16' |jq -r '.Vpcs[].VpcId') 


echo "VPC created successfully..."

echo "Your vpcid is = $VPC"


aws ec2 create-subnet --availability-zone-id use1-az1 --cidr-block 192.168.1.0/24 --vpc-id $VPC --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=Public-1}]' > /dev/null 2>&1

echo "First public subnet created...."

aws ec2 create-subnet --availability-zone-id use1-az2 --cidr-block 192.168.2.0/24 --vpc-id $VPC --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=Public-2}]' > /dev/null 2>&1

echo "Second public subnet created...."

aws ec2 create-subnet --availability-zone-id use1-az3 --cidr-block 192.168.3.0/24 --vpc-id $VPC --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=Private-1}]' > /dev/null 2>&1

echo "First private subnet created...."

aws ec2 create-subnet --availability-zone-id use1-az4 --cidr-block 192.168.4.0/24 --vpc-id $VPC --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=Private-2}]' > /dev/null 2>&1

echo "Second private subnet created...."

SUBNETPUB=$(aws ec2 describe-subnets --filters 'Name=cidr-block,Values=192.168.1.0/24'|jq -r '.Subnets[].SubnetId')
SUBPUB=$(aws ec2 describe-subnets --filters 'Name=cidr-block,Values=192.168.2.0/24'|jq -r '.Subnets[].SubnetId')

aws ec2 modify-subnet-attribute --subnet-id $SUBNETPUB --map-public-ip-on-launch
aws ec2 modify-subnet-attribute --subnet-id $SUBPUB --map-public-ip-on-launch

echo "Now public subnet will auto enable public ips...."

aws ec2 create-internet-gateway --tag-specifications 'ResourceType=internet-gateway,Tags=[{Key=Name,Value=vpc-dev-igw}]' > /dev/null 2>&1

echo "Internet gateway created....."

IGW=$(aws ec2 describe-internet-gateways --filter 'Name=tag-key,Values=Name'|jq -r '.InternetGateways[].InternetGatewayId') 


aws ec2 create-route-table --vpc-id $VPC --tag-specifications 'ResourceType=route-table,Tags=[{Key=Name,Value=vpc-dev-rt}]' > /dev/null 2>&1

echo "Route table created....."


aws ec2 attach-internet-gateway --internet-gateway-id $IGW --vpc-id $VPC > /dev/null 2>&1


RT=$(aws ec2 describe-route-tables --filters 'Name=tag-key,Values=Name'|jq -r '.RouteTables[].RouteTableId')


aws ec2 associate-route-table --subnet-id $SUBNETPUB --route-table-id $RT > /dev/null 2>&1
aws ec2 associate-route-table --subnet-id $SUBPUB --route-table-id $RT > /dev/null 2>&1


echo "Associated public subnets to the public route table.."

aws ec2 create-route --route-table-id $RT --destination-cidr-block 0.0.0.0/0 --gateway-id $IGW  > /dev/null 2>&1

echo "Created route for internet gateway...."

echo "Architecture completed....."

echo "You can create instance now...."
