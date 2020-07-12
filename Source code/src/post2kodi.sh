#!/bin/sh

# Commande KODI methode POST 09.2019 by www.custom-one.fr
# Penser à activer dans KODI /Paramétrage/Services le contrôle à distance via HTTP 

# Entrez vos paramètres :
user=%%kodiuser%%
pass=%%kodipass%%
ip_kodi=%%kodiaddress%%
port=%%kodiport%%  #port par défaut proposé dans l'interface KODI 

ct="Content-type: application/json"
url=http://$ip_kodi:$port/jsonrpc

case $1 in

	scan)		 # scan musique
	curl -su  $user:$pass -H $ct -X POST -d '{"jsonrpc":"2.0","method":"AudioLibrary.Scan","id":1}' $url
	;;

	play_pause)	 # play/pause   (il ya deux commande car dans certains cas c'est le player 1 qui est lancé, à améliorer....)  
	curl -su  $user:$pass -H $ct -X POST -d '{"jsonrpc":"2.0","method":"Player.PlayPause","params":{"playerid":0},"id":1}' $url
	curl -su  $user:$pass -H $ct -X POST -d '{"jsonrpc":"2.0","method":"Player.PlayPause","params":{"playerid":1},"id":1}' $url
	;;

	party)		 # party mode
	curl -su  $user:$pass -H $ct -X POST -d '{"jsonrpc":"2.0","id":1,"method":"Player.Open","params":{"item":{"partymode":"music"}}}' $url
	;;

	shuffle) 	 # aléatoire
	curl -su  $user:$pass -H $ct -X POST -d '{"jsonrpc":"2.0","method":"Player.SetShuffle","params":{"playerid":0,"shuffle":true},"id":1}' $url
	curl -su  $user:$pass -H $ct -X POST -d '{"jsonrpc":"2.0","method":"Player.SetShuffle","params":{"playerid":1,"shuffle":true},"id":1}' $url
	;;

	shuffle_off)	# aléatoire off
	curl -su  $user:$pass -H $ct -X POST -d '{"jsonrpc":"2.0","method":"Player.SetShuffle","params":{"playerid":0,"shuffle":false},"id":1}' $url
	curl -su  $user:$pass -H $ct -X POST -d '{"jsonrpc":"2.0","method":"Player.SetShuffle","params":{"playerid":1,"shuffle":false},"id":1}' $url
	;;

	next) 		#chanson suivante
	curl -su  $user:$pass -H $ct -X POST -d '{"jsonrpc": "2.0","method":"Player.GoTo","params":{"playerid":0,"to":"next"},"id":1}' $url
	curl -su  $user:$pass -H $ct -X POST -d '{"jsonrpc": "2.0","method":"Player.GoTo","params":{"playerid":1,"to":"next"},"id":1}' $url
	;;

	radio_nova)     #radio nova
	curl -su  $user:$pass -H $ct -X POST -d '{"jsonrpc":"2.0","id":1,"method":"Player.Open","params":{"item":{"file":"http://statslive.infomaniak.ch/playlist/radionova/radionova-high.mp3/playlist.m3u"}}}' $url
	;;

	stop)		#stop
	curl -su  $user:$pass -H $ct -X POST -d '{"jsonrpc":"2.0","id":1,"method":"Player.Stop","params":{"playerid":0}}' $url
	curl -su  $user:$pass -H $ct -X POST -d '{"jsonrpc":"2.0","id":1,"method":"Player.Stop","params":{"playerid":1}}' $url	
	;;

	home)		#retour menu home
	curl -su  $user:$pass -H $ct -X POST -d '{"jsonrpc":"2.0","method":"Input.Home","id":1}' $url
	;;

	retour)		#retour
	curl -su  $user:$pass -H $ct -X POST -d '{"jsonrpc": "2.0","method":"Input.Back","id":1}' $url
	;;

	vol+)   	#volume+
 	curl -su  $user:$pass -H $ct -X POST -d '{"jsonrpc":"2.0","id":1,"method":"Application.SetVolume","params":{"volume":"increment"},"id":1}' $url
	;;

	vol-)   	#volume-
        curl -su  $user:$pass -H $ct -X POST -d '{"jsonrpc":"2.0","id":1,"method":"Application.SetVolume","params":{"volume":"decrement"},"id":1}' $url
        ;;

	mute)		#mute le son
	curl -su  $user:$pass -H $ct -X POST -d '{"jsonrpc":"2.0", "method": "Application.SetMute", "params": {"mute":"toggle"}, "id": 1}' $url
	;;

	clean_media) 	#nettoyage de la bibliothèque musique
	curl -su  $user:$pass -H $ct -X POST -d '{"jsonrpc":"2.0", "method":"AudioLibrary.Clean","params":[true],"id":1}' $url
	;;

	up)  		#fleche haut
        curl -su  $user:$pass -H $ct -X POST -d '{"jsonrpc": "2.0","method":"Input.Up","id":1}' $url
        ;;

	down)  		#fleche bas
        curl -su  $user:$pass -H $ct -X POST -d '{"jsonrpc": "2.0","method":"Input.Down","id":1}' $url
        ;;

	left)  		#fleche de gauche
        curl -su  $user:$pass -H $ct -X POST -d '{"jsonrpc": "2.0","method":"Input.Left","id":1}' $url
        ;;

	right)  	#fleche droite
        curl -su  $user:$pass -H $ct -X POST -d '{"jsonrpc": "2.0","method":"Input.Right","id":1}' $url
        ;;

	ok) 		# OK/VALIDER
	curl -su  $user:$pass -H $ct -X POST -d '{"jsonrpc": "2.0","method":"Input.Select","id":1}' $url
	;;

	context) 	#context menu
	curl -su  $user:$pass -H $ct -X POST -d '{"jsonrpc": "2.0","method":"Input.ContextMenu","id":1}' $url
	;;

	playlist_hip_hop)  #joue une playlist nommée comme dans la commande (à modifier avec le nom de vos playlist)
	curl -su  $user:$pass -H $ct -X POST -d ' {"jsonrpc":"2.0","id":1,"method":"Player.Open","params":{"item":{"file":"special://profile/playlists/music/old_skool_hip_hop.m3u"},"options":{"repeat":"all"}}} ' $url
 	;;

	player)  #renvoi le numéro du lecteur en cours 
	curl -su  $user:$pass -H $ct -X POST -d '{"jsonrpc": "2.0", "method": "Player.GetActivePlayers", "id": 1}' $url
	;;

	genre) # acces direct à la page genre  
	curl -su  $user:$pass -H $ct -X POST -d '{"jsonrpc": "2.0", "method": "GUI.ActivateWindow", "params": { "window": "music", "parameters": [ "Genres" ] }, "id": 1 }' $url
	;;

	genre_1) #acces direct à la page genre Electro (à modifier suivant vos infos de votre base de donnée) 
	curl -su  $user:$pass -H $ct -X POST -d '{"jsonrpc": "2.0","method": "GUI.ActivateWindow", "params": { "window": "music", "parameters": [ "musicdb://1/Electro" ] }, "id": 1 }' $url
	;;

	genre_2)
        curl -su  $user:$pass -H $ct -X POST -d '{"jsonrpc": "2.0","method": "GUI.ActivateWindow", "params": { "window": "music", "parameters": [ "musicdb://2/Hip-Hop" ] }, "id": 1 }' $url
	;;

	repeat_all)   #répète toute la playlist
	curl -su  $user:$pass -H $ct -X POST -d '{"jsonrpc": "2.0", "method": "Player.SetRepeat", "params": { "playerid": 0, "repeat": "all" }, "id": 1} ' $url
	curl -su  $user:$pass -H $ct -X POST -d '{"jsonrpc": "2.0", "method": "Player.SetRepeat", "params": { "playerid": 1, "repeat": "all" }, "id": 1} ' $url
	;;

	repeat_one)
        curl -su  $user:$pass -H $ct -X POST -d '{"jsonrpc": "2.0", "method": "Player.SetRepeat", "params": { "playerid": 0, "repeat": "one" }, "id": 1} ' $url
        curl -su  $user:$pass -H $ct -X POST -d '{"jsonrpc": "2.0", "method": "Player.SetRepeat", "params": { "playerid": 1, "repeat": "one" }, "id": 1} ' $url
        ;;
	repeat_off)
        curl -su  $user:$pass -H $ct -X POST -d '{"jsonrpc": "2.0", "method": "Player.SetRepeat", "params": { "playerid": 0, "repeat": "off" }, "id": 1} ' $url
        curl -su  $user:$pass -H $ct -X POST -d '{"jsonrpc": "2.0", "method": "Player.SetRepeat", "params": { "playerid": 1, "repeat": "off" }, "id": 1} ' $url
        ;;
	clear_playlist)  #vide la playlist 
	curl -su  $user:$pass -H $ct -X POST -d '{"jsonrpc":"2.0","method":"Playlist.Clear","params":{"playlistid":0},"id":1}' $url
	curl -su  $user:$pass -H $ct -X POST -d '{"jsonrpc":"2.0","method":"Playlist.Clear","params":{"playlistid":1},"id":1}' $url
       ;;
# ajoutez ici vos commandes perso 
	playfile) # test lecture fichier
	#curl -su  $user:$pass -H $ct -X POST -d '{"jsonrpc":"2.0","method":"Player.Open","params":{"item":{"file":"/path/to/file.mp3"}},"id":1}' $url
	curl -su  $user:$pass -H $ct -X POST -d "{\"jsonrpc\":\"2.0\",\"method\":\"Player.Open\",\"params\":{\"item\":{\"file\":\"$2\"}},\"id\":1}" $url
	;;
esac
