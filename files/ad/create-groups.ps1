Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Create groups."
$Groups = Import-CSV "c:\vagrant\files\ad\groups.csv"
foreach ($Group in $Groups) {
    if (-not (Get-ADGroup  -Filter "Name -eq '$($Group.Group)'" -ErrorAction SilentlyContinue)) {
        New-ADGroup -Name $Group.Group -Path $Group.GroupLocation -GroupScope $Group.GroupType -GroupCategory $Group.GroupCategory
        # New-ADGroup -Name $Group.Group -SamAccountName $Group.Name -GroupCategory $Group.GroupCategory -GroupScope $Group.GroupType -DisplayName $Group.Group -Path $Group.GroupLocation -Description "Members of this group are $($Group.Group)"		
    }
    else {
        "Group '$($Group.Group)' already exists"
    }
}