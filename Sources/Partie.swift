import Foundation

protocol PartieProtocol {

    var nbJoueur : Int {get}
    var ordrePassage : [JoueurProtocol] {get set}       // définit l'ordre de passage des joueurs
    var Centre : [CarteProtocol?]{get set}              // tableau de cartes que les joueurs selectionnent et sortent de leurs grilles pour les placer au centre
    init(nbJoueur:Int, paquet : [CarteProtocol?])       // créer une partie avec un nombre de joueur valide et un paquet de cartes
    mutating func placerAuCentre(k: Int)                // un joueur selectionne une carte d'indice 'k' du Centre qu'il placera dans sa grille par un mouvement valide
    mutating func retirerDuCentre(indice:Int)->CarteProtocol    // retire l'élément d'indice 'indice' du Centre et renvoie la carte selectionnée
    mutating func selectionner()->CarteProtocol         // selectionne aléatoirement une carte du paquet (la pioche) et la renvoie          (avec du recul, nous aurions du travailler sur le modèle de la pile pour le paquet)
    mutating func changerOrdrePassage()                 // met à jour l'ordre de passage des joueurs à chaque tour.
    mutating func distributionCarte()                   // placemenet des cartes issu de 'paquet' dans la grille de chaque joueur
    mutating func firstRound()                           // définit quel joueur jouera en premier
    //jouerPremierTour: Partie -> Partie
    //Fait jouer le premier tour aux joueurs de la partie
    mutating func jouerPremierTour()
    //jouerTour: Partie -> Partie
    //Fait jouer un tour aux joueurs de la partie
    mutating func jouerTour()
    //resultat: Partie -> None
    //Affiche le classement des joueurs en fonction de leur score
    func resultat()
}

struct Partie : PartieProtocol{
    
    var nbJoueur: Int
    var ordrePassage : [JoueurProtocol]     // tableau définissant l'ordre des joueurs 
    var Centre: [CarteProtocol?]            // tableau des cartes piochées par les joueurs
    var Paquet: [CarteProtocol?]            // paquet de carte

    // initialiser une partie avec un nombre de joueur valide, et un paquet de cartes contenant un nombre d'exemplaire définit 
    init(nbJoueur: Int, paquet : [CarteProtocol?] ) {
        self.nbJoueur = nbJoueur
        self.ordrePassage = [JoueurProtocol](repeating: Joueur(name: ""), count: nbJoueur)
        self.Centre = [CarteProtocol?](repeating: nil, count: nbJoueur)
        self.Paquet = paquet

        // odrePassage est un tableau regroupant tous les joueurs dont on intialise le nom.
        for i: Int in 0..<ordrePassage.count        {
            var nom : String = demanderNomJoueur(i : i+1)
            ordrePassage[i] = Joueur(name: nom)
        }

    }

    // distribution des cartes pour la grille de chaques joueuers

    mutating func distributionCarte(){

        for i: Int in 0..<ordrePassage.count{
            self.Paquet = ordrePassage[i].distribue(paquet: &self.Paquet)
        }

    }

    // lors d'un tour, un joueur selectionne une carte qu'il place dans sa grille, qui est placée dans le tableau 'Centre'
    // précondition : - 0 <= k <= Centre.count-1
    //                - 'k' =/= à un indice du Centre déjà séléctionné par un autre joueur

    mutating func placerAuCentre(k: Int) {
        var copieOrdrePassage: [JoueurProtocol] = self.ordrePassage
        var isOK : Bool = false         // si l'indice 'k' ne vérifie pas les préconditions, isOk = false
        var col : Int = 0
        var lig : Int = 0
        while !isOK{
            let coord : (Int, Int) = demanderIndice()
            let carteTemp: CarteProtocol? = copieOrdrePassage[k][coord.0, coord.1]
            if let c: CarteProtocol = carteTemp{
                if c.estFaceCachee{ 
                    isOK = true
                    col = coord.1
                    lig = coord.0
                }
            }
        }
        let carte: CarteProtocol? = copieOrdrePassage[k].piocher(i: lig, j: col)
        if let c: CarteProtocol = carte{
            Centre[k] = c
        }
        ordrePassage = copieOrdrePassage
        
    }


