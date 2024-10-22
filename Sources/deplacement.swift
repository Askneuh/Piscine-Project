enum Direction {
    case Haut
    case Bas
    case Droite
    case Gauche }

var deplacementPossible : Bool = false
while deplacementPossible==false {
    //var deplacement : Direction ("entrer clavier : demander à l'utilisateur quel deplacement il souhaite effectuer")

    func deplacer(deplacement : Direction, carte : Carte)->[[Int?]]{
        let ligneTrou : Int = i // nom de la variable utilisée pour enlever une carte de la grille
        let colonneTrou : Int = j

        switch deplacement{

            case .Haut :
            if (ligneTrou==Grille.count-1){
                print("déplacement impossible, veuillez séléctionner déplacement valide")
                return Grille
            }
            else {
                deplacementPossible=true
                for i in ligneTrou ... Grille.count-2{
                    Grille[i][colonneTrou]=Grille[i+1][colonneTrou]         }
                return Grille
                Grille[Grille.count-1][colonneTrou]=carte
            }

            case .Bas :
            if (ligneTrou==0){
                print("déplacement impossible, veuillez séléctionner déplacement valide")
                return Grille
            }
            else {
                deplacementPossible=true 
                for i in stride(from:ligneTrou, to: 1, by: -1){
                    Grille[i][colonneTrou]=Grille[i-1][colonneTrou]          }
                return Grille
                Grille[0][colonneTrou]=carte
            }

            case.Droite :
            if (colonneTrou==0){
                print("déplacement impossible, veuillez séléctionner déplacement valide")
                return Grille
            }
            else {
                deplacementPossible=true
                for i in stride(from: colonneTrou, to:1, by: -1){
                   Grille[ligneTrou][i]=Grille[ligneTrou][i-1]             }
                return Grille
                Grille[ligneTrou][Grille.count-1]=carte
            }

            case .Gauche:
            if (colonneTrou==Grille.count-1){
                print("déplacement impossible, veuillez séléctionner déplacement valide")
                return Grille
            }
            else {
                deplacementPossible=true
                for i in colonneTrou...Grille[0].count-2{
                    Grille[ligneTrou][i]=Grille[ligneTrou][i+1]             }
                return Grille
                Grille[ligneTrou][0]=carte
            }
        }
    }
} 

