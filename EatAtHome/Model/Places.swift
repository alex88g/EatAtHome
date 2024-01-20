import SwiftUI


struct Places: Identifiable {
    
    var id: String
    var name: String
    var longitude: String
    var latitude: String
    var ratings: String
    var image: String
    var details: String
    var url: String
    
    var isAdded: Bool = false
}
