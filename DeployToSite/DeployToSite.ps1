# Dependency: the Contenttype QuestionsAndAnswers must be deployed to the Content Type Hub before running this script. 

$siteUrl = "https://tcwlv.sharepoint.com/sites/STS-104"
$PnPClientId = "d7c35d3c-3773-4009-bc67-885da2dd23fa"
$contenttypehubUrl = "https://tcwlv.sharepoint.com/sites/ContentTypeHub"
#$siteUrl = Read-Host -Prompt "Enter the SharePoint site URL (e.g., https://contoso.sharepoint.com/sites/qa)"
#$PnPClientId = Read-Host -Prompt "Enter the PnP Client ID (App ID)"
#$contenttypehubUrl = Read-Host -Prompt "Enter the Content Type Hub URL (e.g., https://contoso.sharepoint.com/sites/contenttypehub)"

Connect-PnPOnline -Url $contenttypehubUrl -Interactive -ClientId $PnPClientId -warningAction SilentlyContinue
$ctinHub = Get-PnPContentType -Identity "Questions and Answers" -ErrorAction SilentlyContinue


Connect-PnPOnline -Url $siteUrl -Interactive -ClientId $PnPClientId -warningAction SilentlyContinue

#add the list
$ListName = "Questions and Answers"
$List = Get-PnPList -Identity $ListName -ErrorAction SilentlyContinue
if ($List -eq $null) {
    $List = New-PnPList -Title $ListName -Template GenericList -OnQuickLaunch -ErrorAction SilentlyContinue
    Write-Host "List '$ListName' created successfully." -ForegroundColor Green
} else {
    Write-Host "List '$ListName' already exists." -ForegroundColor Yellow
}



#add the content type to the site
Add-PnPContentTypesFromContentTypeHub -ContentTypes "$($ctinHub.Id)" -Site $siteUrl -ErrorAction SilentlyContinue

#enable management of content types in the list
$List.ContentTypesEnabled = $true
$List.Update()
Invoke-PnPQuery -ErrorAction SilentlyContinue

#add the content type to the list
Add-PnPContentTypeToList -List $List -ContentType "Questions and Answers" -ErrorAction SilentlyContinue
#delete the default content type from the list
Remove-PnPContentTypeFromList -List $List -ContentType "Item" -ErrorAction SilentlyContinue

#update the Answer site column to be a rich text field
$fields = Get-PnPProperty -ClientObject $List -Property Fields -ErrorAction SilentlyContinue
$field = $fields | Where-Object { $_.InternalName -eq "QnA_Answer" }
if ($field -ne $null) 
{
    [xml]$schemaXml = $field.SchemaXml
    $schemaXml.Field.SetAttribute("RichTextMode", "FullHtml")
    $schemaXml.Field.SetAttribute("RichText", "TRUE")
    Set-PnPField -List $List -Identity "QnA_Answer" -Values @{SchemaXml=$schemaXml.OuterXml}
    Write-Host "Field 'QnA_Answer' updated successfully." -ForegroundColor Green        
}
else 
{
    Write-Host "Field 'QnA_Answer' not found." -ForegroundColor Red
}




#update the default view of the list to include the new content type columns
$view = Get-PnPView -List $List -Identity "All Items" -ErrorAction SilentlyContinue
if ($view -ne $null) {
    $viewFields = @("QnA_Question", "QnA_Answer", "QnA_ValidFromDate", "QnA_ValidToDate", "QnA_QuestionAndAnswerCategory")
    Set-PnPView -List $List -Identity $view.Title -Fields $viewFields -ErrorAction SilentlyContinue
    Write-Host "View 'All Items' updated successfully." -ForegroundColor Green
} else {
    Write-Host "View 'All Items' not found." -ForegroundColor Red
}

#remove the attachments from the list and hide the content type from the list
$List.ContentTypesEnabled = $false
$List.EnableAttachments = $false
$List.Update()
Invoke-PnPQuery -ErrorAction SilentlyContinue