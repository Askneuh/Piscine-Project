func AffGrille(joueur : JoueurProtocol)
//Fonction d'affichage de la grille d'un joueur passé en paramètre
//Parcours chaque carte de la grille, si la carte est face cachée, affiche "?", sinon, affiche la valeur de la carte
{
    for i: Int in 0..<joueur.taillePlateau
    {
        for j: Int in 0..<joueur.taillePlateau
        {
            if let c : CarteProtocol = joueur[i, j]
            {
                if c.estFaceCachee{
                    print("?", terminator: " ")
                }
                else{
                print(c.numero, terminator: " ")
                }
            }
            else{
                print(" ", terminator: " ")
            }
            
        }
        print(" ")
    }
}

func affPaquet(paquet : [CarteProtocol?]) -> [Int]
//Fonction d'affichage du paquet.
//Ne sers pas dans le main, mais a permis de vérifier la création du paquet
{
    var res : [Int] = [Int](repeating: 0, count: 30)
    for i: Int in  0..<paquet.count{
        if let carte : CarteProtocol = paquet[i]
        {
            res[i] = carte.numero
        }
        else
        {
            res[i] = 0
        }
    }
    return res
}

func demanderNomJoueur(i : Int) -> String
//Fonction demandant à l'utilisateur le nom du joueur créé en i-ième position par le jeu
//La fonction demande une entrée clavier à l'utilisateur et la transforme en type String
//Deux joueurs peuvent avoir le même nom
//La fonction demande une entrée clavier en boucle jusqu'a obtenir une entrée correcte.
{
    print("Nom du joueur", i, ": ")
    let nom: String? = String(readLine()!)
    if let n : String = nom
    {
        return n
    }
    return ""
}
func demanderIndice() -> (Int, Int){
//Fonction qui demande à l'utilisateur les coordonnées d'une carte à enlever.
//Elle vérifie que les indices entrés par l'utilisateur soit un nombre entier correspondent bien à une case de la grille
//La fonction demande une entrée clavier en boucle jusqu'a obtenir une entrée correcte.
//La fonction renvoie un tuple d'entier correspondant respectivement aux indices de ligne et de colonne.
    var isOK : Bool = false
    var i : Int = -1
    var j : Int = -1
    while !isOK{
        print("numéro de ligne de la carte à enlever : ")
        let saisieI : Int? = Int(readLine()!)
            if let l : Int = saisieI{
                if l < 4 && l >= 0{
                    isOK = true
                    i = l
                }
                else{
                    print("le numéro de ligne ne correspond pas")
                }
            }
            else{
                print("veuillez saisir un chiffre entre 0 et 3")
            }
    }
    isOK = false
    while !isOK{
        print("numéro de colonne de la carte à enlever : ")
        let saisieI : Int? = Int(readLine()!)
            if let c : Int = saisieI{
                if c < 4 && c >= 0{
                    j = c
                    isOK = true
                }
                else{
                    print("le numéro de colonne ne correspond pas")
                }
            }
            else{
                print("veuillez saisir un chiffre entre 0 et 3")
            }
    }    
    return (i, j)
}

func affCentre(centre: [CarteProtocol?]) {
//Fonction qui permet l'affichage du centre du jeu
//Pour chaque case du centre, si la case est une carte, la fonction affiche le numéro de la carte, sinon, la fonction affiche "/"
    for elt: CarteProtocol? in centre {
        if let c: CarteProtocol = elt {
            print(c.numero, terminator: " ")
        } else {
            print("/", terminator: " ")
        }
    }
}
func choisirCarteCentre(nbJoueur : Int, centre: [CarteProtocol?]) -> Int {
//Fonction qui demande a l'utilisateur de choisir l'indice de la carte du centre qu'il souhaite récupérer.
//La fonction demande en boucle jusqu'a ce que l'indice rentré par l'utilisateur soit correct.
    var isOK : Bool = false
    var i : Int = 0
    while !isOK{
        print("Entrez l'indice de la carte que vous souhaitez récupérer :")
        let saisieI : Int? = Int(readLine()!)
            if let l : Int = saisieI{
                if l >= 0 && l < nbJoueur{
                    if let c : CarteProtocol = centre[l]{
                        i = l
                        isOK = true
                    }
                
                    else{
                        print("La carte a cet indice n'est plus disponible")
                        print("\n")
                    }
                }
                else{
                    print("L'indice est trop grand ou trop petit")
                    print("\n")
                }
            }
            else{
                print("Veuillez saisir un chiffre valide")
                print("\n")
            }
    }
    return i
}
func demanderDirection(joueur: JoueurProtocol) -> Direction {
//Fonction qui demande à l'utilisateur la direction dans laquelle il souhaite intégrer sa carte dans sa grille
//La fonction demande en boucle la direction jusqu'a ce qu'elle soit conforme aux preconditions de la fonction deplacer.
    var isOk : Bool = false
    var direction_r : Direction = .Haut
    while !isOk {
        print("Dans quelle direction souhaitez-vous insérer la carte ? (Haut, Bas, Droite, Gauche)")
        if let saisie = readLine(), let dir = Direction(rawValue: saisie) {
            switch dir{
                case .Gauche:
                    if (joueur.coordCaseVide.1==joueur.taillePlateau-1){
                        print("déplacement impossible, veuillez séléctionner déplacement valide")
                    }
                    else{
                        direction_r = dir
                        isOk = true
                    }
                
                case .Droite:
                    if (joueur.coordCaseVide.1==0){
                        print("déplacement impossible, veuillez séléctionner déplacement valide")
                    }
                    else{
                        direction_r = dir
                        isOk = true
                    }
                
                case .Haut:
                    if (joueur.coordCaseVide.0==joueur.taillePlateau-1){
                        print("déplacement impossible, veuillez séléctionner déplacement valide")
                    }
                    else{
                        direction_r = dir
                        isOk = true
                    }
                
                case .Bas:
                    if (joueur.coordCaseVide.0==0){
                        print("déplacement impossible, veuillez séléctionner déplacement valide")
                    }
                    else{
                        direction_r = dir
                        isOk = true
                    }
                
            }
        }
        else{
            print("Veuillez entrer une direction valide (Haut, Bas, Droite, Gauche)")
        }
    }
    return direction_r
}
//resultat: Partie -> None
//Affiche le classement des joueurs en fonction de leur score
func resultat(partie: PartieProtocol){
var joueurs: [JoueurProtocol] = triInsertionSurScore(T: partie.ordrePassage)
var i: Int = partie.nbJoueur
print("Classement :")
for joueur: JoueurProtocol in joueurs{
    print(i, " : " ,joueur.name," : " ,joueur.score)
    i -= 1
}
print("\n")
print(joueurs[partie.nbJoueur - 1].name, "a gagné.")
}

