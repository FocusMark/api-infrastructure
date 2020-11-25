if [ -z "$deployed_environment" ]
    then 
        echo "\$deployed_environment environment variable is unset!"
        echo "Aborting deployment."
        exit
fi

cd src/api
echo Deploying API DNS
sh deploy.sh
cd ../..

cd src/auth
echo Deploying Auth DNS
sh deploy.sh
cd ../..