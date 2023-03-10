#zmienne globalne

$recipients = "email@reciepient.com"
$subject = "Changes in Admin groups in Active Directory"
$smtp_server = "yoursmtpserver"
$smtp_port = 587
$smtp_username = "smtpuser"
$smtp_password = "password"
$groups = "Administrators", "Domain Admins", "Enterprise Admins", "DHCP Administrators", "DnsAdmins", "Enterprise Key Admins", "Key Admins"

$groups_no = $groups.Count
$old_counts = Import-Clixml -Path "C:\skrypty\admins.xml" | Select-Object -First $groups_no

#liczenie użytkowników w grupie
$new_counts = foreach ($group in $groups) {
    (Get-ADGroupMember $group | Where-Object {$_.objectClass -eq 'user'}).Count
}

$greater = $false
foreach ($i in 0..($new_counts.Length - 1)) {
    if ($new_counts[$i] -ne $old_counts[$i]) {
        $greater = $true
        break
    }

}


if ($greater) {
    $secure_password = ConvertTo-SecureString $smtp_password -AsPlainText -Force
    $smtp_credentials = New-Object System.Management.Automation.PSCredential ($smtp_username, $secure_password)
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    #generowanie listy użytkowników
    $usersList = ""
    foreach ($group in $groups) {
        $users = Get-ADGroupMember -Identity $group | Where-Object {$_.objectClass -eq 'user'}
        $usersList += "<br><b>Użytkownicy w grupie $group :</b><br>"
            foreach ($user in $users) {
            $usersList += $user.Name + "<br>"
        }
    }

    $body = "The number of accounts with Administrator privileges has changed in Active Directory</br>"
    foreach ($i in 0..($new_counts.Length-1)) {
        $body += "count " + $groups[$i] + " to: " + $new_counts[$i] + " previous count: " + $old_counts[$i] + "</br>"
        }
    $body += $usersList
  
     Send-MailMessage -To $recipients -Subject $subject -From $smtp_username -Body $body -SmtpServer $smtp_server -Port $smtp_port -Credential $smtp_credentials -encoding "utf8" -BodyAsHtml
     Export-Clixml -Path "C:\skrypty\admins.xml" -InputObject @($new_counts)
}

