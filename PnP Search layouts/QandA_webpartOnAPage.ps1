$QnApageSiteUrl = "https://tcwlv.sharepoint.com/sites/PnPModernSearch"
$PnPClientId = "d7c35d3c-3773-4009-bc67-885da2dd23fa"
#$PnPClientId = Read-Host -Prompt "Enter the PnP Client ID (App ID)"
$QnAPageName = "QnAATestPage"
Connect-PnPOnline -Url $QnApageSiteUrl -Interactive -ClientId $PnPClientId -warningAction SilentlyContinue
#add the PnP Modern Search web parts to the site

$page = Add-PnPPage -Name $QnAPageName -LayoutType Article -Title "QnA test Page" -ErrorAction Stop


Add-PnPPageSection -Page $page -SectionTemplate TwoColumnLeft -ErrorAction Stop
$wpResults = Add-PnPPageWebPart -Page $page -Component "PnP - Search Results" -Section 1 -Column 2 -ErrorAction Stop
$webpart = $page.controls | Where-Object {$_.Title -eq $wpResults.Title}
$JSONResults = Get-Content -Path '.\PnP Search layouts\webpartproperties_QnA_wp.json' -Raw
Set-PnPPageWebPart -Page $page -Identity $webpart.InstanceId -PropertiesJson $JSONResults

$page.Publish()
