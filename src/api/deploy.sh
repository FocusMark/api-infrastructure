product_name=$focusmark_productname

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
apidomain_stackname=focusmark-"$deployed_environment"-cf-apigw-domain

echo Deploying the $apidomain_stackname stack into $deployed_environment
cfn-lint $apidomain_template
aws cloudformation deploy \
    --template-file $apidomain_template \
    --stack-name $apidomain_stackname \
    --capabilities CAPABILITY_NAMED_IAM \
    --parameter-overrides \
        TargetEnvironment=$deployed_environment \
        ProductName=$product_name

# Deploy the Route 53 Hosted Zone sub-domain for API
dnsrecords_template='api-dns.yaml'
dnsrecords_stackname=focusmark-"$deployed_environment"-cf-api-dns

echo Deploying the $dnsrecords_stackname stack into $deployed_environment
cfn-lint $dnsrecords_template
aws cloudformation deploy \
    --template-file $dnsrecords_template \
    --stack-name $dnsrecords_stackname \
    --capabilities CAPABILITY_NAMED_IAM \
    --parameter-overrides \
        TargetEnvironment=$deployed_environment \
        ProductName=$product_name
        
# Map the API subdomain to the project API Gateway Custom Domain
projectapi_dnsrecords_template='project-apigw.yaml'
projectapi_dnsrecords_stackname=focusmark-"$deployed_environment"-cf-api-dns-project

echo Deploying the $projectapi_dnsrecords_stackname stack into $deployed_environment
cfn-lint $projectapi_dnsrecords_template
aws cloudformation deploy \
    --template-file $projectapi_dnsrecords_template \
    --stack-name $projectapi_dnsrecords_stackname \
    --capabilities CAPABILITY_NAMED_IAM \
    --parameter-overrides \
        TargetEnvironment=$deployed_environment \
        ProductName=$product_name
        
# Map the API subdomain to the task API Gateway Custom Domain
taskapi_dnsrecords_template='task-apigw.yaml'
taskapi_dnsrecords_stackname=focusmark-"$deployed_environment"-cf-api-dns-task

echo Deploying the $taskapi_dnsrecords_stackname stack into $deployed_environment
cfn-lint $taskapi_dnsrecords_template
aws cloudformation deploy \
    --template-file $taskapi_dnsrecords_template \
    --stack-name $taskapi_dnsrecords_stackname \
    --capabilities CAPABILITY_NAMED_IAM \
    --parameter-overrides \
        TargetEnvironment=$deployed_environment \
        ProductName=$product_name