import Foundation

protocol PartieProtocol {

    // nbJoueur : Partie -> String
    // précondition : dans la version 3, 2 <= nbJoueur <= 4
    var nbJoueur : Int {get}

    // ordrePassage : Partie -> [Joueur]
    // tableau de l'ordre des passsage des joueurs 
    var ordrePassage : [JoueurProtocol] {get set}

    // Centre : Partie -> [Carte?]
    // tableau de cartes que les joueurs selectionnent et sortent de leurs grilles pour les placer au centre
    var Centre : [CarteProtocol?]{get set}

    // init : Int x [Carte?] x [Joueur] -> Partie
    // créer une partie avec un nombre de joueur valide, un paquet de cartes et une liste de joueurs
    init(nbJoueur:Int, paquet : [CarteProtocol?], listeJoueur: [JoueurProtocol])

    // placerAuCentre : Partie x Int x Int x Int -> Partie 
    // le joueur d'indice 'k' du tableau ordrePassage selectionne une carte d'indice de ligne 'lig', et d'indice de colonne 'col' de sa grille. La Carte selectionnée sera placée au Centre
    // précondition : 0 <= lig <= 3 
    //                0 <= col <= 3
    // précondition : la carte selectionnée ne doit pas être déja retournée 
    mutating func placerAuCentre(k: Int, lig: Int, col:Int)

    // retirerDuCentre : Partie x Int -> Partie x Carte 
    // retire l'élément d'indice 'indice' du Centre et renvoie la carte selectionnée
    // précondition : l'indice de la carte entré en paramètre doit être valide ( la carte de l'indice ne doit pas déjà être selectionné, elle ne doit pas dépasser les limites du tablau Centre)
    mutating func retirerDuCentre(indice:Int)->CarteProtocol

    // selectionner : Partie -> Carte x Partie
    // selectionne aléatoirement une carte du paquet (la pioche) et la renvoie 
    // post - condition : La carte renvoyée est remplacée par un nil dans le paquet
    mutating func selectionner()->CarteProtocol

    // changerOrdrePassage : Partie -> Partie
    // met à jour l'ordre de passage des joueurs à la fin de chaque tour
    mutating func changerOrdrePassage()

    // distributionCarte : Partie -> Partie 
    // place des cartes issu de 'paquet' dans la grille de chaque joueur
    // initialement, la grille des joueurs est remplie de carte numéro 0
    mutating func distributionCarte()

    //firstound : Partie -> Partie 
    // définit quel joueur joueura en premier (celui qui a la plus petite carte commence)
    mutating func firstRound()
}


struct Partie : PartieProtocol{
    
    // précondition : dans la version 3, 2 <= nbJoueur <= 4
    public private(set) var nbJoueur: Int

    // tableau de l'ordre des passsage des joueurs 
    var ordrePassage : [JoueurProtocol]

    // tableau de cartes que les joueurs selectionnent et sortent de leurs grilles pour les placer au centre
    var Centre: [CarteProtocol?]

    // tableau de cartes disponibles pour une partie 
    private var Paquet: [CarteProtocol?]

    // initialiser une partie avec un nombre de joueur valide, et un paquet de cartes contenant un nombre d'exemplaire définit 
    init(nbJoueur: Int, paquet : [CarteProtocol?], listeJoueur: [JoueurProtocol]) {
        self.nbJoueur = nbJoueur
        self.ordrePassage = listeJoueur
        self.Centre = [CarteProtocol?](repeating: nil, count: nbJoueur)
        self.Paquet = paquet

    }


    // distribution des cartes pour la grille de chaques joueuers

    mutating func distributionCarte(){

        for i: Int in 0..<ordrePassage.count{
            self.Paquet = ordrePassage[i].distribue(paquet: &self.Paquet)
        }

    }

    // le joueur d'indice 'k' du tableau ordrePassage selectionne une carte d'indice de ligne 'lig', et d'indice de colonne 'col' de sa grille. La Carte selectionnée sera placée au Centre
    // précondition : 0 <= lig <= 3 
    //                0 <= col <= 3
    // précondition : la carte selectionnée ne doit pas être déja retournée 

    mutating func placerAuCentre(k: Int, lig: Int, col: Int) {
        var copieOrdrePassage: [JoueurProtocol] = self.ordrePassage
        let carte: CarteProtocol? = copieOrdrePassage[k].piocher(i: lig, j: col)
        if let c: CarteProtocol = carte{
            Centre[k] = c
        }
        ordrePassage = copieOrdrePassage
        
    }

    // selectionne aléatoirement une carte du paquet (la pioche) et la renvoie 
    // post - condition : La carte renvoyée est remplacée par un nil dans le paquet

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

    // précondition : l'indice de la carte entré en paramètre doit être valide ( la carte de l'indice ne doit pas déjà être selectionné, elle ne doit pas dépasser les limites du tablau Centre)
    // retire l'élément d'indice 'indice' du Centre et renvoie la carte selectionnée

    mutating func retirerDuCentre(indice:Int) -> CarteProtocol{

        if let carteSelectionee : CarteProtocol = Centre[indice]{
            Centre[indice]=nil
            return carteSelectionee
        }

        return Carte(numero : 0) //Ce cas ne devrait jamais arriver

    }

    // met à jour l'ordre de passage des joueurs à la fin de chaque tour

    mutating func changerOrdrePassage(){
        let dernierJoueur : JoueurProtocol = ordrePassage[0]

        for i: Int in 0..<ordrePassage.count-1{
            ordrePassage[i]=ordrePassage[i+1]      }
            ordrePassage[ordrePassage.count-1]=dernierJoueur
    }

    // fonction nécessaire au cas de base 

    //prenant un tableau de carte (le tableau Centre), permet de determiner le minimum et les indices des joueurs ayant le minimum
    //précondition : le Centre est rempli

    private func occMinEtIndice(Tab : [CarteProtocol?])->(occurence : Int, indice : [Int]){
        
        // permet de créer un tableau fait uniquement d'entier
        var TabSansNul : [CarteProtocol] = [CarteProtocol](repeating:Carte(numero:0), count: self.nbJoueur)
        
        // copie du Centre
        for i in 0..<Tab.count{
            if let c: CarteProtocol = Tab[i]{
                TabSansNul[i] = c
            }
        }

        var minimum : Int = TabSansNul[0].numero
        var occ : Int = 0

        // permet de stocker les indices des joueurs ayant piochés la carte de valeur minimale du Centre
        var indice : [Int] = [Int](repeating: 0, count: TabSansNul.count)

        // compteur pour suivre le nb d'indice trouvé pour un min donné
        var indiceMin : Int = 0
        
        for i: Int in 0..<Tab.count{

            if TabSansNul[i].numero == minimum{
                occ += 1
                indice[indiceMin] = i              
                indiceMin += 1
            }

            else if TabSansNul[i].numero < minimum{

                minimum = TabSansNul[i].numero
                occ = 1

                //si un nouveau minimum a été trouvé, on reinitialise le tableau 'Indice' car les valeurs stockées ne correspondent pas à la nouvelle valeur de minimum.
                indice = [Int](repeating: 0, count: Tab.count)

                // la premiere valeur du tableau 'Indice' réinitialisé est le minimum que l'on a trouvé
                indice[0]=i
                indiceMin=1           }

        }

        return (occ, indice)

    }

    // permet, dans un tableau entré en paramètre, d'échanger deux cases
    // préconditions : tableau.count >= 2
    //               : les indices 1 et 2 doivent être valides
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
        
}