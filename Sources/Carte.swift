protocol CarteProtocol
{
    var numero : Int {get}
    mutating func retourner()
    var estFaceCachee : Bool {get set}
    init(numero : Int)
}
struct Carte : CarteProtocol
{
    public var numero: Int = 0
    public var estFaceCachee: Bool = true
    init(numero : Int)
    {
        self.numero = numero
    }
    public mutating func retourner(){
        self.estFaceCachee = false
    }
}