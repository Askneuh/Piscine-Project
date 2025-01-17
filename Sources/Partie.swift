import Foundation

protocol PartieProtocol {

    var nbJoueur : Int {get}
    var ordrePassage : [JoueurProtocol] {get set}
    var Centre : [CarteProtocol?]{get set}
    init(nbJoueur:Int, paquet : [CarteProtocol?])    
    mutating func placerAuCentre(k: Int)
    mutating func retirerDuCentre(indice:Int)->CarteProtocol
    mutating func selectionner()->CarteProtocol
    mutating func changerOrdrePassage()
    mutating func distributionCarte()
    mutating func firstRoad()
    mutating func jouerPremierTour()
    mutating func jouerTour()
    func resultat()
}

struct Partie : PartieProtocol{
    
    var nbJoueur: Int
    var ordrePassage : [JoueurProtocol]     // tableau définissant l'ordre des joueurs 
    var Centre: [CarteProtocol?]            // tableau des cartes piochées par les joueurs
    var Paquet: [CarteProtocol?]            // paquet de carte

    // initialiser une partie
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
    

    mutating func placerAuCentre(k: Int) {
        var copieOrdrePassage: [JoueurProtocol] = self.ordrePassage
        var isOK : Bool = false
        var col : Int = 0
        var lig : Int = 0
        while !isOK{
            let coord : (Int, Int) = demanderIndice()
            let carteTemp: CarteProtocol? = copieOrdrePassage[k].grille[coord.0][coord.1]
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
    //précondition : le tableau est rempli
    private func occMinEtIndice(Tab : [CarteProtocol?])->(occurence : Int, indice : [Int]){

        let TabSansNul : [CarteProtocol] = Tab.compactMap { $0 } // permet de créer un tableau fait uniquement d'entier

        var minimum : Int = TabSansNul[0].numero
        var occ : Int = 0
        var indice : [Int] = [Int](repeating: 0, count: TabSansNul.count) 
        var indiceMin : Int = 0 // compteur pour suivre le nb d'indice trouvé pour un min donné
        
        for i: Int in 0..<Tab.count{

            if TabSansNul[i].numero == minimum{
                occ += 1
                indice[indiceMin] = i             // on stocke dans le tableau 'Indice' les indices des minimums trouvés 
                indiceMin += 1
            }

            else if TabSansNul[i].numero < minimum{

                minimum = TabSansNul[i].numero
                occ = 1
                indice = [Int](repeating: 0, count: Tab.count) //si un nouveau minimum a été trouvé, on reinitialise le tableau 'Indice' car les valeurs stockées ne correspondent pas à la nouvelle valeur de minimum.
                indice[0]=i                // la premiere valeur du tableau 'Indice' réinitialisé est le minimum que le l'on de trouver
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

    //cas de base, permet de determiner l'odre du / des premiers joueurs
    mutating func firstRoad(){
        
        let (occ, indice) : (Int, [Int]) = occMinEtIndice(Tab: Centre)

    // si la carte ayant la plus petite valeur n'apparaît qu'une seule fois, le joueur la possédant joue en premier.
    
    if occ==1{

        ordrePassage = echanger2cases(tableau: ordrePassage, indice1: indice[0], indice2: 0)       
        
        }

    // si la carte ayant la plus petite valeur apparaît deux fois, les joueurs la possédant piochent de nouveux jusqu'à ce que les cartes repiochées soient différentes et ainsi, la joueur ayant la plus petite carte des deux jouera en premier.
    
    else if occ==2{

        var mini : [JoueurProtocol] = [JoueurProtocol](repeating: Joueur(name: " "), count: 2)  // 'mini' tableau de 2 joueurs, pour que les deux joueurs ayant tirer la carte avec la plus petite valeur piochent dans ce qu'il reste du packet et ainsi déterminer qui joue en premier
        
        // placement des joueurs ayant piochés les mêmes cartes à plus petite valeur, leurs indices sont présent dans le tableau 'Indice', on place dans 'mini' les joueurs correspondants
        
        for i in 0...mini.count-1{
            mini[i] = ordrePassage[indice[i]]
        }
        
        var duel : [CarteProtocol] = [CarteProtocol](repeating: Carte(numero: 0), count: 2) // tableau où apparaît la carte repiochée de chaque joueur de 'mini'
        
        for i in 0...mini.count-1{
            duel[i] = selectionner()
        }

        while duel[0].numero==duel[1].numero{

            for i in 0...mini.count-1{
            duel[i] = selectionner()
            }

        }

        // on recupère le nouveau minimum du tableau duel, et on place le joueuer correspondant au premier indice du tableau 'Indice' de duel en premier dans l'ordre de passage
        let (occ, indiceDuel) : (Int, [Int]) = occMinEtIndice(Tab: duel)
        ordrePassage = echanger2cases(tableau: ordrePassage, indice1: indice[indiceDuel[0]], indice2: 0)
    }

    // cas occ == 3
    else {

        // même principe que dans le cas 2, on crer un tableau mini où l'on stocke les joueuers ayant piochés les cartes à valeurs minimales
        
        var mini : [JoueurProtocol] = [JoueurProtocol](repeating: Joueur(name: " "), count: occ)         // création d'un mini tableau pour les joueuers ayant les cartes à valeur minimales
        
        for i in 0...mini.count-1{
            mini[i] = ordrePassage[indice[i]]
        }

        var triel : [CarteProtocol] = [CarteProtocol](repeating: Carte(numero: 0), count: occ)          // / tableau où apparaît la carte repiochée de chaque joueur de 'mini'
        
        for i in 1...mini.count-1{
            triel[i] = selectionner()
        }

        while triel[0].numero == triel[1].numero && triel[0].numero == triel[2].numero && triel[1].numero == triel[2].numero {              // cas où les trois cartes piochées sont égales
            
            for i in 0...mini.count-1{
                triel[i]=selectionner()
            }       
        }

        while triel[0].numero==triel[1].numero || triel[0].numero==triel[2].numero || triel[1].numero==triel[2].numero{
            
            if triel[0].numero==triel[1].numero{
                triel[0]=selectionner()
                triel[1]=selectionner()            
            }

            else if triel[0].numero == triel[2].numero {

                triel[0]=selectionner()
                triel[2]=selectionner()            
            }

            else {
                triel[1]=selectionner()
                triel[2]=selectionner()            
            }            
        }

            while triel[0].numero==triel[1].numero || triel[0].numero==triel[2].numero || triel[1].numero==triel[2].numero{
                if triel[0].numero==triel[1].numero{
                    triel[0]=selectionner()
                    triel[1]=selectionner()            }
                else if triel[0].numero==triel[2].numero {
                    triel[0]=selectionner()
                    triel[2]=selectionner()            }
                else {
                    triel[1]=selectionner()
                    triel[2]=selectionner()            }            }

            let (occ, indice) : (Int, [Int]) = occMinEtIndice(Tab: triel)
            let OrdreJ : [JoueurProtocol] = echanger2cases(tableau: ordrePassage, indice1: indice[0], indice2: 0) 
        }
    }
    mutating func jouerPremierTour()
    {
        for i: Int in 0..<self.ordrePassage.count {
            print("\n")
            print("Au tour de ", self.ordrePassage[i].name)
            AffGrille(joueur: self.ordrePassage[i])
            self.placerAuCentre(k: i)
            AffGrille(joueur: self.ordrePassage[i])
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

    mutating func jouerTour(){
        for i: Int in 0..<self.ordrePassage.count {
            print("\n")
            print("Au tour de ", self.ordrePassage[i].name)
            print("\n")
            AffGrille(joueur: self.ordrePassage[i])
            self.placerAuCentre(k: i)
            AffGrille(joueur: self.ordrePassage[i])
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
    func resultat(){
        var joueurs: [JoueurProtocol] = self.triInsertionSurScore()
        print("Classement :")
        for joueur: JoueurProtocol in joueurs{
            print(joueur.name," : " ,joueur.score)
        }
    }
}