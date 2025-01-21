//Ce type sert à représenter les cartes du jeu, on a acces à la valeur de la carte ainsi qu'a si elle est face visible ou face cachee
//On peut aussi la rendre face visible si elle ne l'est pas
protocol CarteProtocol
{
    //numero : Carte -> Int
    //Renvoie la valeur de la carte
    var numero : Int {get}
    //retourner : Carte -> Carte
    //Place la carte face visible
    //Precondition : la carte est face cachee : self.estFaceCachee == True
    mutating func retourner()
    //estFaceCachee : Carte -> Bool
    //Renvoie si la carte est face cachee ou non
    var estFaceCachee : Bool {get set}
    //Crée une instance de carte face cachee de numéro = numero
    //Precondition : 0 <= numero <= 10
    //Note : on laisse la possibilité de mettre 0 pour la création de grilles par exemple
    init(numero : Int)
}
struct Carte : CarteProtocol
{
    //numero : Carte -> Int
    //Renvoie la valeur de la carte
    public var numero: Int = 0
    //estFaceCachee : Carte -> Bool
    //Renvoie si la carte est face cachee ou non
    public var estFaceCachee: Bool = true
    //Crée une instance de carte face cachee de numéro numero
    //Precondition : 0 <= numero <= 10
    //Note : on laisse la possibilité de mettre 0 pour la création de grilles par exemple
    init(numero : Int)
    {
        assert(numero > 0 || numero < 10, "Numero invalide")
        self.numero = numero
    }
    //retourner : Carte -> Carte
    //Place la carte face visible
    //Precondition : la carte est face cachee : self.estFaceCachee == True
    public mutating func retourner(){
        self.estFaceCachee = false
    }
}