stackname=$1
v=$(aws cloudformation create-stack --stack-name $stackname \
--template-body file://csye6225-cf-networking.json --parameters ParameterKey=stackname,ParameterValue=$stackname)
echo $v