//jouerPremierTour: Partie -> Partie
//Fait jouer le premier tour aux joueurs de la partie
func jouerPremierTour(partie: inout PartieProtocol){
    for i: Int in 0..<partie.ordrePassage.count {
        print("\n")
        print("Au tour de ", partie.ordrePassage[i].name)
        AffGrille(joueur: partie.ordrePassage[i])
        partie.placerAuCentre(k: i)
        AffGrille(joueur: partie.ordrePassage[i])
        print("\n")
        affCentre(centre: partie.Centre)
    print("\n")
    }
    partie.firstRound()

    for k: Int in 0..<partie.ordrePassage.count {
        print("Au tour de ", partie.ordrePassage[k].name)
        print("\n")
        AffGrille(joueur: partie.ordrePassage[k])
        print("\n") 
        affCentre(centre: partie.Centre)
        var i: Int = choisirCarteCentre(nbJoueur: partie.nbJoueur, centre: partie.Centre)
        var carte : CarteProtocol = partie.retirerDuCentre(indice: i)
        carte.retourner()
        while !(partie.ordrePassage[k].estComplet){
            var dir : Direction = demanderDirection(joueur: partie.ordrePassage[k])
        partie.ordrePassage[k].deplacer(deplacement: dir, carte: carte, i: partie.ordrePassage[k].coordCaseVide.0, j: partie.ordrePassage[k].coordCaseVide.1)
        AffGrille(joueur: partie.ordrePassage[k])
        }
    }
partie.changerOrdrePassage()
}
//jouerTour: Partie -> Partie
//Fait jouer un tour aux joueurs de la partie
func jouerTour(partie: inout PartieProtocol){
    for i: Int in 0..<partie.ordrePassage.count {
        print("\n")
        print("Au tour de ", partie.ordrePassage[i].name)
        print("\n")
        AffGrille(joueur: partie.ordrePassage[i])
        partie.placerAuCentre(k: i)
        AffGrille(joueur: partie.ordrePassage[i])
        print("\n")
        affCentre(centre: partie.Centre)
        print("\n")
    }
    for k: Int in 0..<partie.ordrePassage.count {
        print("\n")
        print("Au tour de ", partie.ordrePassage[k].name)
        print("\n")
        AffGrille(joueur: partie.ordrePassage[k])
        print("\n")
        affCentre(centre: partie.Centre)
        var i: Int = choisirCarteCentre(nbJoueur: partie.nbJoueur, centre: partie.Centre)
        var carte : CarteProtocol = partie.retirerDuCentre(indice: i)
        carte.retourner()
        while !(partie.ordrePassage[k].estComplet){
            var dir : Direction = demanderDirection(joueur: partie.ordrePassage[k])
            partie.ordrePassage[k].deplacer(deplacement: dir, carte: carte, i: partie.ordrePassage[k].coordCaseVide.0, j: partie.ordrePassage[k].coordCaseVide.1)
            AffGrille(joueur: partie.ordrePassage[k])
        }
    }
    partie.changerOrdrePassage()
}

//Trie les joueurs selon leur score, du plus faible au plus élevé
func triInsertionSurScore(T: [JoueurProtocol])->[JoueurProtocol]{
    var temp: [JoueurProtocol] = [JoueurProtocol](repeating:Joueur(name: ""), count:T.count)
    for k: Int in 0..<T.count{
        temp[k] = T[k]
    }
    for j in 0..<temp.count{
            var score: Int = temp[j].score
            var joueurTemp: JoueurProtocol = temp[j]
            var i: Int = j - 1
            while i >= 0 && temp[i].score < score{
                temp[i+1] = temp[i]
                i = i - 1
            }
            temp[i+1] = joueurTemp
    }
    return temp
}