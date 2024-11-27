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