    //renvoie une carte selectionnée aléatoirement de la pioche et met nil à la place

    mutating func selectionner()-> CarteProtocol{  

        var randomInt : Int = Int.random(in: 0...self.Paquet.count-1)

        while self.Paquet[randomInt] == nil{
            randomInt = Int.random(in: 0...self.Paquet.count-1)
        }

        if let cartePiochee : CarteProtocol = self.Paquet[randomInt]{
            self.Paquet[randomInt]=nil
            return cartePiochee
        }

        else{return Carte(numero : 0)} //Ce cas ne devrait jamais arriver (voir la boucle while)
    }


    // précondition : l'indice de la carte entré en paramètre doit être valide

    // retire et renvoie la carte d'un indice entré en paramètre, met nil à la place

    mutating func retirerDuCentre(indice:Int) -> CarteProtocol{

        if let carteSelectionee : CarteProtocol = Centre[indice]{
            Centre[indice]=nil
            return carteSelectionee
        }

        return Carte(numero : 0) //Ce cas ne devrait jamais arriver

    }

    mutating func changerOrdrePassage(){
        let dernierJoueur : JoueurProtocol = ordrePassage[0]

        for i: Int in 0..<ordrePassage.count-1{
            ordrePassage[i]=ordrePassage[i+1]      }
            ordrePassage[ordrePassage.count-1]=dernierJoueur
    }

    //prenant un tableau de carte (le tableau Centre), il permet d'avoir des informations pour le cas de base 

    //précondition : le Centre est rempli
    private func occMinEtIndice(Tab : [CarteProtocol?])->(occurence : Int, indice : [Int]){
        let TabSansNul : [CarteProtocol] = Tab.compactMap { $0 } // permet de créer un tableau fait uniquement d'entier

        var minimum : Int = TabSansNul[0].numero
        var occ : Int = 0
        var indice : [Int] = [Int](repeating: 0, count: TabSansNul.count)                   // permet de stocker les indices des joueurs ayant piochés la carte de valeur miniales dans le Centre
        var indiceMin : Int = 0                                                             // compteur pour suivre le nb d'indice trouvé pour un min donné
        
        for i: Int in 0..<Tab.count{

            if TabSansNul[i].numero == minimum{
                occ += 1
                indice[indiceMin] = i              
                indiceMin += 1
            }

            else if TabSansNul[i].numero < minimum{

                minimum = TabSansNul[i].numero
                occ = 1
                indice = [Int](repeating: 0, count: Tab.count)                              //si un nouveau minimum a été trouvé, on reinitialise le tableau 'Indice' car les valeurs stockées ne correspondent pas à la nouvelle valeur de minimum.
                indice[0]=i                                                                 // la premiere valeur du tableau 'Indice' réinitialisé est le minimum que le l'on de trouver
                indiceMin=1           }

        }

        return (occ, indice)

    }


    private func echanger2cases (tableau : [JoueurProtocol], indice1: Int, indice2: Int)->[JoueurProtocol]{
        var tableauModifie : [JoueurProtocol] = tableau
        let temp : JoueurProtocol = tableau[indice1]
        tableauModifie[indice1] = tableauModifie[indice2]
        tableauModifie[indice2] = temp
        return tableauModifie

    }

    //cas de base, permet de determiner l'odre du premier joueur
    mutating func firstRound(){

        var copieCentre : [CarteProtocol?] = Centre                                         // le Centre sera modifié si la    valeur minimale de carte apparait plus d'une fois dans le Centre, nous ne voulons pas le modifié, mais juste déterminer le premier jouer à jouer
        var (occ, indiceMin) : (Int, [Int]) = occMinEtIndice(Tab: copieCentre)      // indiceMin permettra entre autre de pouvoir remonté au joueur possédant la carte de valeur minimale

        while occ != 1 {
            for i in 0...occ-1{
                copieCentre[indiceMin[i]] = selectionner()
            }

            (occ, indiceMin) = occMinEtIndice(Tab: copieCentre)                     // mise à jour du nouveau Centre
        }

        ordrePassage = echanger2cases(tableau: ordrePassage, indice1: 0, indice2: indiceMin[0])
    }
        
