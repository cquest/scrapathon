#!/bin/sh
# scrapping des horaires TCL sur le métro de Lyon (lignes A à D)

for ligne in A B C D
do
	echo Ligne $ligne
	# on récupère les infos sur la ligne (liste des arrêts)
	arrets=`curl "http://www.tcl.fr/Me-deplacer/Toutes-les-lignes/$ligne" -s | egrep "<option value=\"tcl[0-9]{4}\">.*</option>" -o | egrep [0-9]{4} -o`
	# puis les horaires pour chaque arret et dans chaque sens
	for arret in $arrets
	do
		echo Arret $arret
		# aller
		horaires=`curl "http://www.tcl.fr/Me-deplacer/Toutes-les-lignes/$ligne/Horaire-a-l-arret?sens=1&submit%5Bafficher_depuis_ligne%5D=Afficher+les+horaires&arret=tcl$arret" -s | grep "partir de [0-9][0-9]h[0-9][0-9]\""  -o | grep  "[0-9][0-9]h[0-9][0-9]" -o | sort`
		for horaire in $horaires
		do
			echo "$ligne,$arret,aller,$horaire" >> stop_times.csv
		done
		# retour
		horaires=`curl "http://www.tcl.fr/Me-deplacer/Toutes-les-lignes/$ligne/Horaire-a-l-arret?sens=-1&submit%5Bafficher_depuis_ligne%5D=Afficher+les+horaires&arret=tcl$arret" -s | grep "partir de [0-9][0-9]h[0-9][0-9]\""  -o | grep  "[0-9][0-9]h[0-9][0-9]" -o | sort`
		for horaire in $horaires
		do
			echo "$ligne,$arret,retour,$horaire" >> stop_times.csv
		done
	done
done
