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