protocol JoueurProtocol
{
    //init: String -> Joueur
    //Crée une instance de joueur dont le nom est name, avec une grille dont toutes les cases sont des cartes de valeur 0 face cachée.
    init(name : String)
    //name: Joueur -> String
    //nom du joueur
    var name : String {get set}
    //taillePlateau: Joueur -> Int
    //Taille du plateau, sachant que le plateau est une grille qui a autant de ligne que de colonne
    var taillePlateau : Int {get}
    //distribue : Joueur x [Carte?] -> Joueur x [Carte?]
    //Distribue aléatoirement, dans les cases de la grille du joueur, des cartes à partir d'un paquet de carte [Carte?] donné en paramètre
    //Precondition : la grille doit être telle qu'elle a été initialisée a sa création.
    mutating func distribue(paquet : inout [CarteProtocol?]) -> [CarteProtocol?]
    //piocher: Joueur x Int x Int -> Carte
    // Renvoie la carte situé dans la case d'indice i et j donnés en paramètres et la remplace par la valeur nil
    //Precondition : 0 <= i, j <= grille.count (en sachant que la grille est un carré).
    //Precondition : la grille doit être remplie à l'appel de cette fonction
    //Precondition : une carte ne peut etre piochée que si elle est face cachée : carte.estFaceCachée == True
    mutating func piocher(i : Int, j : Int) -> CarteProtocol
    //deplacer: Joueur x Direction x Carte x Int x Int -> Joueur
    //Insere la carte donnée en paramètre en fonction de la Direction aussi donnée en paramètre.
    //Les paramètres i et j représentent les coordonnées de ligne et de colonne de la case vide
    //Precondition : La grille doit avoir 1 et 1 seul élément nil.
    //Precondition : i == 0 => deplacement != Bas
    //Precondition : i == len(grille) - 1 => deplacement != Haut
    //Precondition : j == 0 => deplacement != Droite
    //Precondition : j == len(grille) - 1 => deplacement != Gauche
    mutating func deplacer(deplacement : Direction, carte : CarteProtocol, i : Int, j : Int)
    //score : Joueur -> Int
    //Calcule le score du joueur à partir de sa grille en respectant les règles du jeu
    //Precondition : la partie est terminée
    //Precondition : La grille du joueur est remplie et toutes les cartes sont retournées.
    var score : Int {get}
    //estComplet : Joueur -> Bool
    //Vérifie si la grille est complète ou non.
    var estComplet: Bool {get}
    //coordCaseVide: Joueur -> Int
    //Coordonnées de la case vide
    //Il ne peut y avoir qu'une seule case vide à la fois
    //Postcondition : 0 <= coordCaseVide.0, coordCaseVide.1 < taillePlateau
    var coordCaseVide : (Int, Int) {get}
    //Permet d'accéder et de modifier les éléments du plateau 
    subscript(lig: Int, col: Int) -> CarteProtocol? {get set}
}
struct Joueur : JoueurProtocol
{
    //taillePlateau: Joueur -> Int
    //Taille du plateau, sachant que le plateau est une grille qui a autant de ligne que de colonne
    public var taillePlateau: Int = 3
    //coordCaseVide: Joueur -> Int
    //Coordonnées de la case vide
    //Il ne peut y avoir qu'une seule case vide à la fois
    //Postcondition : 0 <= coordCaseVide.0, coordCaseVide.1 < taillePlateau
    public var coordCaseVide: (Int, Int)
    //name: Joueur -> String
    //nom du joueur
    public var name : String = " "
    private var grille :[[CarteProtocol?]] = [[CarteProtocol?]](repeating: [CarteProtocol?](repeating: Carte(numero: 0), count: 4), count: 4)
    //init: String -> Joueur
    //Crée une instance de joueur dont le nom est name, avec une grille dont toutes les cases sont des cartes de valeur 0 face cachée.
    init(name : String)
    {
        self.name = name
        self.grille = [[CarteProtocol?]](repeating: [CarteProtocol?](repeating: Carte(numero: 0), count: 3), count: 3)
        self.coordCaseVide = (-1, -1)
    }
    //Permet d'accéder et de modifier les éléments du plateau
    subscript(lig: Int, col: Int) -> CarteProtocol?{
        get {
            if !(0 <= lig && lig < self.taillePlateau && 0 <= col && col < self.taillePlateau) {
                fatalError("Index out of range")
            }
            return self.grille[lig][col]
        }
        set {
            if !(0 <= lig && lig < self.grille.count && 0 <= col && col < self.grille[0].count) {
                fatalError("Index out of range")
            }
            self.grille[lig][col] = newValue
        }
    }
    //distribue: Joueur x [Carte?] -> Joueur x [Carte?]
    //Distribue aléatoirement, dans les cases de la grille du joueur, des cartes à partir d'un paquet de carte [Carte?] donné en paramètre
    //Precondition : la grille doit être telle qu'elle a été initialisée a sa création.
    public mutating func distribue(paquet : inout [CarteProtocol?]) -> [CarteProtocol?]
    {
    guard(self.estComplet) else{
            fatalError("La grille ne doit pas être pleine")
        }    
        for i in 0...self.grille.count-1
        
        {
            for j in 0...self.grille[i].count-1
            {
                var randomInt : Int = Int.random(in: 0...paquet.count-1)
                while paquet[randomInt] == nil
                    {
                        randomInt = Int.random(in: 0...paquet.count-1)   
                    }
                
                
                if let c1 : CarteProtocol = paquet[randomInt]
                { 
                    self.grille[i][j] = c1
                    paquet[randomInt] = nil
                }                
            }
        }
        return paquet
    }

