# Terraform
Lanching a web-server using terra form code
To Use this code.
prerequest are
--> Terraform.exe
          placed in a env variable path
--->AWS Account<----
--> AWS Acess Key
--> AWS Secert Key
--> One Authentation Key to open server like .pem or .ppk

Step -1 #Clone this url
git clone https://github.com/AshokTippaluri/Terraform.git

Step -2 #getting the AWS depencency from internet
terrraform init

Step -3 #Check the Build is correct or not
terraform plan --auto-approve

Step -4 #Creating a build
terraform apply --auto-approve

Step -last #destroy the build
terraform destroy --auto-approve

