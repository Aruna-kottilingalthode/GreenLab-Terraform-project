<powershell>

# Install AWS CLI (Windows)
Invoke-WebRequest "https://awscli.amazonaws.com/AWSCLIV2.msi" -OutFile "C:\AWSCLIV2.msi"
Start-Process msiexec.exe -Wait -ArgumentList '/i C:\AWSCLIV2.msi /quiet'

# Retrieve AD admin password from AWS Secrets Manager
$SecretArn = "${SECRET_ARN}"
$Region = "${AWS_REGION}"

$SecretValue = (aws secretsmanager get-secret-value `
    --secret-id $SecretArn `
    --region $Region `
    --query SecretString `
    --output text)

$AdminPassword = ConvertTo-SecureString $SecretValue -AsPlainText -Force

# Install Active Directory Domain Services
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools

# Create new Active Directory Forest
Install-ADDSForest `
  -DomainName "${domain_name}" `
  -SafeModeAdministratorPassword $AdminPassword `
  -InstallDNS `
  -Force:$true

</powershell>

