$body = '{"Name":"none", "RegionType":"bbox", "RegionData":[48.378145,7.550354,48.715431,7.921143]}'
$id = (Invoke-RestMethod -Uri "https://slice.openstreetmap.us/api/" -Method POST -Body $body -ContentType "application/json")

Write-Host "ID de la demande: $id"

do {
    $response = Invoke-RestMethod -Uri "https://slice.openstreetmap.us/api/$id" -Method GET
    Write-Host "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') Statut de la demande: Complete = $($response.Complete)"
    if (-not $response.Complete) {
        Start-Sleep -Seconds 30
    }
} while (-not $response.Complete)

Write-Host "Traitement termine. Telechargement en cours..."
Invoke-WebRequest -Uri "https://slice.openstreetmap.us/files/$id.osm.pbf" -OutFile "S:\Commun\DPT_Atelier_de_geomatique\Activites\Projets\Carto\librecarto\carto.osm.pbf"
Write-Host "Telechargement termine"
