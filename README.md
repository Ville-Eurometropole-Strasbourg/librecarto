# LibreCarto

LibreCarto est une proposition de nouvelle version de la Carto EMS s'appuyant essentiellement sur des données issues d'OpenStreetMap. Elle reprend les choix graphiques de la version historique créé sur Elyx.

## Gestion des données

Le téléchargement des données pour l'emprise large (EMS + Kehl) se fait avec l'API de l'outil [OSM by the Slice](https://slice.openstreetmap.us/) qui permet d'avoir des données OSM fraîches à la minute pour une zone d'intérêt donnée. 

Pour cela il faut lancer [`telechargement_osm_pbf.ps1`](telechargement_osm_pbf.ps1)