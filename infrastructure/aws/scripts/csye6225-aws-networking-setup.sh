AWS_REGION="us-east-1"
VPC_NAME="Assignment-1-CLI"
VPC_CIDR="10.0.0.0/16"

SUBNET1_PUBLIC_CIDR="10.0.1.0/24"
SUBNET1_PUBLIC_AZ="us-east-1a"
SUBNET1_PUBLIC_NAME="SUBNET_1_PUB - 10.0.1.0 - us-east-1a"
SUBNET1_PRIVATE_CIDR="10.0.2.0/24"
SUBNET1_PRIVATE_AZ="us-east-1a"
SUBNET1_PRIVATE_NAME="SUBNET_1_PRV - 10.0.2.0 - us-east-1a"


SUBNET2_PUBLIC_CIDR="10.0.3.0/24"
SUBNET2_PUBLIC_AZ="us-east-1b"
SUBNET2_PUBLIC_NAME="SUBNET_2_PUB - 10.0.3.0 - us-east-1b"
SUBNET2_PRIVATE_CIDR="10.0.4.0/24"
SUBNET2_PRIVATE_AZ="us-east-1b"
SUBNET2_PRIVATE_NAME="SUBNET_2_PRV - 10.0.4.0 - us-east-1b"


SUBNET3_PUBLIC_CIDR="10.0.5.0/24"
SUBNET3_PUBLIC_AZ="us-east-1c"
SUBNET3_PUBLIC_NAME="SUBNET_3_PUB - 10.0.5.0 - us-east-1c"
SUBNET3_PRIVATE_CIDR="10.0.6.0/24"
SUBNET3_PRIVATE_AZ="us-east-1c"
SUBNET3_PRIVATE_NAME="SUBNET_3_PRV - 10.0.6.0 - us-east-1c"



CHECK_FREQUENCY=5
#
#==============================================================================
#   DO NOT MODIFY CODE BELOW
#==============================================================================
#
# Create VPC
echo "Creating VPC in preferred region..."
VPC_ID=$(aws ec2 create-vpc \
  --cidr-block $VPC_CIDR \
  --query 'Vpc.{VpcId:VpcId}' \
  --output text \
  --region $AWS_REGION)
echo "  VPC ID '$VPC_ID' CREATED in '$AWS_REGION' region."
echo "$VPC_ID">"ID.txt"
# Add Name tag to VPC
aws ec2 create-tags \
  --resources $VPC_ID \
  --tags "Key=Name,Value=$VPC_NAME" \
  --region $AWS_REGION
echo "  VPC ID '$VPC_ID' NAMED as '$VPC_NAME'."

# Create Public Subnet 1
echo "Creating Public Subnet..."
SUBNET1_PUBLIC_ID=$(aws ec2 create-subnet \
  --vpc-id $VPC_ID \
  --cidr-block $SUBNET1_PUBLIC_CIDR \
  --availability-zone $SUBNET1_PUBLIC_AZ \
  --query 'Subnet.{SubnetId:SubnetId}' \
  --output text \
  --region $AWS_REGION)
echo "  Subnet ID '$SUBNET1_PUBLIC_ID' CREATED in '$SUBNET1_PUBLIC_AZ'" \
  "Availability Zone."

# Add Name tag to Public Subnet 1
aws ec2 create-tags \
  --resources $SUBNET1_PUBLIC_ID \
  --tags "Key=Name,Value=$SUBNET1_PUBLIC_NAME" \
  --region $AWS_REGION
echo "  Subnet ID '$SUBNET1_PUBLIC_ID' NAMED as" \
  "'$SUBNET1_PUBLIC_NAME'."

# Create Private Subnet
echo "Creating Private Subnet..."
SUBNET1_PRIVATE_ID=$(aws ec2 create-subnet \
  --vpc-id $VPC_ID \
  --cidr-block $SUBNET1_PRIVATE_CIDR \
  --availability-zone $SUBNET1_PRIVATE_AZ \
  --query 'Subnet.{SubnetId:SubnetId}' \
  --output text \
  --region $AWS_REGION)
echo "  Subnet ID '$SUBNET1_PRIVATE_ID' CREATED in '$SUBNET1_PRIVATE_AZ'" \
  "Availability Zone."

# Add Name tag to Private Subnet
aws ec2 create-tags \
  --resources $SUBNET1_PRIVATE_ID \
  --tags "Key=Name,Value=$SUBNET1_PRIVATE_NAME" \
  --region $AWS_REGION
echo "  Subnet ID '$SUBNET1_PRIVATE_ID' NAMED as '$SUBNET1_PRIVATE_NAME'."


#------------------------------------------------------


  # Create Public Subnet 2
echo "Creating Public Subnet..."
SUBNET2_PUBLIC_ID=$(aws ec2 create-subnet \
  --vpc-id $VPC_ID \
  --cidr-block $SUBNET2_PUBLIC_CIDR \
  --availability-zone $SUBNET2_PUBLIC_AZ \
  --query 'Subnet.{SubnetId:SubnetId}' \
  --output text \
  --region $AWS_REGION)
echo "  Subnet ID '$SUBNET2_PUBLIC_ID' CREATED in '$SUBNET2_PUBLIC_AZ'" \
  "Availability Zone."

# Add Name tag to Public Subnet 2
aws ec2 create-tags \
  --resources $SUBNET2_PUBLIC_ID \
  --tags "Key=Name,Value=$SUBNET2_PUBLIC_NAME" \
  --region $AWS_REGION
echo "  Subnet ID '$SUBNET2_PUBLIC_ID' NAMED as" \
  "'$SUBNET2_PUBLIC_NAME'."

