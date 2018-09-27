stackname=$1
v=$(aws cloudformation delete-stack --stack-name $stackname)
echo $v