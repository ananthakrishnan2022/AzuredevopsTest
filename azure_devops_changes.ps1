$user = "XXXX"
$pass = "YYYYY"

$pair = "$($user):$($pass)"
$encodedCreds = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($pair))
$basicAuthValue = "Basic $encodedCreds"

$Headers = @{
    Authorization = $basicAuthValue
}

$cs = Invoke-RestMethod -Uri "https://dev.azure.com/{organization}/_apis/tfvc/changesets/{id}/changes?api-version=5.1" -Headers $Headers 

$cs.value.ForEach({

$url = "https://dev.azure.com/{organization}/{project}/_apis/tfvc/items?path=$($_.item.path)&api-version=5.1"
$name = $cs.value[0].item.path.Split('/')[$cs.value[0].item.path.Split('/').count -1]
Invoke-RestMethod -Uri $url -ContentType application/octet-stream -Headers $Headers  | Out-File C:\Files\$name

})