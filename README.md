# LibreCarto

LibreCarto est une proposition de nouvelle version de la Carto EMS s'appuyant essentiellement sur des données issues d'OpenStreetMap. Elle reprend les choix graphiques de la version historique créé sur Elyx.

## Gestion des données

Le téléchargement des données pour l'emprise large (EMS + Kehl) se fait avec l'API de l'outil [OSM by the Slice](https://slice.openstreetmap.us/) qui permet d'avoir des données OSM fraîches à la minute pour une zone d'intérêt donnée. 

Pour cela il faut lancer [`telechargement_osm_pbf.ps1`](telechargement_osm_pbf.ps1)

Pour charger les données en BDD, il faut utiliser [osm2pgsql](https://osm2pgsql.org/)

```
osm2pgsql.exe --verbose --create --input-reader=pbf --slim --schema=osm_import --output=flex --style="zone_activite.lua" --host=X --port=X --database=X --user=X -W 'carto.osm.pbf'
```

Concernant la construction des styles et de la fouille de données pour améliorer les fichiers de configurations `lua` , on peut se referer aux attributs non splittés dans la colonne `tags`. Concernant les tags, le [wiki](https://wiki.openstreetmap.org/wiki/FR:Page_principale) est d'une très grande aide, ainsi que [Taginfo](https://taginfo.openstreetmap.org/) et [sa version Alsacienne](https://taginfo.geofabrik.de/europe:france:alsace) pour voir les tendances de tags utilisés et les valeurs les plus utilisées.