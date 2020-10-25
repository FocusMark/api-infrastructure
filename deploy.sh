if [ -z "$deployed_environment" ]
    then 
        echo "\$deployed_environment environment variable is unset!"
        echo "Aborting deployment."
        exit
fi

product_name=$focusmark_productname
cd src

# Deploy certificates
certificates_template='certificates.yaml'
certificates_stackname=focusmark-"$deployed_environment"-cf-api-certificates
echo Deploying the $certificates_stackname stack into $deployed_environment

cfn-lint $certificates_template
aws cloudformation deploy \
    --template-file $certificates_template \
    --stack-name $certificates_stackname \
    --capabilities CAPABILITY_NAMED_IAM \
    --parameter-overrides \
        TargetEnvironment=$deployed_environment \
        ProductName=$product_name

# Deploy the API Gateway Domain
apidomain_template='apigw-domain.yaml'
apidomain_stackname=focusmark-"$deployed_environment"-cf-api-domain

echo Deploying the $apidomain_stackname stack into $deployed_environment
cfn-lint $apidomain_template
aws cloudformation deploy \
    --template-file $apidomain_template \
    --stack-name $apidomain_stackname \
    --capabilities CAPABILITY_NAMED_IAM \
    --parameter-overrides \
        TargetEnvironment=$deployed_environment \
        ProductName=$product_name

# Deploy the Route 53 Hosted Zones
dnsrecords_template='dns-records.yaml'
dnsrecords_stackname=focusmark-"$deployed_environment"-cf-api-dnsrecords

echo Deploying the $dnsrecords_stackname stack into $deployed_environment
cfn-lint $dnsrecords_template
aws cloudformation deploy \
    --template-file $dnsrecords_template \
    --stack-name $dnsrecords_stackname \
    --capabilities CAPABILITY_NAMED_IAM \
    --parameter-overrides \
        TargetEnvironment=$deployed_environment \
        ProductName=$product_name