

$QnAAdminpageSiteUrl = "https://tcwlv.sharepoint.com/sites/PnPModernSearch"
#$QnAAdminpageSiteUrl = Read-Host -Prompt "Enter the SharePoint site URL (e.g., https://contoso.sharepoint.com/sites/PnPModernSearch)"
$PnPClientId = "d7c35d3c-3773-4009-bc67-885da2dd23fa"
#$PnPClientId = Read-Host -Prompt "Enter the PnP Client ID (App ID)"
$QnAAdminPageName = "QnAAdminPage2"
Connect-PnPOnline -Url $QnAAdminpageSiteUrl -Interactive -ClientId $PnPClientId -warningAction SilentlyContinue
#add the PnP Modern Search web parts to the site

$page = Add-PnPPage -Name $QnAAdminPageName -LayoutType Article -Title "QnA Admin Page" -ErrorAction Stop


Add-PnPPageSection -Page $page -SectionTemplate TwoColumnRight -ErrorAction Stop

$wpBox = Add-PnPPageWebPart -Page $page -Component "PnP - Search Box" -Section 1 -Column 1 -ErrorAction Stop
$wpFilters = Add-PnPPageWebPart -Page $page -Component "PnP - Search Filters" -Section 1 -Column 2 -ErrorAction Stop
$JSONFilters = Get-Content -Path '.\QnA Admin page\webpartproperties Q&AAdminPage_Refiner.json' -Raw

$webpart = $page.controls | Where-Object {$_.Title -eq $wpFilters.Title}
Set-PnPPageWebPart -Page $page -Identity $webpart.InstanceId -PropertiesJson $JSONFilters

Add-PnPPageSection -Page $page -SectionTemplate OneColumn -ErrorAction Stop
$wpResults = Add-PnPPageWebPart -Page $page -Component "PnP - Search Results" -Section 2 -Column 1 -ErrorAction Stop
$webpart = $page.controls | Where-Object {$_.Title -eq $wpResults.Title}
$JSONResults = Get-Content -Path '.\QnA Admin page\webpartproperties Q&AAdminPage_Results.json' -Raw
Set-PnPPageWebPart -Page $page -Identity $webpart.InstanceId -PropertiesJson $JSONResults

$page.Publish()
