import Foundation

protocol PartieProtocol {

    var nbJoueur : Int {get}
    var ordrePassage : [Joueur] {get set}
    var Centre : [Carte?]{get set}
    init(nbJoueur:Int, paquet : [Carte?])    
    mutating func placerAuCentre(k: Int)
    mutating func retirerDuCentre(indice:Int)->Carte
    mutating func selectionner()->Carte
    mutating func changerOrdrePassage()
    mutating func distributionCarte()
    mutating func firstRoad()
    mutating func jouerPremierTour()
    mutating func jouerTour()
    func resultat()
}

struct Partie : PartieProtocol{
    
    var nbJoueur: Int
    var ordrePassage : [Joueur]     // tableau définissant l'ordre des joueurs 
    var Centre: [Carte?]            // tableau des cartes piochées par les joueurs
    var Paquet: [Carte?]            // paquet de carte

    // initialiser une partie
    init(nbJoueur: Int, paquet : [Carte?] ) {

        self.nbJoueur = nbJoueur
        self.ordrePassage = [Joueur](repeating: Joueur(name: ""), count: nbJoueur)
        self.Centre = [Carte?](repeating: nil, count: nbJoueur)
        self.Paquet = paquet

        // odrePassage est un tableau regroupant tous les joueurs dont on intialise le nom.
        for i in 0..<ordrePassage.count        {
            var nom : String = demanderNomJoueur(i : i+1)
            ordrePassage[i] = Joueur(name: nom)
        }

    }

    // distribution des cartes pour la grille de chaques joueuers

    mutating func distributionCarte(){

        for i in 0..<ordrePassage.count{
            self.Paquet = ordrePassage[i].distribue(paquet: &self.Paquet)
        }

    }

    // lors d'un tour, un joueur selectionne une carte qu'il place dans sa grille, qui est placée dans le tableau 'Centre'
    

    mutating func placerAuCentre(k: Int) {
        var copieOrdrePassage: [Joueur] = self.ordrePassage
        var isOK : Bool = false
        var col : Int = 0
        var lig : Int = 0
        while !isOK{
            let coord : (Int, Int) = demanderIndice()
            let carteTemp: Carte? = copieOrdrePassage[k].grille[coord.0][coord.1]
            if let c: Carte = carteTemp{
                if c.estFaceCachee{ 
                    isOK = true
                    col = coord.1
                    lig = coord.0
                }
            }
        }
        let carte: Carte? = copieOrdrePassage[k].piocher(i: lig, j: col)
        if let c: Carte = carte{
            Centre[k] = c
        }
        ordrePassage = copieOrdrePassage
        
    }


    //renvoie une carte selectionnée aléatoirement de la pioche et met nil à la place

    mutating func selectionner()->Carte{  

        var randomInt : Int = Int.random(in: 0...self.Paquet.count-1)

        while self.Paquet[randomInt] == nil{
            randomInt = Int.random(in: 0...self.Paquet.count-1)
        }

        if let cartePiochee : Carte = self.Paquet[randomInt]{
            self.Paquet[randomInt]=nil
            return cartePiochee
        }

        else{return Carte(numero : 0)} //Ce cas ne devrait jamais arriver (voir la boucle while)
    }


    // précondition : l'indice de la carte entré en paramètre doit être valide

    // retire et renvoie la carte d'un indice entré en paramètre, met nil à la place

    mutating func retirerDuCentre(indice:Int) -> Carte{

        if let carteSelectionee : Carte = Centre[indice]{
            Centre[indice]=nil
            return carteSelectionee
        }

        return Carte(numero : 0) //Ce cas ne devrait jamais arriver

    }

    mutating func changerOrdrePassage(){
        let dernierJoueur : Joueur = ordrePassage[0]

        for i in 0..<ordrePassage.count-1{
            ordrePassage[i]=ordrePassage[i+1]      }
            ordrePassage[ordrePassage.count-1]=dernierJoueur
    }

