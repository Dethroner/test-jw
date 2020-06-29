 # Файл с пользователями должен содержать поля: 
 # username - имя(логин) пользователя # 
 # fullname - полное имя пользователя # 
 # description - описание пользователя # 
 # groups - группа(ы), в которые нужно добавить пользователя(через запятую, без кавычек)
Import-Module ActiveDirectory;

Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Create users & Add to groups."
$Path_to_csv = "c:\vagrant\files\ad\users.csv"
$users = Import-Csv $Path_to_csv -Encoding Default -Delimiter ";" 
foreach ($user in $users) { 
    $username = $user.username 
    $password = $user.password | ConvertTo-SecureString -AsPlainText -Force 
    $description = $user.description
	$fullname = $user.fullname

    New-AdUser -DisplayName $fullname `
        -GivenName $username `
        -Name $fullname `
        -SurName $fullname `
        -SAMAccountName $username `
        -Enabled $True `
        -PasswordNeverExpires $true `
        -UserPrincipalName $username `
        -AccountPassword $password

    $groups = @($user.groups) 
    $grs = $user.groups.split(",") 
    foreach($group in @($grs)) { 
        Add-ADGroupMember -Identity $group -Members $username 
    } 
}
