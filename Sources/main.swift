var nbJoueur : Int = 2
//Creation du paquet de cartes                                                                                                                                                                            
var paquet: [CarteProtocol?] = [CarteProtocol?](repeating: Carte(numero: 0), count: 30)
for numero in 1...10 {
    for i in 0..<3 {
        paquet[(numero - 1) * 3 + i] = Carte(numero: numero)
    }
}

var partie : PartieProtocol = Partie(paquet: paquet)
partie.distributionCarte()
partie.jouerPremierTour()
for h in 0...7{
    partie.jouerTour()
}
partie.resultat()