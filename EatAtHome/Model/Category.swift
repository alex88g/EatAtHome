import SwiftUI

struct Category: Identifiable {
    
    var id: String = UUID().uuidString
    var image: String
    var title: String
}

var categories = [
    
    Category(image: "pasta", title: "Pasta"),
    Category(image: "pizza", title: "Pizza"),
    Category(image: "dricka", title: "Dricka"),
    Category(image: "förrätt", title: "Förrätt"),
    Category(image: "efterrätt", title: "Efterrätt"),
]
