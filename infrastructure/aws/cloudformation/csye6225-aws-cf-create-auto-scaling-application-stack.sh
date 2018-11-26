#!/bin/bash
#Variables

stackname=$1
netstack=$2
#s3domain=$3

sid=$(aws cloudformation describe-stacks --stack-name $netstack --query Stacks[0].StackId --output text)
echo "Stack Id: $sid"
vpc=$(aws ec2 describe-vpcs --filter "Name=tag:aws:cloudformation:stack-id,Values=$sid" --query Vpcs[0].VpcId --output text)
echo "VPC Id: $vpc"
subnet1=$(aws ec2 describe-subnets --filter "Name=tag:Name,Values=$netstack-csye6225-ec2-pub-subnet1" --query Subnets[0].SubnetId --output text)
echo "Subnet-1: $subnet1"
subnet2=$(aws ec2 describe-subnets --filter "Name=tag:Name,Values=$netstack-csye6225-ec2-pub-subnet2" --query Subnets[0].SubnetId --output text)
echo "Subnet-2: $subnet2"
subnet3=$(aws ec2 describe-subnets --filter "Name=tag:Name,Values=$netstack-csye6225-ec2-pub-subnet3" --query Subnets[0].SubnetId --output text)
echo "Subnet-3: $subnet3"
dbsubnet=$(aws rds describe-db-subnet-groups  --query "DBSubnetGroups[?VpcId=='$vpc'].DBSubnetGroupName"  --output text)
echo "DB Subnet Group Name: $dbsubnet"
sglb=$(aws ec2 describe-security-groups --filters "Name=group-name,Values=$netstack-csye6225-lb-secuitygroup" --query SecurityGroups[*].GroupId --output text)
echo "LB SG: $sglb"
sgec2=$(aws ec2 describe-security-groups --filters "Name=group-name,Values=$netstack-csye6225-webapp-secuitygroup" --query SecurityGroups[*].GroupId --output text)
echo "EC2 SG: $sgec2"
sgdb=$(aws ec2 describe-security-groups --filters "Name=group-name,Values=$netstack-csye6225-db-secuitygroup" --query SecurityGroups[*].GroupId --output text)
echo "DB SG: $sgdb"
iaminstance="EC2ToS3BucketInstanceProfile"
echo "Instance Profile Name: $iaminstance"
domain=$(aws route53 list-hosted-zones --query HostedZones[0].Name --output text)
trimdomain=${domain::-1}
s3domain="$trimdomain.csye6225.com"
echo "S3 Bucket: $s3domain"
snstopic=$(aws sns list-topics --query Topics[0] --output text)
echo "SNS Topic arn is" $snstopic
SSLArn=$(aws acm list-certificates --query "CertificateSummaryList[?DomainName=='www.$trimdomain'].CertificateArn" --output text)
echo "SSLArn: $SSLArn"
appname="csye6225CodeDeployApplication"
echo "appname: $appname"
depname="csye6225CodeDeployApplication-depgroup"
echo "depname: $depname"
codeployRole=$(aws iam get-role --role-name CodeDeployServiceRole --query Role.Arn --output text)
echo "CodeDeployServiceRole: $codeployRole"
createOutput=$(aws cloudformation create-stack --stack-name $stackname --template-body file://csye6225-cf-auto-scaling-application.json --parameters ParameterKey=stackname,ParameterValue=$stackname ParameterKey=dbsubnet,ParameterValue=$dbsubnet ParameterKey=s3domain,ParameterValue=$s3domain ParameterKey=ec2Subnet1,ParameterValue=$subnet1 ParameterKey=ec2Subnet2,ParameterValue=$subnet2 ParameterKey=ec2Subnet3,ParameterValue=$subnet3 ParameterKey=ec2SecurityGroup,ParameterValue=$sgec2 ParameterKey=dbSecurityGroupId,ParameterValue=$sgdb ParameterKey=iaminstance,ParameterValue=$iaminstance ParameterKey=domainname,ParameterValue=$trimdomain ParameterKey=snsTopicArn,ParameterValue=$snstopic ParameterKey=sglb,ParameterValue=$sglb ParameterKey=SSLArn,ParameterValue=$SSLArn ParameterKey=vpc,ParameterValue=$vpc ParameterKey=appname,ParameterValue=$appname ParameterKey=depname,ParameterValue=$depname ParameterKey=codeployRole,ParameterValue=$codeployRole)

if [ $? -eq 0 ]; then
	echo "Creating stack..."
	aws cloudformation wait stack-create-complete --stack-name $stackname
	echo "Stack created successfully. Stack Id below: "
	echo $createOutput

else
	echo "Error in creation of stack"
	echo $createOutput
fi;