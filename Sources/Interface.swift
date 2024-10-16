func AffGrille(joueur : Joueur)
{
    for i in 0...joueur.grille.count-1
    {
        for j in 0...joueur.grille[0].count-1
        {
            if let c : Carte = joueur.grille[i][j]
            {
                print(c.numero)
            }
            
        }
    }
}