    //prenant un tableau de carte (le tableau Centre), il permet d'avoir des informations pour le cas de base 
    //précondition : le tableau est rempli
    private func occMinEtIndice(Tab : [Carte?])->(occurence : Int, indice : [Int]){

        let TabSansNul : [Carte] = Tab.compactMap { $0 } // permet de créer un tableau fait uniquement d'entier

        var minimum : Int = TabSansNul[0].numero
        var occ : Int = 0
        var indice : [Int] = [Int](repeating: 0, count: TabSansNul.count) 
        var indiceMin : Int = 0 // compteur pour suivre le nb d'indice trouvé pour un min donné
        
        for i in 0..<Tab.count{

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

    private func echanger2cases (tableau : [Joueur], indice1: Int, indice2: Int)->[Joueur]{
        var tableauModifie : [Joueur] = tableau
        let temp : Joueur = tableau[indice1]
        tableauModifie[indice1] = tableauModifie[indice2]
        tableauModifie[indice2] = temp
        return tableauModifie

    }

    //cas de base, permet de determiner l'odre du / des premiers joueurs
    mutating func firstRoad(){
        let copieCentre : [Carte?] = Centre
        
        let (occ, indice) : (Int, [Int]) = occMinEtIndice(Tab: copieCentre)

    // si la carte ayant la plus petite valeur n'apparaît qu'une seule fois, le joueur la possédant joue en premier.
    
    if occ==1{

        ordrePassage = echanger2cases(tableau: ordrePassage, indice1: indice[0], indice2: 0)       
        
        }

    // si la carte ayant la plus petite valeur apparaît deux fois, les joueurs la possédant piochent de nouveux jusqu'à ce que les cartes repiochées soient différentes et ainsi, la joueur ayant la plus petite carte des deux jouera en premier.
    
    else if occ==2{

        var mini : [Joueur] = [Joueur](repeating: Joueur(name: " "), count: 2)  // 'mini' tableau de 2 joueurs, pour que les deux joueurs ayant tirer la carte avec la plus petite valeur piochent dans ce qu'il reste du packet et ainsi déterminer qui joue en premier
        
        // placement des joueurs ayant piochés les mêmes cartes à plus petite valeur, leurs indices sont présent dans le tableau 'Indice', on place dans 'mini' les joueurs correspondants
        
        for i in 0...mini.count-1{
            mini[i] = ordrePassage[indice[i]]
        }
        
        var duel : [Carte] = [Carte](repeating: Carte(numero: 0), count: 2) // tableau où apparaît la carte repiochée de chaque joueur de 'mini'
        
        for i in 0...mini.count-1{
            duel[i] = selectionner()
        }

        while duel[0].numero==duel[1].numero{

            for i in 0...mini.count-1{
            duel[i] = selectionner()
            }

        }

        // on recupère le nouveau minimum du tableau duel, et on place le joueuer correspondant au premier indice du tableau 'Indice' de duel en premier dans l'ordre de passage
        let (_, indiceDuel) : (Int, [Int]) = occMinEtIndice(Tab: duel)
        ordrePassage = echanger2cases(tableau: ordrePassage, indice1: indice[indiceDuel[0]], indice2: 0)
    }

    // si la carte ayant la plus petite valeur apparaît tois fois, les joueurs la possédant piochent de nouveux jusqu'à ce que les cartes repiochées soient toutes différentes et ainsi, la joueur ayant la plus petite carte des deux jouera en premier.


    else if occ == 3 {

        // même principe que dans le cas 2, on crer un tableau mini où l'on stocke les joueuers ayant piochés les cartes à valeurs minimales
        
        var mini : [Joueur] = [Joueur](repeating: Joueur(name: " "), count: occ)         // création d'un mini tableau pour les joueuers ayant les cartes à valeur minimales
        
        for i in 0...mini.count-1{
            mini[i] = ordrePassage[indice[i]]
        }

        var triel : [Carte] = [Carte](repeating: Carte(numero: 0), count: occ)          // / tableau où apparaît la carte repiochée de chaque joueur de 'mini'
        
        for i in 1...mini.count-1{
            triel[i] = selectionner()
        }

        while triel[0].numero == triel[1].numero && triel[0].numero == triel[2].numero && triel[1].numero == triel[2].numero {              // cas où les trois cartes piochées sont égales
            
            for i in 0...mini.count-1{
                triel[i]=selectionner()
            }       
        }

        while triel[0].numero == triel[1].numero || triel[0].numero == triel[2].numero || triel[1].numero == triel[2].numero {                     // cas où deux cartes pichés sont égales 
            let T0 : Carte = triel[0]                       // il est nécessaire de faire des copies des cartes car si triel[0].numero == triel[1].numero, la carte triel[1] est repiochée, et si triel[1] == triel[2], triel[1] étant déjà modifiée, ça n'engendrera pas les modifications souhaitées.
            let T1 : Carte = triel[1]
            let T2 : Carte = triel[2]
            
            if T0.numero == T1.numero {
                triel[0]=selectionner()
                triel[1]=selectionner()            
            }

            else if T0.numero == T2.numero {

                triel[0]=selectionner()
                triel[2]=selectionner()            
            }

            else if T1.numero == T2.numero {
                triel[1]=selectionner()
                triel[2]=selectionner()            
            }

        }

            let (_, indiceTriel) : (Int, [Int]) = occMinEtIndice(Tab: triel)
            ordrePassage = echanger2cases(tableau: ordrePassage, indice1: indice[indiceTriel[0]], indice2: 0) 
        }

        // cas où les quatre joueurs ont la même carte

        else {

            var mini : [Joueur] = [Joueur](repeating: Joueur(name: " "), count: occ)         // création d'un mini tableau pour les joueuers ayant les cartes à valeur minimales
        
            for i in 0...mini.count-1{
                mini[i] = ordrePassage[indice[i]]
            }

            var quat : [Carte] = [Carte](repeating: Carte(numero: 0), count: occ)          // / tableau où apparaît la carte repiochée de chaque joueur de 'mini'
            
            for i in 1...mini.count-1{
                quat[i] = selectionner()
            }

            while quat[0].numero == quat[1].numero && quat[0].numero == quat[2].numero && quat[0].numero == quat[3].numero && quat[1].numero == quat[2].numero && quat[1].numero == quat[3].numero && quat[2].numero == quat[3].numero {              // cas où les trois cartes piochées sont égales
                
                for i in 0...mini.count-1{
                    quat[i]=selectionner()
                }       
            }

            while quat[0].numero == quat[1].numero || quat[0].numero == quat[2].numero || quat[0].numero == quat[3].numero || quat[1].numero == quat[2].numero || quat[1].numero == quat[3].numero || quat[2].numero == quat[3].numero {                     // cas où deux cartes pichés sont égales 
                let T0 : Carte = quat[0]                       // il est nécessaire de faire des copies des cartes car si quat[0].numero == quat[1].numero, la carte quat[1] est repiochée, et si quat[1] == quat[2], quat[1] étant déjà modifiée, ça n'engendrera pas les modifications souhaitées.
                let T1 : Carte = quat[1]
                let T2 : Carte = quat[2]
                let T3 : Carte = quat[3]
                
                if T0.numero == T1.numero {
                    quat[0]=selectionner()
                    quat[1]=selectionner()            
                }

                else if T0.numero == T2.numero {

                    quat[0]=selectionner()
                    quat[2]=selectionner()            
                }

                else if T0.numero == T3.numero {

                    quat[0]=selectionner()
                    quat[3]=selectionner()            
                }

                else if T1.numero == T2.numero {
                    quat[1]=selectionner()
                    quat[2]=selectionner()            
                }

                else if T1.numero == T3.numero {

                    quat[1]=selectionner()
                    quat[3]=selectionner()            
                }

                else if T2.numero == T3.numero {

                    quat[2]=selectionner()
                    quat[3]=selectionner()            
                }

            }

                let (_, indicequat) : (Int, [Int]) = occMinEtIndice(Tab: quat)
                ordrePassage = echanger2cases(tableau: ordrePassage, indice1: indice[indicequat[0]], indice2: 0) 

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
            var carte : Carte = self.retirerDuCentre(indice: i)
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
        var carte : Carte = self.retirerDuCentre(indice: i)
        carte.retourner()
        while !(self.ordrePassage[k].estComplet){
            var dir : Direction = demanderDirection(joueur: self.ordrePassage[k])
            self.ordrePassage[k].deplacer(deplacement: dir, carte: carte, i: self.ordrePassage[k].coordCaseVide.0, j: self.ordrePassage[k].coordCaseVide.1)
            AffGrille(joueur: self.ordrePassage[k])
        }
    }
    self.changerOrdrePassage()
    }
    func resultat(){
        var joueurs = self.ordrePassage
        joueurs.sorted {$0.score < $1.score}
        print("Classement :")
        for joueur in joueurs{
            print(joueur.name," : " ,joueur.score)
        }
    }
}