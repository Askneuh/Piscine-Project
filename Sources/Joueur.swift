protocol JoueurProtocol
{
    init(name : String)
    var name : String {get set}
    var grille : [[Carte?]] {get set}
    mutating func distribue(paquet : inout [Carte?]) -> [Carte?]
    mutating func piocher(i : Int, j : Int) -> Carte
    mutating func inserer(sens : String, i : Int, j : Int)
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
                if let c : Carte = self.grille[i][j]
                {
                    while c.numero == 0
                    {
                        if let c1 : Carte = paquet[randomInt]
                        {
                            self.grille[i][j] = c1
                            paquet[randomInt] = nil
                        }
                        else
                        {
                            randomInt = Int.random(in: 0...paquet.count-1)
                        }
                    }
                }
            }
        }
        return paquet
    }
}

