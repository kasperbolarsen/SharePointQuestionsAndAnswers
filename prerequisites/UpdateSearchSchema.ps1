


#Get the current SharePoint Search Schema and update it with the new properties

function MapCrawledPropertyToManagedProperty {
    param (
    [Parameter(Mandatory = $true)]
    [string]$siteUrl,
    [Parameter(Mandatory = $true)]
    [string]$managedProperty,    
    [string]$crawledProperty,
    [bool]$appendToExistingMapping = $true,
    
    [bool]$printConfig = $false
)


# function Load-Module ($m) {
#     # If module is imported say that and do nothing
#     if (Get-Module | Where-Object { $_.Name -eq $m }) {
#         write-host "Module $m is already imported."
#     }
#     else {

#         # If module is not imported, but available on disk then import
#         if (Get-Module -ListAvailable | Where-Object { $_.Name -eq $m }) {
#             Import-Module $m -Verbose
#         }
#         else {

#             # If module is not imported, not available on disk, but is in online gallery then install and import
#             if (Find-Module -Name $m | Where-Object { $_.Name -eq $m }) {
#                 Install-Module -Name $m -Force -Verbose -Scope CurrentUser
#                 Import-Module $m -Verbose
#             }
#             else {

#                 # If module is not imported, not available and not in online gallery then abort
#                 write-host "Module $m not imported, not available and not in online gallery, exiting."
#                 EXIT 1
#             }
#         }
#     }
# }

# Load-Module "PnP.PowerShell"

Connect-PnPOnline -Url $siteUrl -Interactive -ClientId $PnPClientId -WarningAction SilentlyContinue

$validNames = @("Int", "Date", "Decimal", "Double", "RefinableInt", "RefinableDate", "RefinableDateSingle", "RefinableDateInvariant", "RefinableDecimal", "RefinableDecimal", "RefinableString");

if (($crawledProperty.Length -ne 0) -and -not ($crawledProperty -match '^ows_')) {
    Write-Warning "Crawled property has to start with ows_";
    return
}

if ($crawledProperty -match '^(ows_taxId|ows_r|ows_q)') {
    Write-Warning "Script only support regular crawled properties ows_<field name>";
    #return
}

$mp = $managedProperty  | Select-String -Pattern '^(?<name>(Refinable|Double|Decimal|Date|Int)[a-z]*)(?<num>\d+)$'

if ($mp.Matches.Length -eq 0) {
    Write-Warning "Script only support reusable managed properties";
    return
}

$mpNumber = $mp.Matches[0].Groups['num'].Value

$basePid = 0;
if ($managedProperty -match "^RefinableString1" -and $mpNumber.length -eq 3 ) {
    $basePid = 1000000900
    $mpNumber = $mpNumber - 100;
}
elseif ($managedProperty -match "^RefinableDouble") {
    $basePid = 1000000800
}
elseif ($managedProperty -match "^RefinableDecimal") {
    $basePid = 1000000700
}
elseif ($managedProperty -match "^RefinableDateInvariant") {
    $basePid = 1000000660
}
elseif ($managedProperty -match "^RefinableDateSingle") {
    $basePid = 1000000660
}
elseif ($managedProperty -match "^RefinableDate") {
    $basePid = 1000000600
}
elseif ($managedProperty -match "^RefinableInt") {
    $basePid = 1000000500
}
elseif ($managedProperty -match "^Double") {
    $basePid = 1000000400
}
elseif ($managedProperty -match "^Decimal") {
    $basePid = 1000000300
}
elseif ($managedProperty -match "^Date") {
    $basePid = 1000000200
}
elseif ($managedProperty -match "^Int") {
    $basePid = 1000000100
}
elseif ($managedProperty -match "^RefinableString") {
    $basePid = 1000000000
}

$mpPid = $basePid + [int]$mpNumber

$scriptDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
if ($scriptDir.Length -eq 0) {
    $scriptDir = "."
}
if ($crawledProperty.Length -eq 0) {
    Write-Host "Resetting crawled property mapping for $managedProperty"
    $config = Get-Content -Path "$scriptDir\SearchMappingReset.xml" -Raw
}
else {
    if($appendToExistingMapping) {
        Write-Host "Appending crawled property $crawledProperty to managed property $managedProperty"
    } else {
        Write-Host "Replacing crawled property $crawledProperty to managed property $managedProperty"
    }    
    $config = Get-Content -Path "$scriptDir\SearchMappingTemplate.xml" -Raw
}

$config = $config -replace "##PID##", $mpPid
$config = $config -replace "##CPNAME##", $crawledProperty
$config = $config -replace "##APPEND##", $appendToExistingMapping.ToString().ToLower()

if($printConfig) {
    $config
    return
}

if ($siteUrl -like "*-admin*") {
    Set-PnPSearchConfiguration -Scope Subscription -Configuration $config
}
else {
    #Set-PnPSearchConfiguration -Scope Site -Configuration $config
}

Write-Host "Remember to re-index items after you have done a schema change"
   
}

