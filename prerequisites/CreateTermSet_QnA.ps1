#create a term set named QuestionAndAnswerCategory in the QnA term group 

#ask for the requestor's name

#connect-PnPOnline -Url $adminSiteUrl -Interactive -ClientId $PnPClientId


function Create-TermSet {
    param (
        [string]$termGroupName = "QnA",
        [string]$termSetName = "QuestionAndAnswerCategory",
        [string]$termGroupDescription = "Term group for Question and Answer categories",
        [string]$termSetDescription = "Term set for Question and Answer categories",
        [int]$lcid = 1033
    )

    $termGroup = Get-PnPTermGroup -Identity $termGroupName -ErrorAction SilentlyContinue
    if (-not $termGroup) {
        Write-Host "Term group '$termGroupName' not found, creating it new." -ForegroundColor Yellow
        $termGroup = New-PnPTermGroup -Name $termGroupName -Description $termGroupDescription -ErrorAction SilentlyContinue
    }

    $termSet = Get-PnPTermSet -Identity $termSetName -TermGroup $termGroupName -ErrorAction SilentlyContinue
    if ($termSet) {
        Write-Host "Term set '$termSetName' already exists in the term group '$termGroupName'." -ForegroundColor Yellow
        return
    } else {
        $termSet = New-PnPTermSet -Name $termSetName -TermGroup $termGroupName -Description $termSetDescription -Lcid $lcid
        Write-Host "Term set '$termSetName' created in the term group '$termGroupName'." -ForegroundColor Green
    }
    $term = Get-PnPTerm -Identity "dummy" -TermSet $termSetName -TermGroup $termGroupName -ErrorAction SilentlyContinue
    if ($term) {
        Write-Host "Term 'dummy' already exists in the term set '$termSetName'." -ForegroundColor Yellow
    } else {
        $term = New-PnPTerm -Name "dummy" -TermSet $termSetName -TermGroup $termGroupName -ErrorAction SilentlyContinue
        Write-Host "Term 'dummy' created in the term set '$termSetName'." -ForegroundColor Green
    }
}