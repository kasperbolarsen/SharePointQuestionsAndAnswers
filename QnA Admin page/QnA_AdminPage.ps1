

$QnAAdminpageSiteUrl = "https://tcwlv.sharepoint.com/sites/PnPModernSearch"
#$QnAAdminpageSiteUrl = Read-Host -Prompt "Enter the SharePoint site URL (e.g., https://contoso.sharepoint.com/sites/PnPModernSearch)"
$PnPClientId = "d7c35d3c-3773-4009-bc67-885da2dd23fa"
#$PnPClientId = Read-Host -Prompt "Enter the PnP Client ID (App ID)"

Connect-PnPOnline -Url $QnAAdminpageSiteUrl -Interactive -ClientId $PnPClientId -warningAction SilentlyContinue
#add the PnP Modern Search web parts to the site


Add-PnPPage -Name "QnAAdminPage" -LayoutType Article -Title "QnA Admin Page" -ErrorAction SilentlyContinue

Add-PnPPageSection -Page "QnAAdminPage" -SectionTemplate TwoColumnRight -ErrorAction Stop
$wp = Add-PnPPageWebPart -Page "QnAAdminPage" -Component "PnP - Search Results" -Section 1 -Column 1 -ErrorAction Stop
Set-PnPPage -Identity "QnAAdminPage" -Publish -ErrorAction SilentlyContinue

#$page = Get-PnPPage -Identity "QnAAdminPage" -ErrorAction SilentlyContinue

#$page.Controls