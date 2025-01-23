var nbJoueur : Int = 2
//Creation du paquet de cartes                                                                                                                                                                            
var paquet: [CarteProtocol?] = [CarteProtocol?](repeating: Carte(numero: 0), count: 30)
for numero in 1...10 {
    for i in 0..<3 {
        paquet[(numero - 1) * 3 + i] = Carte(numero: numero)
    }
}
var joueurs: [JoueurProtocol] = [JoueurProtocol](repeating:Joueur(name: " "), count:nbJoueur)
for i: Int in 0..<joueurs.count{
    var nom : String = demanderNomJoueur(i : i+1)
    joueurs[i] = Joueur(name: nom)
        }
var partie : PartieProtocol = Partie(nbJoueur: nbJoueur, paquet: paquet, listeJoueur: joueurs)
partie.distributionCarte()
jouerPremierTour(partie: &partie)
for h in 0...7{
    jouerTour(partie: &partie)
}
resultat(partie: partie)