#Fetch web resources
$CommitteeResponse = Invoke-WebRequest -Uri https://api.oregonlegislature.gov/odata/odataservice.svc/CommitteeStaffMembers -UseBasicParsing
If ($CommitteeResponse.StatusCode -ne 200) {
    #Failed to get feed
    Write-Host "Message: $(CommitteeResponse.StatusCode) $(CommitteeResponse.StatusDescription)"
}

$SessionResponse = Invoke-WebRequest -Uri https://api.oregonlegislature.gov/odata/odataservice.svc/LegislativeSessions -UseBasicParsing
If ($SessionResponse.StatusCode -ne 200) {
    #Failed to get feed
    Write-Host "Message: $(SessionResponse.StatusCode) $(SessionResponse.StatusDescription)"
}

#Pull web response content in to XML objects
$CommitteeXML = [xml]$CommitteeResponse.Content
$SessionXML = [xml]$SessionResponse.Content

#Dump list for required results
$CommitteeList = @()

ForEach($CommitteeMember in $CommitteeXML.feed.entry) {
    #Extract required data from Committee member XML object
    #Some last names are null, so set to blank if true
    if($CommitteeMember.content.properties.LastName.null -ne 'true') {
        $LastName = $CommitteeMember.content.properties.LastName
    } else {
        $LastName=""
    }
    $FirstName = $CommitteeMember.content.properties.FirstName

    #Key to access Leg Sessions based on Committee member
    $MemberSessionID = $CommitteeMember.content.properties.SessionKey

    #Extract required data from Leg Session XML object
    $Session = $SessionXML.feed.entry | where {$_.content.properties.SessionKey -eq $MemberSessionID}
    $SessionName = $Session.content.properties.SessionName
    $SessionBegin = $Session.content.properties.BeginDate.'#text'
    $SessionEnd = $Session.content.properties.EndDate.'#text'

    #Only add if not a duplicate
    if(($CommitteeList | where {$_.LastName -eq $LastName -and $_.FirstName -eq $FirstName}).Count -eq 0) {
        $CommitteeList += [PSCustomObject] @{
            'LastName' = $LastName
            'FirstName' = $FirstName
            'Session' = $SessionName
            'Begin' = $SessionBegin
            'End' = $SessionEnd
        }
    }
}

#Sort by Begin time
$FinalList = $CommitteeList | Sort-Object -Property Begin

#Export to CSV
$FinalList | Export-Csv -NoTypeInformation -Path ./Output.csv