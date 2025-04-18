# creating the QuestionsAndAnswers Contenttype in the Content type gallery, adding the site columns


if(-not $contenttypehubUrl)
{
    $contenttypehubUrl = Read-Host -Prompt "Enter the Content Type Hub URL (e.g., https://contoso.sharepoint.com/sites/contenttypehub)"
}
if(-not $PnPClientId)
{
    $PnPClientId = Read-Host -Prompt "Enter the PnP Client ID (App ID)"
}

Connect-PnPOnline -Url $contenttypehubUrl -ClientId $PnPClientId -Interactive

$ct = Get-PnPContentType -Identity "QuestionsAndAnswers" -ErrorAction SilentlyContinue
if($ct -eq $null)
{
    $ct = Add-PnPContentType -Name "QuestionsAndAnswers" -Group "Custom Content Types" -Description "Content type for Questions and Answers"  -ParentContentType (Get-PnPContentType -Identity "0x01") 
}
else
{
    Write-Host "Content type already exists."
}
Set-PnPContentType -Identity $ct -Name "Questions and Answers" -ErrorAction SilentlyContinue
#add the site columns to the content type
$siteColumns = @("QnA_Question", "QnA_Answer", "QnA_ValidFromDate", "QnA_ValidToDate", "QnA_QuestionAndAnswerCategory")
foreach ($siteColumn in $siteColumns) 
{
    $field = Get-PnPField -Identity $siteColumn -ErrorAction SilentlyContinue
    if ($field) {
        Add-PnPFieldToContentType -ContentType $ct -Field $field -ErrorAction SilentlyContinue
        Write-Host "Added site column '$siteColumn' to content type 'QuestionsAndAnswers'." -ForegroundColor Green
    } else {
        Write-Host "Site column '$siteColumn' not found." -ForegroundColor Red
    }
}

#Setting Title to be hidden and not required
$fields = Get-PnPProperty -ClientObject $ct -Property "Fields"
$fields[0].Hidden = $true
$fields[0].Required = $false
$fields[0].Update()
Invoke-PnPQuery -ErrorAction SilentlyContinue

#publish the content type 
Publish-PnPContentType -ContentType $ct

