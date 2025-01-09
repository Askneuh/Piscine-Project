// The Swift Programming Language
// https://docs.swift.org/swift-book


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

for i: Int in 0..<partie.ordrePassage.count {
        print("Au tour de ", partie.ordrePassage[i].name)
        print("\n")
        AffGrille(joueur: partie.ordrePassage[i])
        partie.placerAuCentre(k: i)
        AffGrille(joueur: partie.ordrePassage[i])
}
partie.firstRoad()

for k: Int in 0..<partie.ordrePassage.count {
        print("Au tour de ", partie.ordrePassage[k].name)
        print("\n")
        AffGrille(joueur: partie.ordrePassage[k])
        print("\n") 
        affCentre(centre: partie.Centre)
        var i: Int = choisirCarteCentre(nbJoueur: nbJoueur, centre: partie.Centre)
        var carte : Carte = partie.retirerDuCentre(indice: i)
        carte.retourner()
        while !(partie.ordrePassage[k].estComplet()){
            var dir : Direction = demanderDirection(joueur: partie.ordrePassage[k])
            partie.ordrePassage[k].deplacer(deplacement: dir, carte: carte, i: partie.ordrePassage[k].coordCaseVide.0, j: partie.ordrePassage[k].coordCaseVide.1)
            AffGrille(joueur: partie.ordrePassage[k])
        }
    }
partie.changerOrdrePassage()


for h in 0...15{
    for i: Int in 0..<partie.ordrePassage.count {
        print("Au tour de ", partie.ordrePassage[i].name)
        print("\n")
        AffGrille(joueur: partie.ordrePassage[i])
        partie.placerAuCentre(k: i)
        AffGrille(joueur: partie.ordrePassage[i])
    }
    print("\n")
    for k: Int in 0..<partie.ordrePassage.count {
        print("Au tour de ", partie.ordrePassage[k].name)
        print("\n")
        AffGrille(joueur: partie.ordrePassage[k])
        print("\n")
        affCentre(centre: partie.Centre)
        var i: Int = choisirCarteCentre(nbJoueur: nbJoueur, centre: partie.Centre)
        var carte : Carte = partie.retirerDuCentre(indice: i)
        carte.retourner()
        while !(partie.ordrePassage[k].estComplet()){
            var dir : Direction = demanderDirection(joueur: partie.ordrePassage[k])
            partie.ordrePassage[k].deplacer(deplacement: dir, carte: carte, i: partie.ordrePassage[k].coordCaseVide.0, j: partie.ordrePassage[k].coordCaseVide.1)
            AffGrille(joueur: partie.ordrePassage[k])
        }
    }
    partie.changerOrdrePassage()
}



