protocol CarteProtocol
{
    var numero : Int {get}
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
}