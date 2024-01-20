import Foundation
import MapKit


struct Place : Identifiable {
    
    var id = UUID().uuidString
    var place: CLPlacemark
}
   
