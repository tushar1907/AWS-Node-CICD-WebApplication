stackname=$1

DeleteOutput=$(aws cloudformation delete-stack --stack-name $stackname)

if [ $? -eq 0 ]; then
	domain=$(aws route53 list-hosted-zones --query HostedZones[0].Name --output text)
	trimdomain=${domain::-1}
	#s3domain="web-app.$trimdomain"
	s3domain="$trimdomain.csy6225.com"
	echo"S3 bucket: $s3domain"
	#Emptying S3 bucket
	echo "Emptying S3 bucket"
	aws s3 rm s3://$s3domain --recursive
	#Removing S3 bucket
	#echo "Deleting S3 bucket"
	#aws s3 rb s3://$s3domain --force
	
	echo "Deleting stack..."
	aws cloudformation wait stack-delete-complete --stack-name $stackname
	echo "Stack Deleted successfully. Stack Id below: "

	echo $DeleteOutput

else
	echo "Error in Deletion of stack"
	echo $DeleteOutput
fi;
