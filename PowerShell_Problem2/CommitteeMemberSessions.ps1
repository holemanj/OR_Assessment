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

$CommitteeXML = [xml]$CommitteeResponse.Content
$SessionXML = [xml]$SessionResponse.Content

#Sample fetch
ForEach($Session in $SessionXML.feed.entry) {
    if($Session.content.properties.SessionKey -eq '2025M1') {
        $Session.content.properties.BeginDate.'#text' + ' - ' + $Session.content.properties.EndDate.'#text'
    }
}