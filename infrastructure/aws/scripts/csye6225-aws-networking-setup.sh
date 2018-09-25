AWS_REGION="us-east-1"
VPC_NAME="Assignment-1-CLI"
VPC_CIDR="10.0.0.0/16"
SUBNET1_PUBLIC_CIDR="10.0.4.0/24"
SUBNET1_PUBLIC_AZ="us-east-1a"
SUBNET1_PUBLIC_NAME="SUBNET_1 - 10.0.4.0 - us-east-1a"
SUBNET2_PUBLIC_CIDR="10.0.5.0/24"
SUBNET2_PUBLIC_AZ="us-east-1a"
SUBNET2_PUBLIC_NAME="SUBNET_2 - 10.0.5.0 - us-east-1b"
SUBNET3_PUBLIC_CIDR="10.0.6.0/24"
SUBNET3_PUBLIC_AZ="us-east-1a"
SUBNET3_PUBLIC_NAME="SUBNET_2 - 10.0.6.0 - us-east-1c"
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

# Add Name tag to Public Subnet 2
aws ec2 create-tags \
  --resources $SUBNET3_PUBLIC_ID \
  --tags "Key=Name,Value=$SUBNET3_PUBLIC_NAME" \
  --region $AWS_REGION
echo "  Subnet ID '$SUBNET3_PUBLIC_ID' NAMED as" \
  "'$SUBNET3_PUBLIC_NAME'."


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