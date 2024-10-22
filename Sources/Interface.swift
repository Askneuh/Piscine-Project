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

func demanderLigne() -> Int{
    print("Choisissez l'indice de ligne")
    if let input = readLine()
    {
        if let int = Int(input)
        {
            return int
        }
    }
return 50 
}