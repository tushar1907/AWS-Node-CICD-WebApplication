source ID.txt
error_exit()
{
    echo "$1" 1>&2
    rm ID.txt
    exit 1
}
#Deleting Public Subnet 1 
if aws ec2 delete-subnet --subnet-id $SUBNET1_PUBLIC_ID; then
    echo " Public Subnet 1 ${SUBNET1_PUBLIC_ID} has been deleted!!"
else    
   error_exit "Unable to delete Public Subnet 1 Please input correct Public Subnet Id!"
fi

#Deleting Public Subnet 2
if aws ec2 delete-subnet --subnet-id $SUBNET2_PUBLIC_ID; then
    echo " Public Subnet 2 ${SUBNET2_PUBLIC_ID} has been deleted!!"
else
    error_exit "Unable to delete Subnet ID ${SUBNET2_PUBLIC_ID}. Please input correct Public Subnet Id!"    
fi

#Deleting Public Subnet 3
if aws ec2 delete-subnet --subnet-id $SUBNET3_PUBLIC_ID; then
    echo " Public Subnet 3 ${SUBNET3_PUBLIC_ID} has been deleted!!"
else
    error_exit "Unable to delete Subnet ID ${SUBNET3_PUBLIC_ID}. Please input correct Public Subnet Id!"
fi
#Deleting Private Subnet 1    
if aws ec2 delete-subnet --subnet-id $SUBNET1_PRIVATE_ID; then  
    echo " Private Subnet 1 ${SUBNET1_PRIVATE_ID} has been deleted!!"
else
    error_exit "Unable to delete Subnet ID ${SUBNET1_PRIVATE_ID}. Please input correct Private Subnet Id!"
fi
#Deleting Private Subnet 2        
if aws ec2 delete-subnet --subnet-id $SUBNET2_PRIVATE_ID; then
    echo " Private Subnet 2 ${SUBNET2_PRIVATE_ID} has been deleted!!"
else
    error_exit "Unable to delete Subnet ID ${SUBNET2_PRIVATE_ID}. Please input correct Private Subnet Id!"
fi   
#Deleting Private Subnet 3   
if aws ec2 delete-subnet --subnet-id $SUBNET3_PRIVATE_ID; then
    echo " Private Subnet 3 ${SUBNET3_PRIVATE_ID} has been deleted!!"
else
    error_exit "Unable to delete Subnet ID ${SUBNET3_PRIVATE_ID}. Please input correct Private Subnet Id!"
fi
 #Deleting Route Table   
if aws ec2 delete-route-table --route-table-id $ROUTE_TABLE_ID; then
    echo "Route  Tabke ${ROUTE_TABLE_ID} has been deleted!!"
else
    error_exit "Unable to delete Route Table ${ROUTE_TABLE_ID}. Please Check the router ID related dependencies!!"
fi
#Detaching Internet Gateway    
if aws ec2 detach-internet-gateway --internet-gateway-id $IGW_ID --vpc-id $VPCID; then
    echo "Internet Gateway ${IGW_ID} is detached from VPC ${VPCID}"
else
    error_exit "Unable to detach Internet Gateway ${IGW_ID}. Please input correct Internet Gateway name!!"
fi
#Deleting Internet Gateway
if aws ec2 delete-internet-gateway --internet-gateway-id $IGW_ID; then
    echo "Internet Gateway ${IGW_ID} has been deleted!!"
else
    error_exit "Unable to delete Internet Gateway ${IGW_ID}. Please input correct Internet Gateway name!!"
fi
#Deleting VPC
if aws ec2 delete-vpc --vpc-id $VPCID; then
    echo "Your VPC ${VPCID} has been deleted!!"
else
    error_exit "Unable to delete VPC ${IGW_ID}. Please input correct Internet Gateway name!!"
fi
#finally removing the temp file
rm ID.txt