function UpdateSeachSchema 
{
    

    
    Connect-PnPOnline -Url $adminSiteUrl -Interactive -ClientId $PnPClientId -warningAction SilentlyContinue
    [XML]$searchSchema = Get-PnPSearchConfiguration -Scope Subscription -ErrorAction SilentlyContinue
    #SAVE the current search schema to a file
    $searchSchema | Export-Clixml -Path "C:\temp\searchSchema.xml" -ErrorAction SilentlyContinue
    $searchSchema_mappings = Get-PnPSearchConfiguration -Scope Subscription -ErrorAction SilentlyContinue -OutputFormat ManagedPropertyMappings

    #we are going to add two new RefinableDates , validFromDate and ValidToDate
    #we are going to add a new RefinableString, QnA_QuestionAndAnswerCategory

    #find two available RefinableDate properties
    $refinableDateProperties = $searchSchema_mappings | Where-Object { $_.Name -like "RefinableDate*" } | Select-Object -ExpandProperty Name

    $firstAvailableRefinableDate = $null
    $secondAvailableRefinableDate = $null

    for ($i = 0; $i -lt 20; $i++) 
    {
        $index = $i.ToString()
        if($i -lt 10) 
        {
            $index = "0" + $i.ToString()
        }
        # Check if the property already exists in the search schema
        $candidate = "RefinableDate" + $index
        if ($refinableDateProperties -notcontains $candidate) 
        {
            if ($firstAvailableRefinableDate -eq $null) 
            {
                $firstAvailableRefinableDate = $candidate
            } 
            elseif ($secondAvailableRefinableDate -eq $null) 
            {
                $secondAvailableRefinableDate = $candidate
                break
            }
        }
    }
    $firstAvailableRefinableDate
    $secondAvailableRefinableDate
    
    #find an available RefinableString property
    $refinableStringProperties = $searchSchema_mappings | Where-Object { $_.Name -like "RefinableString*" } | Select-Object -ExpandProperty Name
    
    $availableRefinableString = $null
    for ($i = 0; $i -lt 20; $i++) 
    {
        $index = $i.ToString()
        if($i -lt 10) 
        {
            $index = "0" + $i.ToString()
        }
        # Check if the property already exists in the search schema
        $candidate = "RefinableString" + $index
        if ($refinableStringProperties -notcontains $candidate) 
        {
            $availableRefinableString = $candidate
            break
        }
    }
    $availableRefinableString

    MapCrawledPropertyToManagedProperty -siteUrl $adminSiteUrl -managedProperty $firstAvailableRefinableDate -crawledProperty ows_QnA_ValidFromDate
    MapCrawledPropertyToManagedProperty -siteUrl $adminSiteUrl -managedProperty $secondAvailableRefinableDate -crawledProperty ows_QnA_ValidToDate
    MapCrawledPropertyToManagedProperty -siteUrl $adminSiteUrl -managedProperty $availableRefinableString -crawledProperty ows_QnA_QuestionAndAnswerCategory
    
}
UpdateSeachSchema