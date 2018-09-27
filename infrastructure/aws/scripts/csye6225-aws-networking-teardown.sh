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

<<<<<<< HEAD
# Delete route table 
for i in `aws ec2 describe-route-tables --filters Name=vpc-id,Values="${vpcid}" | grep rtb- | sed -E 's/^.(rtb-[a-z0-9]+).$/\1/'`; do aws ec2 delete-route-table --route-table-id=$i; done

# Delete route table 
for i in `aws ec2 describe-route-tables --filters Name=vpc-id,Values="${vpcid}" | grep rtb- | sed -E 's/^.*(rtb-[a-z0-9]+).*$/\1/'`; do aws ec2 delete-route-table --route-table-id=$i; done

# Delete subnets
for i in `aws ec2 describe-subnets --filters Name=vpc-id,Values="${vpcid}" | grep subnet- | sed -E 's/^.*(subnet-[a-z0-9]+).*$/\1/'`; do aws ec2 delete-subnet --subnet-id=$i; done

# Detach internet gateways
for i in `aws ec2 describe-internet-gateways --filters Name=attachment.vpc-id,Values="${vpcid}" | grep igw- | sed -E 's/^.*(igw-[a-z0-9]+).*$/\1/'`; do aws ec2 detach-internet-gateway --internet-gateway-id=$i --vpc-id=$vpcid; done

# Delete internet gateways
for i in `aws ec2 describe-internet-gateways --filters Name=attachment.vpc-id,Values="${vpcid}" | grep igw- | sed -E 's/^.*(igw-[a-z0-9]+).*$/\1/'`; do aws ec2 delete-internet-gateway --internet-gateway-id=$i; done

# Delete the VPC
aws ec2 delete-vpc --vpc-id ${vpcid}
=======
>>>>>>> 3c34ae17884aee17bc998e88c82d21856a9c6ba6
rm ID.txt
