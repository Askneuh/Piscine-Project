// The Swift Programming Language
// https://docs.swift.org/swift-book

print("Hello, world!")
var j1 : Joueur = Joueur(name : "Seb")
AffGrille(joueur : j1)

var nbJoueur : Int = demanderNbJoueur()
print(type(of: nbJoueur))
print(nbJoueur)
//Creation du paquet de cartes                                                                                                                                                                            
var paquet = [Carte?](repeating: Carte(numero: 0), count: 100)
for numero in 1...10 {
    for i in 0..<10 {
        paquet[(numero - 1) * 10 + i] = Carte(numero: numero)
    }
}
var partie : PartieProtocol = Partie(nbJoueur: nbJoueur, paquet: paquet)
partie.distributionCarte()
    
partie.placerAuCentre()
affCentre(centre: partie.Centre)


    
