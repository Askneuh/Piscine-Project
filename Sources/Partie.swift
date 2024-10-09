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
            Centre[i]=ordre
        }
    }
}