# Create Private Subnet 2
echo "Creating Private Subnet..."
SUBNET2_PRIVATE_ID=$(aws ec2 create-subnet \
  --vpc-id $VPC_ID \
  --cidr-block $SUBNET2_PRIVATE_CIDR \
  --availability-zone $SUBNET2_PRIVATE_AZ \
  --query 'Subnet.{SubnetId:SubnetId}' \
  --output text \
  --region $AWS_REGION)
echo "  Subnet ID '$SUBNET2_PRIVATE_ID' CREATED in '$SUBNET2_PRIVATE_AZ'" \
  "Availability Zone."

# Add Name tag to Private Subnet 2
aws ec2 create-tags \
  --resources $SUBNET2_PRIVATE_ID \
  --tags "Key=Name,Value=$SUBNET2_PRIVATE_NAME" \
  --region $AWS_REGION
echo "  Subnet ID '$SUBNET2_PRIVATE_ID' NAMED as '$SUBNET2_PRIVATE_NAME'."


#------------------------------------------------------


# Create Public Subnet 3
echo "Creating Public Subnet..."
SUBNET3_PUBLIC_ID=$(aws ec2 create-subnet \
  --vpc-id $VPC_ID \
  --cidr-block $SUBNET3_PUBLIC_CIDR \
  --availability-zone $SUBNET3_PUBLIC_AZ \
  --query 'Subnet.{SubnetId:SubnetId}' \
  --output text \
  --region $AWS_REGION)
echo "  Subnet ID '$SUBNET3_PUBLIC_ID' CREATED in '$SUBNET3_PUBLIC_AZ'" \
  "Availability Zone."

# Add Name tag to Public Subnet 3
aws ec2 create-tags \
  --resources $SUBNET3_PUBLIC_ID \
  --tags "Key=Name,Value=$SUBNET3_PUBLIC_NAME" \
  --region $AWS_REGION
echo "  Subnet ID '$SUBNET3_PUBLIC_ID' NAMED as" \
  "'$SUBNET3_PUBLIC_NAME'."

# Create Private Subnet 3
echo "Creating Private Subnet..."
SUBNET3_PRIVATE_ID=$(aws ec2 create-subnet \
  --vpc-id $VPC_ID \
  --cidr-block $SUBNET3_PRIVATE_CIDR \
  --availability-zone $SUBNET3_PRIVATE_AZ \
  --query 'Subnet.{SubnetId:SubnetId}' \
  --output text \
  --region $AWS_REGION)
echo "  Subnet ID '$SUBNET3_PRIVATE_ID' CREATED in '$SUBNET3_PRIVATE_AZ'" \
  "Availability Zone."

# Add Name tag to Private Subnet 3
aws ec2 create-tags \
  --resources $SUBNET3_PRIVATE_ID \
  --tags "Key=Name,Value=$SUBNET3_PRIVATE_NAME" \
  --region $AWS_REGION
echo "  Subnet ID '$SUBNET3_PRIVATE_ID' NAMED as '$SUBNET3_PRIVATE_NAME'."

#---------------------------------------------------------------------------

# Create Internet gateway
echo "Creating Internet Gateway..."
IGW_ID=$(aws ec2 create-internet-gateway \
  --query 'InternetGateway.{InternetGatewayId:InternetGatewayId}' \
  --output text \
  --region $AWS_REGION)
echo "  Internet Gateway ID '$IGW_ID' CREATED."

# Attach Internet gateway to your VPC
aws ec2 attach-internet-gateway \
  --vpc-id $VPC_ID \
  --internet-gateway-id $IGW_ID \
  --region $AWS_REGION
echo "  Internet Gateway ID '$IGW_ID' ATTACHED to VPC ID '$VPC_ID'."

# Create Route Table
echo "Creating Route Table..."
ROUTE_TABLE_ID=$(aws ec2 create-route-table \
  --vpc-id $VPC_ID \
  --query 'RouteTable.{RouteTableId:RouteTableId}' \
  --output text \
  --region $AWS_REGION)
echo "  Route Table ID '$ROUTE_TABLE_ID' CREATED."

# Create route to Internet Gateway
RESULT=$(aws ec2 create-route \
  --route-table-id $ROUTE_TABLE_ID \
  --destination-cidr-block 0.0.0.0/0 \
  --gateway-id $IGW_ID \
  --region $AWS_REGION)
echo "  Route to '0.0.0.0/0' via Internet Gateway ID '$IGW_ID' ADDED to" \
  "Route Table ID '$ROUTE_TABLE_ID'."

# Associate Public Subnet 1 with Route Table
RESULT=$(aws ec2 associate-route-table  \
  --subnet-id $SUBNET1_PUBLIC_ID \
  --route-table-id $ROUTE_TABLE_ID \
  --region $AWS_REGION)
echo "  Public Subnet ID 1 '$SUBNET1_PUBLIC_ID' ASSOCIATED with Route Table ID" \
  "'$ROUTE_TABLE_ID'."

  # Associate Public Subnet 2 with Route Table
RESULT=$(aws ec2 associate-route-table  \
  --subnet-id $SUBNET2_PUBLIC_ID \
  --route-table-id $ROUTE_TABLE_ID \
  --region $AWS_REGION)
echo "  Public Subnet ID 2 '$SUBNET2_PUBLIC_ID' ASSOCIATED with Route Table ID" \
  "'$ROUTE_TABLE_ID'."

  # Associate Public Subnet 3 with Route Table
RESULT=$(aws ec2 associate-route-table  \
  --subnet-id $SUBNET3_PUBLIC_ID \
  --route-table-id $ROUTE_TABLE_ID \
  --region $AWS_REGION)
echo "  Public Subnet ID 3 '$SUBNET3_PUBLIC_ID' ASSOCIATED with Route Table ID" \
  "'$ROUTE_TABLE_ID'."

