var nbJoueur : Int = demanderNbJoueur()
//Creation du paquet de cartes                                                                                                                                                                            
var paquet: [CarteProtocol?] = [CarteProtocol?](repeating: Carte(numero: 0), count: 100)
for numero in 1...10 {
    for i in 0..<10 {
        paquet[(numero - 1) * 10 + i] = Carte(numero: numero)
    }
}

var partie : PartieProtocol = Partie(nbJoueur: nbJoueur, paquet: paquet)
partie.distributionCarte()
partie.jouerPremierTour()
for h in 0...14{
    partie.jouerTour()
}
partie.resultat()