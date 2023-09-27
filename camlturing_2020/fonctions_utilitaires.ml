(*
============FONCTIONS UTILITAIRES==============
*)

(*Convertit un caractere en symbole *)
let char_to_symbole char = 
	if char=separateur
	then Vide
	else if char = wildcard 
		 then Wildcard
		 else S(char)
;;

(*Convertit le premier caractere d'une chaine en symbole*)
let string_to_symbole str =
    match str with
    |""-> Vide
    |a -> (char_to_symbole a.[0])
;;

(*Convertit un symbole en chaine de caractere*)
let symbole_to_string symb =
	match symb with
	|S(a) -> String.make 1 a
	|Vide -> String.make 1 separateur
	|Wildcard -> String.make 1 wildcard
;;

(*Concatene deux listes*)
let concatener l1 l2 = List.fold_right (fun x y -> x::y) l1 l2;; 

(*Inverse le sens d'une liste*)
let rec inverser_liste_aux l1 l2 =
	match l1 with
	|[] -> l2
	|a::l3 -> inverser_liste_aux l3 (concatener (a::[]) l2)
;;
let inverser_liste l =
	inverser_liste_aux l []
;;

(*Convertit une chaine en liste de caracteres*)
let rec string_to_charlist_aux str charlist n=
	match n with
	|0 -> (String.get str n)::charlist
	|_ -> string_to_charlist_aux str ((String.get str n)::charlist) (n-1)
;;
let string_to_charlist str =
	match str with
	|"" -> []
	|_ -> string_to_charlist_aux str [] ((String.length str)-1)
;;

(*Divise une liste de caractere, séparés par un caractere sep, en liste de listes de caracteres*)
let rec split_charlist_aux charlist1 sep charlist2 charlistlist =
	match charlist1 with
	|[] -> (inverser_liste charlist2)::charlistlist
	|a::l1 -> if a = sep
			  then split_charlist_aux l1 sep [] ((inverser_liste charlist2)::charlistlist)
			  else split_charlist_aux l1 sep (a::charlist2) charlistlist
;;
let split_charlist charlist sep =
	inverser_liste (split_charlist_aux charlist sep [] [])
;;

(*Divise une chaine de caracteres, séparés par un caractere sep, en liste de chaines*)
let split_string str sep =
	let stringlistlist = List.map (List.map (String.make 1)) (split_charlist (string_to_charlist str) sep) in 
	List.map (String.concat "") stringlistlist
;;


(*Renvoie vrai si a est présent dans la liste l*)
let rec recherche a l = 
	match l with
	|[] -> false
	|a1::l1 -> (a = a1) || (recherche a l1)
;;

(*Renvoie le symbole à l'indice n de la liste l, renvoie le symbole Vide si n est à l'exterieur de la liste*)
let rec lire l n = 
	match l with
	|[] -> Vide
	|a::l1 -> if n > 0 
			  then lire l1 (n-1)
			  else a			  
;;

(*Ecrit le symbole symb à l'indice n de la liste l, inscrit le symbole Vide sur toutes les cases vides si n est à l'exterieur de la liste*)
let rec ecrire l symb n = 
	match l with
	|[] -> if n > 0
		   then concatener (Vide::[]) (ecrire [] symb (n-1))
		   else symb::[]
	|a::l1 -> if n > 0
			  then concatener (a::[]) (ecrire l1 symb (n-1))
			  else concatener (symb::[]) l1 
;;

(*Lit le contenu d'un fichier dans une liste de chaines de caracteres*)
let rec lire_fichier_strlist_aux flux strlist =
    try let ligne = input_line flux in
        lire_fichier_strlist_aux flux (ligne::strlist)
    with End_of_file -> close_in flux; strlist
;;
let lire_fichier_strlist fichier =
    inverser_liste (lire_fichier_strlist_aux (open_in fichier) [])
;;