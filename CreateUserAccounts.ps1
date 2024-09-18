#Import Active Directory Module
Import-module activedirectory

#Autopopulate Domain
$dnsDomain = $env:userdnsdomain

$split = $dnsDomain.split(".")
$domain = $null
foreach ($part in $split) {
    if ($null -ne $domain) {
        $domain += ","
    }
    $domain += "DC=$part"
}

#Declare any Variables
$dirpath = $pwd.path
$counter = 0

#import CSV File
$ImportFile = Import-csv "$dirpath\ADUsers.csv"
$TotalImports = $importFile.Count

# write-host $TotalImports
# write-host $importFile
# exit

#Create Users
$ImportFile | ForEach-Object {
    $counter++
    New-ADUser -SamAccountName $_."SamAccountName" -Path "OU=Test,OU=DomainUsers,DC=drew,DC=local" -Name $_."Name" -Surname $_."Surname" -GivenName $_."GivenName" -AccountPassword (ConvertTo-SecureString $_."Password" -AsPlainText -Force) -Enabled $true -title $_."title" -officePhone $_."officePhone" -department $_."department" -emailaddress $_."Email" -Description $_."title"
}
