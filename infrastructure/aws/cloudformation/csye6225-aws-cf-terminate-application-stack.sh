stackname=$1


DeleteOutput=$(aws cloudformation delete-stack --stack-name $stackname)


if [ $? -eq 0 ]; then
	echo "Deleting stack..."
	aws cloudformation wait stack-delete-complete --stack-name $stackname
	echo "Stack Deleted successfully. Stack Id below: "

	echo $DeleteOutput

else
	echo "Error in Deletion of stack"
	echo $DeleteOutput
fi;
