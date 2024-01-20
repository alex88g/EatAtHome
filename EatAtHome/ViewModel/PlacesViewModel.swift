import SwiftUI
import CoreLocation
import Firebase

// Fetching User Location
class PlacesViewModel: NSObject,ObservableObject,CLLocationManagerDelegate {
    @Published var locationManager = CLLocationManager()
    @Published var search = ""
    
    //Location details
    @Published var userLocation : CLLocation!
    @Published var userAdress = ""
    @Published var noLocation = false
    
    // placesData
    @Published var place: [Places] = []
    @Published var filtered: [Places] = []
    
    @Published var show = false
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        // checking location Access
        switch manager.authorizationStatus{
        case.authorizedWhenInUse:
            print("authorized")
            self.noLocation = false
            manager.requestLocation()
        case .denied:
            print("denied")
            self.noLocation = true
        default:
            print("unknown")
            self.noLocation = false
            
            // direct call
            locationManager.requestWhenInUseAuthorization()
            // modifying info.plist
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // reading user Location and extracting details
        self.userLocation = locations.last
        self.extractLocation()
       
        // after extracting location logging in
        self.login()
    }
    func extractLocation(){
        
        CLGeocoder().reverseGeocodeLocation(self.userLocation) { (res, err) in
            
            guard let safeData = res else{return}
            
            var address = ""
            
            // getting area and locality name
            address += safeData.first?.name ?? ""
            address += ", "
            address += safeData.first?.locality ?? ""
            
            self.userAdress = address
        }
    }
    // anynomus login for reading database
    func login(){
        
        Auth.auth().signInAnonymously{ (res, err) in
            
            if err != nil{
                print(err!.localizedDescription)
                return
            }
            print("Success = \(res!.user.uid)")
            
            // after logging in fetching data
            self.fetchData()
        }
    }
    // fetching itemsData
        func fetchData(){
            
            let db = Firestore.firestore()
            
            db.collection("Places").getDocuments{ (snap, err)in
                
                guard let itemData = snap else{return}
                
                self.place = itemData.documents.compactMap({(doc) -> Places? in
                    
                    let id = doc.documentID
                    let name = doc.get("name") as! String
                    let longitude = doc.get("longitude") as! String
                    let latitude = doc.get("latitude") as! String
                    let ratings = doc.get("ratings") as! String
                    let image = doc.get("image") as! String
                    let details = doc.get("details") as! String
                    let url = doc.get("url") as! String
                    
                    return Places(id: id,name: name, longitude: longitude, latitude: latitude, ratings: ratings, image: image, details: details, url: url)
                 })
                 self.filtered = self.place
            }
        }
    // search or filter
    func filterData(){
        
        withAnimation(.linear){
            
            self.filtered = self.place.filter{
                return $0.name.lowercased().contains(self.search.lowercased())
            }
        }
    }
}

