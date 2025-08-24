Import-Module ./prerequisites/PreReqActions/CreateTermSet_QnA.ps1
Import-Module ./prerequisites/PreReqActions/CreateQnASiteColumns.ps1
Import-Module ./prerequisites/PreReqActions/CreateQuestionsAndAnswersContenttype.ps1

# This script will ensure that
# 1. The term store is updated with a new term group and term set
# 2. The required site columns are created in the content type hub
# 3. The content type is created in the content type hub and the site columns are added to it   
# 4. The content type is published 

#$PnPClientId = Read-Host -Prompt "Enter the PnP Client ID (App ID)" 
#$adminSiteUrl = Read-Host -Prompt "Enter the SharePoint Admin Site URL (e.g., https://contoso-admin.sharepoint.com)"
#$contenttypehubUrl = Read-Host -Prompt "Enter the Content Type Hub URL (e.g., https://contoso.sharepoint.com/sites/contenttypehub)"
$PnPClientId = "5ae43e12-a26a-4377-957a-14c7f4496326"
$adminSiteUrl = "https://m365x94650063-admin.sharepoint.com/"
$contenttypehubUrl = "https://m365x94650063.sharepoint.com/sites/contenttypehub"
$termGroupName = "QnA"

Connect-PnPOnline -Url $adminSiteUrl -Interactive -ClientId $PnPClientId -warningAction SilentlyContinue

# Call the function to create the term group and term set

Add-TermGroupAndSetAndTerm -termGroupName $termGroupName -termSetName "QuestionAndAnswerCategory" -termGroupDescription "Term group for Question and Answer categories" -termSetDescription "Term set for Question and Answer categories" -lcid 1033



# Creates the site columns for the QnA content type 
Connect-PnPOnline -Url $contenttypehubUrl -Interactive -ClientId $PnPClientId

Create-SiteColumns

CreateQnAContenttype

#UpdatesSearchSchema , not ready for production yet


