stackname=$1
createOutput=$(aws cloudformation create-stack --stack-name $stackname --template-body file://csye6225-cf-application.json --parameters ParameterKey=stackname,ParameterValue=$stackname)

if [ $? -eq 0 ]; then
<<<<<<< HEAD
	echo "Creating Application stack..."
	aws cloudformation wait stack-create-complete --stack-name $stackname
	echo "Application Stack created successfully. Stack Id below: "
=======
	echo "Creating stack..."
	aws cloudformation wait stack-create-complete --stack-name $stackname
	echo "Stack created successfully. Stack Id below: "
>>>>>>> b50abda88f0af6c378f311fcdcf471cf9e2acf91

	echo $createOutput

else
	echo "Error in creation of stack"
	echo $createOutput
<<<<<<< HEAD
fi;
=======
fi;
>>>>>>> b50abda88f0af6c378f311fcdcf471cf9e2acf91
