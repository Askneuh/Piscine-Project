protocol JoueurProtocol
{
    init(name : String)
    var name : String {get set}
    var grille : [[Carte?]] {get set}
    mutating func distribue(paquet : inout [Carte?]) -> [Carte?]
    mutating func piocher(i : Int, j : Int) -> Carte
    mutating func deplacer(deplacement : Direction, carte : Carte, i : Int, j : Int)
    func calculScore() -> Int
    func estComplet() -> Bool
}
struct Joueur : JoueurProtocol
{
    var name : String = " "
    var grille :[[Carte?]] = [[Carte?]](repeating: [Carte?](repeating: Carte(numero: 0), count: 4), count: 4)
    init(name : String)
    {
        self.name = name
        self.grille = [[Carte?]](repeating: [Carte?](repeating: Carte(numero: 0), count: 4), count: 4)
    }



    mutating func distribue(paquet : inout [Carte?]) -> [Carte?]
    /*
    Distribue les cartes aléatoirement à la grille
    Entree : 
    paquet : [Carte?] un paquet de carte adapté au nombre de joueurs de la partie, contenant des Nil si une partie des cartes a déja été distribuée à une autre grille.
    Sortie :
    grille : [[Carte]] la grille avec les cartes aléatoirement distribuées
    paquet : [Carte?] le paquet de carte sans les cartes qui ont été distribué dans la grille du joueur"
    */
    {    
        for i in 0...self.grille.count-1
        
        {
            for j in 0...self.grille[i].count-1
            {
                var randomInt : Int = Int.random(in: 0...paquet.count-1)
                while paquet[randomInt] == nil
                    {
                        randomInt = Int.random(in: 0...paquet.count-1)   
                    }
                
                
                if let c1 : Carte = paquet[randomInt]
                { 
                    self.grille[i][j] = c1
                    paquet[randomInt] = nil
                }                
            }
        }
        return paquet
    }


    mutating func piocher(i: Int, j: Int) -> Carte
    /*
    Renvoie la carte situé à l'indice de ligne i et de colonne j et la supprime dans la grille
    entree :
    i, j : Int, 0 <= i <= grille.count-1, 0 <= j <= grille.count-1
    sortie : 
    self.grille[i][j] : Carte : la carte situé à l'indice de ligne i et de colonne j
    Precondition : la carte ne doit pas etre deja face visible
    */
    {   
        if let c : Carte = self.grille[i][j]
        {
            self.grille[i][j] = nil
            return c
        }
        //Ce cas ne devrait pas arriver
        return Carte(numero : 0)
    }


    func estComplet() -> Bool
    /*
    Renvoie true si chacun des éléments de la grille est une carte, false s'il y a un nil dans la grille
    Sortie :
    res : bool
    */
    {
        var i : Int = 0
        var res : Bool = true
        while i != self.grille.count && res == true
        {
            var j : Int = 0
            while j != self.grille[i].count && res == true
            {
                if self.grille[i][j] == nil
                {
                    res = false
                }
                j += 1
            }
            i += 1
        }
        return res    
    }
    func calculScore() -> Int
        /*
        Calcul la somme des cartes qui n'ont pas de carte voisine ayant la meme valeur.
        Sortie :
        */ 
        {
            var somme : Int = 0
        for i in 0...self.grille.count-1
        {
                for j in 0...self.grille[i].count-1
                {
                    var voisinDistinct: Bool = true
                    if let c : Carte = self.grille[i][j]
                    {
                        //Verification du voisin du haut
                        if i > 0 
                        {
                            if let ch : Carte = self.grille[i - 1][j]
                            {
                                if ch.numero == c.numero{
                                    voisinDistinct = false
                                }
                            }
                        }
                        
                        //Verification du voisin du bas
                        if i < self.grille.count-1
                        {
                            if let cb : Carte = self.grille[i + 1][j]
                            {
                                if cb.numero == c.numero{
                                    voisinDistinct = false
                                }
                            }
                        }
                        //Verification du voisin de gauche
                        if j > 0
                        {
                            if let cg : Carte = self.grille[i][j - 1]
                            {
                                if cg.numero == c.numero{
                                    voisinDistinct = false
                                }
                            }
                        }
                        //verification du voisin de droite 
                        if j < self.grille[i].count-1
                        {
                            if let cd : Carte = self.grille[i][j+1]
                            {
                                if cd.numero == c.numero{
                                    voisinDistinct = false
                                }
                            }
                        }
                        if voisinDistinct
                        {
                            somme += c.numero
                        } 
                    }
                    
                }
            }
        return somme     
    }
    mutating func deplacer(deplacement : Direction, carte : Carte,i : Int, j : Int){
        let ligneTrou : Int = i // nom de la variable utilisée pour enlever une carte de la grille
        let colonneTrou : Int = j

        switch deplacement{

            case .Haut :
            if (ligneTrou==self.grille.count-1){
                print("déplacement impossible, veuillez séléctionner déplacement valide")
            }
            else {
                for k in ligneTrou ... self.grille.count-2{
                    self.grille[k][colonneTrou]=self.grille[k+1][colonneTrou]         }
                self.grille[self.grille.count-1][colonneTrou]=carte
            }

            case .Bas :
            if (ligneTrou==0){
                print("déplacement impossible, veuillez séléctionner déplacement valide")
            }
            else {

                for l in stride(from:ligneTrou, to: 1, by: -1){
                    self.grille[l][colonneTrou]=self.grille[l-1][colonneTrou]          }
                self.grille[0][colonneTrou]=carte
            }

            case.Droite :
            if (colonneTrou==0){
                print("déplacement impossible, veuillez séléctionner déplacement valide")
            }
            else {

                for m in stride(from: colonneTrou, to:1, by: -1)
                {
                   self.grille[ligneTrou][m]=self.grille[ligneTrou][m-1]        
                }
                self.grille[ligneTrou][self.grille.count-1]=carte
            }

            case .Gauche:
            if (colonneTrou==self.grille.count-1){
                print("déplacement impossible, veuillez séléctionner déplacement valide")
            }
            else {
                for n in colonneTrou...self.grille[0].count-2{
                    self.grille[ligneTrou][n]=self.grille[ligneTrou][n+1]             }
                self.grille[ligneTrou][0]=carte
            }
        }
    }
    
}

enum Direction {
        case Haut
        case Bas
        case Droite
        case Gauche }