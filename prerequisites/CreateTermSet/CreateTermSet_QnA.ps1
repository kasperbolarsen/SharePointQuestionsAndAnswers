#create a term set named QuestionAndAnswerCategory in a term group named by the requestor

#ask for the requestor's name

$PnPClientId = Read-Host -Prompt "Enter the PnP Client ID (App ID)" 
$adminSiteUrl = Read-Host -Prompt "Enter the SharePoint Admin Site URL (e.g., https://contoso-admin.sharepoint.com)"
$termGroupName = Read-Host -Prompt "Enter the Term Group Name (e.g., QnA)"
connect-PnPOnline -Url $adminSiteUrl -Interactive -ClientId $PnPClientId

$termGroup = Get-PnPTermGroup -Identity $termGroupName -ErrorAction SilentlyContinue
if(-not $termGroup) {
    Write-Host "Term group '$termGroupName' not found. Please create it first." -ForegroundColor Red
    exit
}

$termSet = Get-PnPTermSet -Identity "QuestionAndAnswerCategory" -TermGroup $termGroupName -ErrorAction SilentlyContinue
if($termSet) {
    Write-Host "Term set 'QuestionAndAnswerCategory' already exists in the term group '$termGroupName'." -ForegroundColor Yellow
    exit
}
    
else {
    $termSet = New-PnPTermSet -Name "QuestionAndAnswerCategory" -TermGroup $termGroupName -Description "Term set for Question and Answer categories" -Lcid 1033 #-IsAvailableForTagging $true
    Write-Host "Term set 'QuestionAndAnswerCategory' created in the term group '$termGroupName'." -ForegroundColor Green
}