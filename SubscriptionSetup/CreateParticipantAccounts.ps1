function Load-Module ($m) {

    # If module is imported say that and do nothing
    if (Get-Module | Where-Object {$_.Name -eq $m}) {
        write-host "Module $m is already imported."
    }
    else {

        # If module is not imported, but available on disk then import
        if (Get-Module -ListAvailable | Where-Object {$_.Name -eq $m}) {
            Import-Module $m -Verbose
        }
        else {

            # If module is not imported, not available on disk, but is in online gallery then install and import
            if (Find-Module -Name $m | Where-Object {$_.Name -eq $m}) {
                Install-Module -Name $m -Force -Verbose -Scope CurrentUser
                Import-Module $m -Verbose
            }
            else {

                # If the module is not imported, not available and not in the online gallery then abort
                write-host "Module $m not imported, not available and not in an online gallery, exiting."
                EXIT 1
            }
        }
    }
}

$defaultPassword = ""
$x = 4
do
    {$x = $x - 1
    if ($x -lt 3){write-host "Not enough characters. Retries remaining: " $x};
    if ($x -le 0) {write-host "Existing build. Please check password and retry..."; Exit};
    $defaultPassword = Read-Host "Please enter a 16 character Password for the user accounts. The password must be between 16 and 128 characters in length and must contain at least one number, one non-alphanumeric character, and one upper or lower case letter" 
    }
while ($defaultPassword.length -le 15)


#logging in 
Write-Host -BackgroundColor Black -ForegroundColor Yellow "Connecting Powershell to your Subscription......................................."
Connect-AzAccount 

# Getting the tenant suffic to create accounts
$subscription = (Get-AzContext).Subscription
$tenantId = $subscription.TenantId
$subscriptionID = $subscription.id
$subscriptionName = $subscription.Name

if(-not $tenantId) {   `
    $subscriptionMessage = "There is no selected Azure tenant. Please use Select-AzSubscription to select a default subscription";  `
    Write-Warning $subscriptionMessage ; return;}  `
else {   `
    $subscriptionMessage = ("Targeting Azure tenant: {0} in subscription  {1} {2}." -f $tenantId, $subscriptionID, $subscriptionName)}
Write-Host -BackgroundColor Black -ForegroundColor Yellow $subscriptionMessage

$tenant = Get-AzTenant -TenantId $tenantId
$domain = $tenant.DefaultDomain

if(-not $domain) {   
    Write-Warning "Cannot get default domain. Exiting" ; return;
}

#Check if AAD module exists, if not install it

Load-Module "AzureAD"

Connect-AzureAD -TenantId $tenantId

Write-Host -BackgroundColor Black -ForegroundColor Yellow ("Domain to be used: {0}" -f $domain)

Write-Host -BackgroundColor Black -ForegroundColor Yellow "Creating Demo accounts"

for ($num = 1 ; $num -le 20 ; $num++) {

    
    $accountname = ("SQLHACK_TEAM{0:00}@{1}" -f $num, $domain)
    
    #Check if user exists
    $user = Get-AzureADUser -Filter ("userPrincipalName eq '{0}'" -f $accountname)
    if ($user) {
        Write-Host -BackgroundColor Black -ForegroundColor Yellow ("User {0} exists, doing nothing" -f $accountname)
    }
    else {
        Write-Host -BackgroundColor Black -ForegroundColor Yellow ("Creating user {0}" -f $accountname)

        $PasswordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
        $PasswordProfile.Password = $defaultPassword
        $PasswordProfile.ForceChangePasswordNextLogin = $false

        $params = @{
        AccountEnabled = $true
        DisplayName = ("SQL Hack Team {0:00}" -f $num)
        PasswordProfile = $PasswordProfile
        UserPrincipalName = $accountname
        MailNickname = ("SQLHACK_TEAM{0:00}" -f $num)
        }
        New-AzureADUser @params

        $user = Get-AzureADUser -Filter ("userPrincipalName eq '{0}'" -f $accountname)
        if ($user) {
            Write-Host -BackgroundColor Black -ForegroundColor Yellow ("Successfully created {0}" -f $accountname)
            Start-Sleep 10

        }
        else {
            Write-Warning ("Failed to create {0}" -f $accountname)
        }
    }
    if ($user) {
        $ra = Get-AzRoleAssignment -ObjectId $user.ObjectId -RoleDefinitionName "Contributor" -Scope ("/subscriptions/{0}" -f $subscriptionID)
        if ( $ra -eq $null) {
            Write-Host -BackgroundColor Black -ForegroundColor Yellow "Assigning contributor permissions"
            New-AzRoleAssignment -ObjectId $user.ObjectId -RoleDefinitionName "Contributor" -Scope ("/subscriptions/{0}" -f $subscriptionID)
        }
    }


}

 

