// The Swift Programming Language
// https://docs.swift.org/swift-book

print("Hello, world!")
var commencerPartie : Bool = false
var j1 : Joueur = Joueur(name : "Seb")
AffGrille(joueur : j1)
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

var paquet = [Carte?](repeating: Carte(numero: 0), count: 100)
for numero in 1...10 {
    for i in 0..<10 {
        paquet[(numero - 1) * 10 + i] = Carte(numero: numero)
    }
}
var nbj : Int = 0
if let n : Int = nbJoueur
{
    nbj = n
}
var partie : Partie = Partie(nbJoueur: nbj, paquet: paquet)