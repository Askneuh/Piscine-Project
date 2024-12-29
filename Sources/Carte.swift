protocol CarteProtocol
{
    var numero : Int {get}
    mutating func retourner()
    var estFaceCachee : Bool {get set}
    init(numero : Int)
}
struct Carte : CarteProtocol
{
    var numero: Int = 0
    var estFaceCachee: Bool = true
    init(numero : Int)
    {
        self.numero = numero
    }
    mutating func retourner(){
        self.estFaceCachee = false
    }
}