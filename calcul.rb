##
# Titre : Programme pour calculer la complexité d'un algorithme en pseudo-code
# Auteur : Grant BARRY
# E-mail : grant.barry@gmail.com
# Date : 09/06/2013
# Version : 0.1
# Description : Ce programme, écrit en Ruby 1.9.3, prend un fichier texte en
# entre. Ce fichier texte doit contenir un algorithme en pseudo-code.
# Ce programme boucle sur chaque ligne afin de calculer une complexité de
# l'agorithme
#
# Algorithme :
# 1. Lire le fichier d'entre
# 2. Initialise le compteur à 0
# 3. Boucle sur chaque ligne :
# 4. 	Identifie le commande et ajouter le poids au compteur
# 5. Afficher le compteur
##

##
# afficher_comment_utiliser_ce_programme
#
# Affiche comment utiliser ce programme et quitter. Cette fonction est utilisé
# si aucun fichier d'entré n'est précisé.
##
def afficher_comment_utiliser_ce_programme()
	puts
	puts "Pour utiliser ce programme, il faut preciser un fichier en entre."
	puts "Par exemple #{File.basename(__FILE__)} algo-01.txt"
	puts
	exit
end

##
# lire_le_fichier_dentre(nom_fichier)
#
# Lire le fichier en parametre 'nom_fichier' et retour un tableau contenant
# les lignes du fichier
##
def lire_le_fichier_dentre(nom_fichier)
	f = File.open(nom_fichier, 'r')
	tableau = f.readlines
	f.close
	return tableau
end

##
# calculer_la_complexite(tableau_algorithme)
#
# Boucler sur chaque entre dans le tableau et retourner la complexité de
# l'agorthime
##
def calculer_la_complexite(tableau_algorithme)
	complexite = Array.new

	for i in 0..tableau_algorithme.length do
		# Nettoyer la chaine de caractères
		ligne = tableau_algorithme[i].to_s.downcase.strip.gsub(/\s+/, " ").gsub(/\[\w\]/,"")
		case ligne
			when /[[:alpha:]]\s=/, /^retourner/, /^\w+\(/, /^si\s/
				complexite << "T#{(i+1).to_s}"
				next
			when /^pour\s/ # Il faut traiter une boucle Pour
				elements = ligne.split
				complexite << "(#{elements[5].to_s}-#{elements[3].to_s})*("
				next
			when /^tant\sque/ # Il faut traiter une boucle Tant que
				elements = ligne.split
				complexite << "T#{(i+1).to_s}"
				complexite << "("
				next
			when /fin\s+pour/, /fin\s+tant\s+que/ # On ferme la boucle
				elements = ligne.split
				complexite << ")"
				next
			else
				next # On peut ignorer la ligne car elle est inconnue
		end
	end

	return complexite
end

##
# calculer_la_complexite(tableau_algorithme)
#
# Afficher la complexité de l'agorithme
##
def afficher_complexite(complexite)
	c = ""
	for i in 0..complexite.length-1 do
		c += "#{complexite[i]}"
		c += "+" unless i == complexite.length-1 or complexite[i].end_with?("(") or complexite[i+1].end_with?(")")
	end
	puts "La complexite de cette algorithme est :"
	puts c
end

##
# Point d'entre / Démarrage du programme
##
if __FILE__ == $0	
	afficher_comment_utiliser_ce_programme() unless ARGV.length > 0
	algorithme = lire_le_fichier_dentre(ARGV[0])
	afficher_complexite(calculer_la_complexite(algorithme))
end