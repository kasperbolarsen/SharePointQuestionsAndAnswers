# This script will ensure that
# 1. The term store is updated with a new term group and term set
# 2. The required site columns are created in the content type hub
# 3. The content type is created in the content type hub and the site columns are added to it   
# 4. The content type is published 

#$PnPClientId = Read-Host -Prompt "Enter the PnP Client ID (App ID)" 
#$adminSiteUrl = Read-Host -Prompt "Enter the SharePoint Admin Site URL (e.g., https://contoso-admin.sharepoint.com)"
#$contenttypehubUrl = Read-Host -Prompt "Enter the Content Type Hub URL (e.g., https://contoso.sharepoint.com/sites/contenttypehub)"
$PnPClientId = "d7c35d3c-3773-4009-bc67-885da2dd23fa"
$adminSiteUrl = "https://tcwlv-admin.sharepoint.com/"
$contenttypehubUrl = "https://tcwlv.sharepoint.com/sites/contenttypehub"
$termGroupName = "QnA"

Connect-PnPOnline -Url $adminSiteUrl -Interactive -ClientId $PnPClientId -warningAction SilentlyContinue

# Create a term set named QuestionAndAnswerCategory in the QnA term group
Create-TermSet -termGroupName $termGroupName -termSetName "QuestionAndAnswerCategory" -termGroupDescription "Term group for Question and Answer categories" -termSetDescription "Term set for Question and Answer categories" -lcid 1033

# Creates the site columns for the QnA content type 
Connect-PnPOnline -Url $contenttypehubUrl -Interactive -ClientId $PnPClientId
Create-SiteColumns

CreateQnAContenttype

UpdatesSearchSchema


