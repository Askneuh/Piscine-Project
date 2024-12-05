func AffGrille(joueur : Joueur)
{
    for i in 0...joueur.grille.count-1
    {
        for j in 0...joueur.grille[0].count-1
        {
            if let c : Carte = joueur.grille[i][j]
            {
                print(c.numero, terminator: " ")
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

func demanderNbJoueur() -> Int?
{
    var commencerPartie : Bool = false
    var nbJoueur : Int?
    while !commencerPartie
    {
        print("Combien de joueur souhaitez vous faire participer ?")
        let nbJoueur: Int? = Int(readLine()!)
        if let nb : Int = nbJoueur
        {
            if nb >= 2 && nb <= 4
            {
                print("La partie commence avec", nb, "joueurs.")
                commencerPartie = true
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