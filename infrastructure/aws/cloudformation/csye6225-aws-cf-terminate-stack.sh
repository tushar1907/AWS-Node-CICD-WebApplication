stackname=$1
createOutput=$(aws cloudformation delete-stack --stack-name $stackname)

if [ $? -eq 0 ]; then
	echo "Deletion stack..."
	aws cloudformation wait stack-delete-complete --stack-name $stackname
	echo "Stack created successfully. Stack Id below: "

	echo $createOutput

else
	echo "Error in creation of stack"
	echo $createOutput
fi;