    //piocher: Joueur x Int x Int -> Carte
    // Renvoie la carte situé dans la case d'indice i et j donnés en paramètres et la remplace par la valeur nil
    //Precondition : 0 <= i, j <= grille.count (en sachant que la grille est un carré).
    //Precondition : la grille doit être remplie à l'appel de cette fonction
    //Precondition : une carte ne peut etre piochée que si elle est face cachée : carte.estFaceCachée == True
    public mutating func piocher(i: Int, j: Int) -> CarteProtocol
    {
        guard(self.estComplet) else {
            fatalError("La grille doit être pleine")
        }
        if let c : CarteProtocol = self.grille[i][j]
        {
            defer{
                self.grille[i][j] = nil
                self.coordCaseVide = (i, j)
            }
            return c
        }

            
        else{
            //Ce cas ne devrait pas arriver
            return Carte(numero : 0)
        }
    }
    //estComplet : Joueur -> Bool
    //Vérifie si la grille est complète ou non.
    public var estComplet: Bool
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
    //score: Joueur -> Int
    //Calcule le score du joueur à partir de sa grille en respectant les règles du jeu
    //Precondition : la partie est terminée
    //Precondition : La grille du joueur est remplie et toutes les cartes sont retournées.
    public var score: Int
    {
            var somme : Int = 0
        for i in 0...self.grille.count-1
        {
                for j in 0...self.grille[i].count-1
                {
                    var voisinDistinct: Bool = true
                    if let c : CarteProtocol = self.grille[i][j]
                    {
                        //Verification du voisin du haut
                        if i > 0 
                        {
                            if let ch : CarteProtocol = self.grille[i - 1][j]
                            {
                                if ch.numero == c.numero{
                                    voisinDistinct = false
                                }
                            }
                        }
                        
                        //Verification du voisin du bas
                        if i < self.grille.count-1
                        {
                            if let cb : CarteProtocol = self.grille[i + 1][j]
                            {
                                if cb.numero == c.numero{
                                    voisinDistinct = false
                                }
                            }
                        }
                        //Verification du voisin de gauche
                        if j > 0
                        {
                            if let cg : CarteProtocol = self.grille[i][j - 1]
                            {
                                if cg.numero == c.numero{
                                    voisinDistinct = false
                                }
                            }
                        }
                        //verification du voisin de droite 
                        if j < self.grille[i].count-1
                        {
                            if let cd : CarteProtocol = self.grille[i][j+1]
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
    //deplacer: Joueur x Direction x Carte x Int x Int -> Joueur
    //Insere la carte donnée en paramètre en fonction de la Direction aussi donnée en paramètre.
    //Les paramètres i et j représentent les coordonnées de ligne et de colonne de la case vide
    //Precondition : La grille doit avoir 1 et 1 seul élément nil.
    //Precondition : i == 0 => deplacement != Bas
    //Precondition : i == len(grille) - 1 => deplacement != Haut
    //Precondition : j == 0 => deplacement != Droite
    //Precondition : j == len(grille) - 1 => deplacement != Gauche
    public mutating func deplacer(deplacement : Direction, carte : CarteProtocol,i : Int, j : Int){
        guard(!(self.estComplet))else{
            fatalError("La grille doit avoir un élément vide")
        }
        let ligneTrou : Int = i 
        let colonneTrou : Int = j

        switch deplacement{

            case .Haut :
            if (ligneTrou==self.grille.count-1){
                print("déplacement impossible, veuillez séléctionner déplacement valide")
            }
            else {
                for k in ligneTrou ... self.grille.count-2{
                    self.grille[k][colonneTrou]=self.grille[k+1][colonneTrou]
                }
                self.grille[self.grille.count-1][colonneTrou]=carte
            }

            case .Bas :
            if (ligneTrou==0){
                print("déplacement impossible, veuillez séléctionner déplacement valide")
            }
            else {

                for l in stride(from:ligneTrou, to: 0, by: -1){
                    self.grille[l][colonneTrou]=self.grille[l-1][colonneTrou]          }
                self.grille[0][colonneTrou]=carte
            }

            case .Droite :
            if (colonneTrou==0){
                print("déplacement impossible, veuillez séléctionner déplacement valide")
            }
            else {

                for m in stride(from: colonneTrou, to:0, by: -1)
                {
                   self.grille[ligneTrou][m]=self.grille[ligneTrou][m-1]        
                }
                self.grille[ligneTrou][0]=carte
            }

            case .Gauche:
            if (colonneTrou==self.grille.count-1){
                print("déplacement impossible, veuillez séléctionner déplacement valide")
            }
            else {
                for n in colonneTrou...self.grille[0].count-2{
                    self.grille[ligneTrou][n]=self.grille[ligneTrou][n+1]             
                }
                self.grille[ligneTrou][self.grille.count-1]=carte

            }
        }
        self.coordCaseVide = (-1, -1)
    }

}
