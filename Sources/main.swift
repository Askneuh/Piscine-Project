// The Swift Programming Language
// https://docs.swift.org/swift-book

print("Hello, world!")
var j1 : Joueur = Joueur(name : "Seb")
AffGrille(joueur : j1)

var nbJoueur : Int? = demanderNbJoueur()
//Creation du paquet de cartes                                                                                                                                                                            
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