    //jouerPremierTour: Partie -> Partie
    //Fait jouer le premier tour aux joueurs de la partie
    mutating func jouerPremierTour(){
        for i: Int in 0..<self.ordrePassage.count {
            print("\n")
            print("Au tour de ", self.ordrePassage[i].name)
            AffGrille(joueur: self.ordrePassage[i])
            self.placerAuCentre(k: i)
            AffGrille(joueur: self.ordrePassage[i])
            print("\n")
            affCentre(centre: self.Centre)
            print("\n")
        }
        self.firstRoad()

        for k: Int in 0..<self.ordrePassage.count {
            print("Au tour de ", self.ordrePassage[k].name)
            print("\n")
            AffGrille(joueur: self.ordrePassage[k])
            print("\n") 
            affCentre(centre: self.Centre)
            var i: Int = choisirCarteCentre(nbJoueur: self.nbJoueur, centre: self.Centre)
            var carte : CarteProtocol = self.retirerDuCentre(indice: i)
            carte.retourner()
            while !(self.ordrePassage[k].estComplet){
                var dir : Direction = demanderDirection(joueur: self.ordrePassage[k])
                self.ordrePassage[k].deplacer(deplacement: dir, carte: carte, i: self.ordrePassage[k].coordCaseVide.0, j: self.ordrePassage[k].coordCaseVide.1)
                AffGrille(joueur: self.ordrePassage[k])
            }
        }
        self.changerOrdrePassage()
    }
    //jouerTour: Partie -> Partie
    //Fait jouer un tour aux joueurs de la partie
    mutating func jouerTour(){
        for i: Int in 0..<self.ordrePassage.count {
            print("\n")
            print("Au tour de ", self.ordrePassage[i].name)
            print("\n")
            AffGrille(joueur: self.ordrePassage[i])
            self.placerAuCentre(k: i)
            AffGrille(joueur: self.ordrePassage[i])
            print("\n")
            affCentre(centre: self.Centre)
            print("\n")
        }
        for k: Int in 0..<self.ordrePassage.count {
            print("\n")
            print("Au tour de ", self.ordrePassage[k].name)
            print("\n")
            AffGrille(joueur: self.ordrePassage[k])
            print("\n")
            affCentre(centre: self.Centre)
            var i: Int = choisirCarteCentre(nbJoueur: self.nbJoueur, centre: self.Centre)
            var carte : CarteProtocol = self.retirerDuCentre(indice: i)
            carte.retourner()
            while !(self.ordrePassage[k].estComplet){
                var dir : Direction = demanderDirection(joueur: self.ordrePassage[k])
                self.ordrePassage[k].deplacer(deplacement: dir, carte: carte, i: self.ordrePassage[k].coordCaseVide.0, j: self.ordrePassage[k].coordCaseVide.1)
                AffGrille(joueur: self.ordrePassage[k])
        }
    }
    self.changerOrdrePassage()
    }
    //Trie les joueurs selon leur score, du plus faible au plus élevé
    func triInsertionSurScore()->[JoueurProtocol]{
        var temp: [JoueurProtocol] = [JoueurProtocol](repeating:Joueur(name: ""), count:self.nbJoueur)
        for k: Int in 0..<self.ordrePassage.count{
            temp[k] = self.ordrePassage[k]
        }
        for j in 0..<temp.count{
                var score: Int = temp[j].score
                var joueurTemp: JoueurProtocol = temp[j]
                var i: Int = j - 1
                while i >= 0 && temp[i].score < score{
                    temp[i+1] = temp[i]
                    i = i - 1
                }
                temp[i+1] = joueurTemp
        }
        return temp
    }
    //resultat: Partie -> None
    //Affiche le classement des joueurs en fonction de leur score
    func resultat(){
        var joueurs: [JoueurProtocol] = self.triInsertionSurScore()
        var i: Int = self.nbJoueur
        print("Classement :")
        for joueur: JoueurProtocol in joueurs{
            print(i, " : " ,joueur.name," : " ,joueur.score)
            i -= 1
        }
        print("\n")
        print(joueurs[self.nbJoueur - 1].name, "a gagné.")
    }
}