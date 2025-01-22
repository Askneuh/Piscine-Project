//Creation du paquet de cartes                                                                                                                                                                            
var paquet: [CarteProtocol?] = [CarteProtocol?](repeating: Carte(numero: 0), count: 100)
for numero in 1...10 {
    for i in 0..<6 {
        paquet[(numero - 1) * 6 + i] = Carte(numero: numero)
    }
}

var partie : PartieProtocol = Partie(paquet: paquet)
partie.distributionCarte()
partie.jouerPremierTour()
for h in 0...14{
    partie.jouerTour()
}
partie.resultat()