

$QnAAdminpageSiteUrl = "https://tcwlv.sharepoint.com/sites/PnPModernSearch"
#$QnAAdminpageSiteUrl = Read-Host -Prompt "Enter the SharePoint site URL (e.g., https://contoso.sharepoint.com/sites/PnPModernSearch)"
$PnPClientId = "d7c35d3c-3773-4009-bc67-885da2dd23fa"
#$PnPClientId = Read-Host -Prompt "Enter the PnP Client ID (App ID)"
$QnAAdminPageName = "QnAAdminPage2"
Connect-PnPOnline -Url $QnAAdminpageSiteUrl -Interactive -ClientId $PnPClientId -warningAction SilentlyContinue
#add the PnP Modern Search web parts to the site
$pnpSearchBoxId = "9add83ab-1633-493d-8df4-250fb461292a"
$pnpSearchRefinerId = "ac457495-9e1e-4e87-ad77-611b5008c856"
$pnpSearchResultsId = "770122f7-2500-4d00-93f4-8b4ff9a52ff3"

$page = Add-PnPPage -Name $QnAAdminPageName -LayoutType Article -Title "QnA Admin Page" -ErrorAction Stop


Add-PnPPageSection -Page $page -SectionTemplate TwoColumnRight -ErrorAction Stop
$wp = Add-PnPPageWebPart -Page $page -Component $pnpSearchBoxId -Section 1 -Column 1 -ErrorAction Stop
$wp.Title = "QnA Search Box"
#$wp = Add-PnPPageWebPart -Page $QnAAdminPageName -Component $pnpSearchRefinerId -Section 1 -Column 2 -ErrorAction Stop
#$wp.Title = "QnA Search Refiners"
Add-PnPPageWebPart -Page $page -DefaultWebPartType Button -Section 1 -Column 1 -ErrorAction Stop

Add-PnPPageSection -Page $page -SectionTemplate OneColumn -ErrorAction Stop
#$wp = Add-PnPPageWebPart -Page $QnAAdminPageName -Component $pnpSearchResultsId -Section 2 -Column 1 -ErrorAction Stop
#$wp.Title = "QnA Search Results"
#Set-PnPPage -Identity $QnAAdminPageName -Publish -ErrorAction Stop
$page.Publish()
#$page = Get-PnPPage -Identity "QnAAdminPage" -ErrorAction SilentlyContinue

#$page.Controls