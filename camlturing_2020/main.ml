(*Leo Perrat, Benjamin Scherdel*)
type etat = string;;
type symbole = Wildcard|Vide|S of char;;
type mouvement = Gauche|Droite|Fixe;;
type transition = Null|Trans of etat*symbole*symbole*mouvement*etat;;
type ruban = Ruban of int*(symbole list)*(symbole list);;
type table = transition list;;
type machine = Turing of ruban*etat*(etat list)*table*bool
exception Syntaxe_fichier
(*machine : Turing(ruban,etat courant, etats finaux, table de transition, acceptée ou rejetée*)
(*ruban : Ruban(position de la tête de lecture, liste des indices negatifs, liste des indices positifs)*)
(*transition : Trans(etat de départ, symbole lu, symbole écrit, mouvement, etat d'arrivée)*)

(*N'ont d'utilité que pour les fonctions d'affichage et de parsing*)
let separateur = ' ';;
let wildcard = '*';;

#use "fonctions_utilitaires.ml";;

(*
============OPERATIONS DE LA MACHINE DE TURING==============
*)


(*Lit le ruban là où sa tête de lecture est positionnée*)
let lire_ruban r =
	match r with
	|Ruban(i,l1,l2) -> if i < 0
					   then lire l1 ((abs i)-1)
					   else lire l2 i
;;


(*Ecrit un symbole là où sa tête de lecture est positionnée*)
let ecrire_ruban symb r =
	match r with
	|Ruban(i,l1,l2) -> if i < 0
					   then Ruban(i,(ecrire l1 symb ((abs i)-1)),l2)
					   else Ruban(i,l1,(ecrire l2 symb i))
;;

(*Déplace à tête de lecture à droite ou à gauche*)
let deplacer r m =
	match m with
	|Droite -> (match r with |Ruban(i,l1,l2) -> Ruban((i+1),l1,l2))
	|Gauche -> (match r with |Ruban(i,l1,l2) -> Ruban((i-1),l1,l2))
	|Fixe -> r
;;

(*Cherche dans la table de transitions, la transition correspondant à l'état courant et au symbole lu, renvoie Null si cette transition n'existe pas*)
let rec chercher_transition courant symb transitions =
	match transitions with
	|[] -> Null
	|a::l1 -> (match a with |Trans(e1,s1,s2,m,e2) -> if (e1 = courant) && (s1 = symb || s1 = Wildcard) 
													 then Trans(e1,s1,s2,m,e2)
													 else chercher_transition courant symb l1
							|Null -> chercher_transition courant symb l1)
;;

(*
============FONCTIONS D'AFFICHAGE===========
*)
let rec print_ruban_aux r n n2=
	if n > n2
	then (print_string (symbole_to_string (lire_ruban r)))
	else if n = n2/2
		 then (print_string "["; print_string (symbole_to_string (lire_ruban r)); print_string "]|"; print_ruban_aux (deplacer r Droite) (n+1) n2)
		 else (print_string (symbole_to_string (lire_ruban r)); print_string "|"; print_ruban_aux (deplacer r Droite) (n+1) n2)
;;
let print_ruban r =
	match r with |Ruban(i,l1,l2) -> (print_string "..."; print_ruban_aux (Ruban((i-10),l1,l2)) 0 20; print_string "...\n")
;;

let rec print_ruban_entier_aux r n n2=
	if n > n2
	then (print_string (symbole_to_string (lire_ruban r)))
	else (print_string (symbole_to_string (lire_ruban r)); print_string "|"; print_ruban_entier_aux (deplacer r Droite) (n+1) n2)
;;
let  print_ruban_entier r =
	match r with |Ruban(i,l1,l2) 
	-> let taille1 = List.length l1 in
	   let taille2 = List.length l2 in
	   (print_ruban_entier_aux (Ruban((0-taille1),l1,l2)) 0 (taille1+taille2))
;;

let print_transition t =
	match t with 
	|Trans(e1,s1,s2,m,e2) 
	-> (print_string (String.concat "" ["Etat: "; e1; " | Symbole lu: "; (symbole_to_string s1); " | Symbole ecrit :"; (symbole_to_string s2);
					  					" | Mouvement : "; (match m with |Droite -> "Droite" |Gauche -> "Gauche" |Fixe -> "Fixe"); " | Etat d'arrivee : "; e2; "\n\n"]))
	|Null -> (print_string "Aucune transition possible \n\n")
;;

(*
=========ALGORITHME PRINCIPAL==========
Change l'état de la machine en fonction de sa table de transition jusqu'à arriver dans un état final ou jusqu'à ne plus trouver de transition
*)
let rec changer_etat mach =
	
	match mach with
	|Turing(r,courant,finaux,transitions,acceptation)
	-> (print_ruban r;
		match chercher_transition courant (lire_ruban r) transitions with
		|Null -> (print_transition Null; Turing(r,courant,finaux,transitions,false))
		|Trans(e1,s1,s2,m,e2) -> (print_transition (Trans(e1,s1,s2,m,e2));
								 if recherche e2 finaux
								 then (if s2 = Wildcard then Turing((deplacer r m),e2,finaux,transitions,true) else Turing((deplacer (ecrire_ruban s2 r) m),e2,finaux,transitions,true))
								 else (if s2 = Wildcard then changer_etat (Turing((deplacer r m),e2,finaux,transitions,false)) else changer_etat (Turing((deplacer (ecrire_ruban s2 r) m),e2,finaux,transitions,false)))))
;;


let calculer_machine r etat_init etats_finaux transitions =
	match changer_etat (Turing(r,etat_init,etats_finaux,transitions,false)) with
	|Turing(r1,e1,e2,trans,false) -> (print_ruban_entier r1; print_string "Machine non acceptée \n\n"; Turing(r1,e1,e2,trans,false))
	|Turing(r1,e1,e2,trans,true) -> (print_ruban_entier r1; print_string "Machine acceptée \n\n"; Turing(r1,e1,e2,trans,true))
;;

(*
=================FONCTIONS DE PARSING================
*)

(*
Convertit une chaine de caracteres en ruban
@throws Syntaxe_fichier
@throws Failure "int_of_string"
*)
let parseRuban str =
	let strlist = split_string str ';' in
	match strlist with
	|[] -> raise (Syntaxe_fichier)
	|a::l1 -> match l1 with
			  |[] -> raise (Syntaxe_fichier)
			  |a2::l2 -> Ruban((int_of_string a),[],List.map char_to_symbole (string_to_charlist a2))
;;

(*Converti une chaine de caracteres en transition*)
let parseTransition str =
	let strlist = (split_string str ';') in
	match List.length strlist with
	|5 -> Trans((List.nth strlist 0),(string_to_symbole (List.nth strlist 1)),(string_to_symbole (List.nth strlist 2)),
				(match (List.nth strlist 3) with |"->" -> Droite |"<-" -> Gauche |_ -> Fixe),(List.nth strlist 4))
	|_ -> Null
;;

(*
Lit le contenu d'un fichier puis calcule la machine de turing correspondante
@throws Syntaxe_fichier
*)
let parseFichier fichier =
	let contenulist = lire_fichier_strlist fichier in
	match contenulist with
	|[] -> raise (Syntaxe_fichier)
	|a::l1 -> match l1 with
			  |[] -> raise (Syntaxe_fichier)
			  |a2::l2 -> match l2 with
			  			 |[] -> raise (Syntaxe_fichier)
						 |a3::l3 -> calculer_machine (parseRuban a) a2 (split_string a3 ';') (List.map parseTransition l3)
;;

(*
let test = calculer_machine testRuban "e1" etatsFinaux transitions;;
Operations elementaires: 
Lire : fait
Ecrire : fait 
Deplacer : fait
Changer etat : à faire
Type de la fonction changer_etat : machine -> machine

Operations annexes : 
Ajout d'une transition à la table de transition : à faire
*)

