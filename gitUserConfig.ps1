Param($username,$useremail)
Write-Verbose -Verbose "Running git config username $username"
git config user.name $username
Write-Verbose -Verbose "Running git config useremail $useremail"
git config user.email $useremail

