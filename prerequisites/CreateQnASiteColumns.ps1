#creates the site columns for the QnA content type



function Create-SiteColumns {
    
    


function Create-SiteColumn {
    param (
        [string]$siteColumnName,
        [string]$siteColumnInternalName,
        [string]$siteColumnType,
        [string]$termSetName,
        [string]$termGroupName
    )

    $siteColumn = Get-PnPField -Identity $siteColumnName -ErrorAction SilentlyContinue
    if ($siteColumn.InternalName -eq $siteColumnInternalName) {
        Write-Host "Site column '$siteColumnName' already exists." -ForegroundColor Yellow
    } else {
        if($siteColumnType -eq "TaxonomyFieldType") 
        {
            $TermSetPath = "$termGroupName|$termSetName"
            Add-PnPTaxonomyField -DisplayName $siteColumnName -InternalName $siteColumnInternalName -Group "QnA" -AddToDefaultView -TermSetPath $TermSetPath  -ErrorAction stop
            $siteColumn = Get-PnPField -Identity $siteColumnName -ErrorAction SilentlyContinue
        }
        else 
        {
            $siteColumn = Add-PnPField -DisplayName $siteColumnName -InternalName $siteColumnInternalName -Type $siteColumnType -Group "QnA" -AddToDefaultView  -ErrorAction Stop
            if ($siteColumn) {
                Write-Host "Site column '$siteColumnName' created successfully." -ForegroundColor Green
            } else {
                Write-Host "Failed to create site column '$siteColumnName'." -ForegroundColor Red
            }    
        }
        
    }
}
Create-SiteColumn -siteColumnName "Question" -siteColumnInternalName "QnA_Question" -siteColumnType "Note"
Create-SiteColumn -siteColumnName "Answer" -siteColumnInternalName "QnA_Answer" -siteColumnType "Note"
Create-SiteColumn -siteColumnName "ValidFromDate" -siteColumnInternalName "QnA_ValidFromDate" -siteColumnType "DateTime" 
Create-SiteColumn -siteColumnName "ValidToDate" -siteColumnInternalName "QnA_ValidToDate" -siteColumnType "DateTime" 
Create-SiteColumn -siteColumnName "Question and Answer Category" -siteColumnInternalName "QnA_QuestionAndAnswerCategory" -siteColumnType "TaxonomyFieldType" -termSetName "QuestionAndAnswerCategory" -termGroupName "QnA"



}