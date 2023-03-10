Import-Module ActiveDirectory

#lokalizacja pliku z użytkownikami
$File = "C:\users.txt"

#ścieżka do katalogu users
$Path = "E:\USERS"

#ścieżka do OU w AD
$OUpath= 'OU=Users,OU=TwojeOU,DC=domain,DC=local'

Get-ADUser -Filter * -SearchBase $OUpath | Select -ExpandProperty SamAccountName | Out-File  $File
$Users = Get-Content $File
ForEach ($user in $users)
    {
    $newPath = Join-Path $Path -childpath $user
    $Folder = Test-Path -Path $newPath
    if (-NOT $Folder)
        {
        New-Item $newPath -type directory
        $ACL = Get-Acl -Path $newPath
        $acl.SetAccessRuleProtection($True, $False)
        $acl.Access | %{$acl.RemoveAccessRule($_)}

        #nadanie uprawnień grupie Adminów
        $Admin = "pmrltd.local\PMR_IT"
        $AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule( $Admin, "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
        $ACL.SetAccessRule($AccessRule)
        $ACL | Set-Acl -Path $newPath

        #nadanie uprawnień użytkownikowi
        $AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule( $user, "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
        $ACL.SetAccessRule($AccessRule)
        $ACL | Set-Acl -Path $newPath
       
        #nadanie uprawnień właściciela użytkownikowi
        $Owner = New-Object System.Security.Principal.Ntaccount($user)
        $ACL.SetOwner($Owner)
        $ACL | Set-Acl -Path $newPath
        #Get-ACL -Path $newPath
        }
    }
    #Remove-Item $File
