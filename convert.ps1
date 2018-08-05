PARAM(
    $youtubeSubscriptions = "C:\tmp\subscription_manager.xml",
    $feedlySubscriptions = "C:\tmp\feedly-5ab96fd5-e4f6-42a7-8a9f-e5f98777294e-2018-08-04.opml", 
    $outputOpml = "C:\tmp\import-me-to-feedly.xml"
)

[xml] $ytXml = get-content $youtubeSubscriptions

$ytUrls = $ytXml.opml.body.outline.outline

[xml] $feedlyXml = get-content $feedlySubscriptions

$feedlyUrls = $feedlyXml.opml.body.outline.outline

# $x = $feedlyUrls |? {$ytUrls.xmlUrl -notcontains $_.xmlUrl}

# $x.text

$diff = $ytUrls |? {$feedlyUrls.xmlUrl -notcontains $_.xmlUrl}

$diff.Count

if ($diff.Count -gt 0) {
    $feedlyXml.opml.body.outline |? {$_.text -eq "Health"} | % {
        $elementToAddTo = $_
        
        $diff | % {
            $elementToAdd = $_
            $elementToAdd.type = "rss"
            
            $elementToAddTo.AppendChild($elementToAddTo.OwnerDocument.ImportNode($elementToAdd, $true))
        }
    }

    $feedlyXml.Save($outputOpml)
}