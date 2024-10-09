protocol PartieProtocol {
    var nbJoueur : Int {get}
    var ordrePassage : [Joueur] {get, set}
    var Centre : [Carte?]{get, set}
    init()
    init(nbJoueur:Int){
        self.nbJoueur=nbJoueur    }
    
    func placerAuCentre(carte:Carte)
    func retirerDuCentre(indice:Int)
    mutating func changerOrdrePassage()
}

struct Partie{
    var nbJoueur: Int
    var ordrePassage : [Joueur] = [Joueur](repeating: Joueur, count: nbJoueur)
    var Centre : [Carte?] = [Carte?](repeating: nil, count: nbJoueur)

    func placerAuCentre(carte:Carte)->[Carte]{
        for i in 0..<ordrePassage.count{
            Centre[i]=ordrePassage[i].Piocher()    }
        return Centre
    }

    func retirerDuCentre(indice:Int)->Carte{
        let carteSelectionee : Carte = Centre[indice]
        Centre[indice]=nil
        return carteSelectionee
    }

    func changerOrdrePassage()->[Joueur]{
        var dernierJoueur : Joueur = ordrePassage[0]
        for i in 0..<ordrePassage.count-1{
            ordrePassage[i]=ordrePassage[i+1]      }
        ordrePassage[ordrePassage.count-1]=dernierJoueur
        return ordrePassage
    }

    //fonction utile au cas de base
    func occMinEtIndice(Tab : [Joueur])->(occurence : Int, indice : [Int]){
        var min : Int = Tab[0]
        var occ : Int = 0
        var indice : [Int] = [Int](repeating: 0, count: Tab.count) //0signifie pas d'indice validé
        var indiceMin : Int = 0 // compteur pour suivre le nb d'indice trouvé pour un min donné

        for i in 0..<Tab.count{
            if Tab[i]==min{
                occ+=1
                indice[indiceMin]=i
                indiceMin+=1          }
            if Tab[i]<min{
                min=Tab[i]
                occ=1
                indice = [Int](repeating: 0, count: Tab.count) //renitialiser le tableau
                indice[0]=i
                indiceMin=1           }
        }
        return (occ, indice)
    }

    func echanger2cases (tableau : [Joueur], indice1: Int, indice2: Int)->[Joueur]{
        var tableauModifie : [Joueur] = tableau
        let temp : Int = tableau[indice1]
        tableauModifie[indice1] = tableauModifie[indice2]
        tableauModifie[indice2] = temp
        return tableauModifie
    }

    func firstRoad()->[Joueur]{
        let (occ, indice) : (Int, [Int]) = occMinEtIndice(Tab: Centre)

        if occ==1{
            let OrdreJ : [Joueur] = echanger2cases(tableau: ordrePassage, indice1: indice[0], indice2: 0)
            return OrdreJ        }

        else if occ==2{
            var OrdreJ : [Joueur] = echanger2cases(tableau: ordrePassage, indice1: indice[0], indice2: 0)
            var OrdreJ2 : [Joueur] = echanger2cases(tableau: ordrePassage, indice1: indice[1], indice2: 0)
            var mini : [Joueur] //création d'un mini tableau de joueurs
            mini[0]=OrdreJ[0]
            mini[1]=OrdreJ2[0]
            var duel : [Carte] //création de l'endroit où mettre les cartes piochées
            duel[0]=mini[0].piocher()
            duel[1]=mini[1].piocher()

            while duel[0]==duel[1]{
                duel[0]=mini[0].piocher()
                duel[1]=mini[1].piocher()
            }
            let (occ, indice) : (Int, [Int]) = occMinEtIndice(Tab: duel)
            let OrdreJ : [Joueur] = echanger2cases(tableau: ordrePassage, indice1: indice[0], indice2: 0)
            return OrdreJ        }

        else {      //cas occ==3
            var OrdreJ : [Joueur] = echanger2cases(tableau: ordrePassage, indice1: indice[0], indice2: 0)
            var OrdreJ2 : [Joueur] = echanger2cases(tableau: ordrePassage, indice1: indice[1], indice2: 0)
            var OrdreJ3 : [Joueur] = echanger2cases(tableau: ordrePassage, indice1: indice[2], indice2: 0)

            var mini : [Joueur] //création d'un mini tableau de joueurs
            mini[0]=OrdreJ[0]
            mini[1]=OrdreJ2[0]
            mini[2]=OrdreJ3[0]
            var triel : [Carte] //création de l'endroit où mettre les cartes piochées
            triel[0]=mini[0].piocher()
            triel[1]=mini[1].piocher()
            triel[2]=mini[2].piocher()

            while triel[0]==triel[1] && triel[0]==triel[2] && triel[1]==triel[2]{
            triel[0]=mini[0].piocher()
            triel[1]=mini[1].piocher()
            triel[2]=mini[2].piocher()          } // cas où les trois cartes piochées sont égales

            while triel[0]==triel[1] || triel[0]==triel[2] || triel[1]==triel[2]{
            if triel[0]==triel[1]{
                triel[0]=mini[0].piocher()
                triel[1]=mini[1].piocher()            }
            else if triel[0]==triel[2] {
                triel[0]=mini[0].piocher()
                triel[2]=mini[2].piocher()            }
            else {
                triel[1]=mini[1].piocher()
                triel[2]=mini[2].piocher()            }            }

        let (occ, indice) : (Int, [Int]) = occMinEtIndice(Tab: triel)
        let OrdreJ : [Joueur] = echanger2cases(tableau: ordrePassage, indice1: indice[0], indice2: 0) 
        return OrdreJ
        }
    }
}
