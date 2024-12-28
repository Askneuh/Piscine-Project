func AffGrille(joueur : Joueur)
{
    for i in 0...joueur.grille.count-1
    {
        for j in 0...joueur.grille[0].count-1
        {
            if let c : Carte = joueur.grille[i][j]
            {
                if c.estFaceCachee{
                    print(c.numero, terminator: " ")
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

func affPaquet(paquet : [Carte?]) -> [Int]
{
    var res : [Int] = [Int](repeating: 0, count: 100)
    for i in  0..<paquet.count{
        if let carte : Carte = paquet[i]
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

func demanderNbJoueur() -> Int
{
    var commencerPartie : Bool = false
    var nbJoueur : Int = 0
    while !commencerPartie
    {
        print("Combien de joueur souhaitez vous faire participer ?")
        let saisie: Int? = Int(readLine()!)
        if let nb : Int = saisie
        {
            if nb >= 2 && nb <= 4
            {
                print("La partie commence avec", nb, "joueurs.")
                commencerPartie = true
                nbJoueur = nb
            }
            else
            {
                print("Le nombre de joueur n'est pas valide. Veuillez saisir un nombre entre 2 et 4")
            }

        
        }
        else
        {
            print("Veuillez saisir un nombre entre 2 et 4")
        }
    }
    return nbJoueur
}

func demanderNomJoueur(i : Int) -> String
{
    print("Nom du joueur", i, ": ")
    let nom: String? = String(readLine()!)
    if let n : String = nom
    {
        return n
    }
    return ""
}
func demanderIndice() -> Int{
    var isOK : Bool = false
    var i : Int = 0
    while !isOK{
        print("numéro de ligne de la carte à enlever : ")
        let saisieI : Int? = Int(readLine()!)
            if let l : Int = saisieI{
                if l < 4{
                    i = l
                    isOK = true
                }
                else{
                    print("le numéro de ligne ne correspond pas")
                }
            }
            else{
                print("veuillez saisir un chiffre entre 0 et 3")
            }
    }
    return i
}

func affCentre(centre: [Carte?]) {
    for elt in centre {
        if let c: Carte = elt {
            print(c.numero, terminator: " ")
        } else {
            print("/", terminator: " ")
        }
    }
}
func choisirCarteCentre(nbJoueur : Int) -> Int {
    var isOK : Bool = false
    var i : Int = 0
    while !isOK{
        print("Entrez l'indice de la carte que vous souhaitez récupérer :")
        let saisieI : Int? = Int(readLine()!)
            if let l : Int = saisieI{
                if l < nbJoueur{
                    i = l
                    isOK = true
                }
                else{
                    print("l'indice ne convient pas.")
                }
            }
            else{
                print("veuillez saisir un chiffre valide")
            }
    }
    return i
}
func demanderDirection(joueur: Joueur) -> Direction {
    var isOk : Bool = false
    var direction_r : Direction = .Haut
    while !isOk {
        print("Dans quelle direction souhaitez-vous insérer la carte ? (Haut, Bas, Droite, Gauche)")
        if let saisie = readLine(), let dir = Direction(rawValue: saisie) {
            switch dir{
                case .Gauche:
                    if (joueur.coordCaseVide.1==joueur.grille.count-1){
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
                    if (joueur.coordCaseVide.0==joueur.grille.count-1){
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
    