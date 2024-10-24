import Foundation

protocol PartieProtocol {
    var nbJoueur : Int {get}
    var ordrePassage : [Joueur] {get set}
    var Centre : [Carte?]{get set}
    init(nbJoueur:Int)    
    func placerAuCentre(carte : Carte)
    func retirerDuCentre(indice:Int)
    mutating func selectionner(paquet : inout[Carte?])->Carte
    mutating func changerOrdrePassage()
}

struct Partie{
    
    var nbJoueur: Int
    var ordrePassage: [Joueur]
    var Centre: [Carte?]
    var Paquet: [Carte?]

    init(_ nbJoueur: Int) {
        self.nbJoueur = nbJoueur
        self.ordrePassage = [Joueur](repeating: Joueur(name: ""), count: nbJoueur)
        self.Centre = [Carte?](repeating: nil, count: nbJoueur)
    }

    

    

    mutating func placerAuCentre(carte : Carte){
        for k: Int in 0..<ordrePassage.count{
            let ligne : Int = demanderLigne()
            let colonne : Int = demandeColonne()
            var carte_temp : Carte =  self.ordrePassage[k].piocher(i : ligne, j : colonne)
            Centre[k] = carte_temp
        }

    }


    //renvoie une carte selectionnée aléatoirement de la pioche et met nul à la place
    mutating func selectionner(paquet : inout[Carte?])->Carte{  

        var randomInt : Int = Int.random(in: 0...paquet.count-1)

        while paquet[randomInt] == nil{
            randomInt = Int.random(in: 0...paquet.count-1)
        }
        if let cartePiochee : Carte = paquet[randomInt]{
            paquet[randomInt]=nil
            return cartePiochee
        }
        else{return Carte(numero : 0)} //Ce cas ne devrait jamais arriver (voir la boucle while)
    }


    // précondition : la carte selectionnée doit être valide 

    mutating func retirerDuCentre(indice:Int)->Carte{
        if let carteSelectionee : Carte = Centre[indice]{
            Centre[indice]=nil
            return carteSelectionee        }        
    }

    mutating func changerOrdrePassage()->[Joueur]{
        let dernierJoueur : Joueur = ordrePassage[0]
        for i in 0..<ordrePassage.count-1{
            ordrePassage[i]=ordrePassage[i+1]      }
            ordrePassage[ordrePassage.count-1]=dernierJoueur
        return ordrePassage
    }

    //prenant un tableau de carte (le tableau Centre), il permet d'avoir des informations pour le cas de base 
    //précondition : le tableau est rempli
    func occMinEtIndice(Tab : [Carte?])->(occurence : Int, indice : [Int]){

        let TabSansNul : [Carte] = Tab.compactMap { $0 } // permet de créer un tableau fait uniquement d'entier

        var min : Int = TabSansNul[0].numero
        var occ : Int = 0
        var indice : [Int] = [Int](repeating: 0, count: Tab.count) //0 signifie pas d'indice validé
        var indiceMin : Int = 0 // compteur pour suivre le nb d'indice trouvé pour un min donné

        for i in 1..<Tab.count{
            if TabSansNul[i].numero==min{
                occ+=1
                indice[indiceMin]=i
                indiceMin+=1          }
            else if TabSansNul[i].numero<min{
                min=TabSansNul[i].numero
                occ=1
                indice = [Int](repeating: 0, count: Tab.count) //renitialiser le tableau
                indice[0]=i
                indiceMin=1           }
        }
        return (occ, indice)
    }

    func echanger2cases (tableau : [Joueur], indice1: Int, indice2: Int)->[Joueur]{
        var tableauModifie : [Joueur] = tableau
        let temp : Joueur = tableau[indice1]
        tableauModifie[indice1] = tableauModifie[indice2]
        tableauModifie[indice2] = temp
        return tableauModifie
    }

    mutating func firstRoad()->[Joueur]{
        
    let (occ, indice) : (Int, [Int]) = occMinEtIndice(Tab: Centre)

    if occ==1{
        let OrdreJ : [Joueur] = echanger2cases(tableau: ordrePassage, indice1: indice[0], indice2: 0)
        return OrdreJ        }

    else if occ==2{
        let Occurence1 : [Joueur] = echanger2cases(tableau: ordrePassage, indice1: indice[0], indice2: 0) //un preimer tableau qui va mettre en premier indice le joueur qui a la carte la plus petite en premier
        let Occurence2 : [Joueur] = echanger2cases(tableau: ordrePassage, indice1: indice[1], indice2: 0) // un deuxième tableau qui va mettre en premier indice le joueur qui a eu la carte la plus petite en deuxième
        var mini : [Joueur] //création d'un mini tableau de joueurs, pour qu'il puisse piocher de nouveau dans la pioche et pouvoir déterminer qui joue en premier
        mini[0]=Occurence1[0]
        mini[1]=Occurence2[0]
        var duel : [Carte] //création de l'endroit où mettre les cartes piochées
        duel[0]=selectionner(paquet : &Paquet)
        duel[1]=selectionner(paquet : &Paquet)

        while duel[0].numero==duel[1].numero{
            duel[0]=selectionner(paquet:&Paquet)
            duel[1]=selectionner(paquet:&Paquet)
        }
        let (occ, indice) : (Int, [Int]) = occMinEtIndice(Tab: duel)
        let OrdreJ : [Joueur] = echanger2cases(tableau: ordrePassage, indice1: indice[0], indice2: 0)
        return OrdreJ        }

    else {      //cas occ==3
        let occurence1 : [Joueur] = echanger2cases(tableau: ordrePassage, indice1: indice[0], indice2: 0)
        let occurence2 : [Joueur] = echanger2cases(tableau: ordrePassage, indice1: indice[1], indice2: 0)
        let occurence3 : [Joueur] = echanger2cases(tableau: ordrePassage, indice1: indice[2], indice2: 0)

        var mini : [Joueur] //création d'un mini tableau de joueurs
        mini[0]=occurence1[0]
        mini[1]=occurence2[0]
        mini[2]=occurence3[0]
        var triel : [Carte] //création de l'endroit où mettre les cartes piochées
        triel[0]=selectionner(paquet:&Paquet)
        triel[1]=selectionner(paquet:&Paquet)
        triel[2]=selectionner(paquet:&Paquet)

        while triel[0].numero==triel[1].numero && triel[0].numero==triel[2].numero && triel[1].numero==triel[2].numero{
        triel[0]=selectionner(paquet:&Paquet)
        triel[1]=selectionner(paquet:&Paquet)
        triel[2]=selectionner(paquet:&Paquet)          } // cas où les trois cartes piochées sont égales

        while triel[0].numero==triel[1].numero || triel[0].numero==triel[2].numero || triel[1].numero==triel[2].numero{
            if triel[0].numero==triel[1].numero{
                triel[0]=selectionner(paquet:&Paquet)
                triel[1]=selectionner(paquet:&Paquet)            }
            else if triel[0].numero==triel[2].numero {
                triel[0]=selectionner(paquet:&Paquet)
                triel[2]=selectionner(paquet:&Paquet)            }
            else {
                triel[1]=selectionner(paquet:&Paquet)
                triel[2]=selectionner(paquet:&Paquet)            }            }

        let (occ, indice) : (Int, [Int]) = occMinEtIndice(Tab: triel)
        let OrdreJ : [Joueur] = echanger2cases(tableau: ordrePassage, indice1: indice[0], indice2: 0) 
        return OrdreJ
        }
        } 
    }