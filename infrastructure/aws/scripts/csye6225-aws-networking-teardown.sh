source ID.txt

aws ec2 delete-subnet --subnet-id $SUBNET1_PUBLIC_ID
aws ec2 delete-subnet --subnet-id $SUBNET2_PUBLIC_ID
aws ec2 delete-subnet --subnet-id $SUBNET3_PUBLIC_ID
aws ec2 delete-subnet --subnet-id $SUBNET1_PRIVATE_ID
aws ec2 delete-subnet --subnet-id $SUBNET2_PRIVATE_ID
aws ec2 delete-subnet --subnet-id $SUBNET3_PRIVATE_ID
aws ec2 delete-route-table --route-table-id $ROUTE_TABLE_ID
aws ec2 detach-internet-gateway --internet-gateway-id $IGW_ID --vpc-id $VPCID
aws ec2 delete-internet-gateway --internet-gateway-id $IGW_ID
aws ec2 delete-vpc --vpc-id $VPCID

rm ID.txt
