import Foundation
import SwiftUI
import MapKit


class LocationsViewModel: ObservableObject {
    // All loaded locations
    @Published var locations: [Location]
    //current location on map
    @Published var mapLocation: Location {
        didSet{
            updateMapRegion(location: mapLocation)
        }
    }
    //current region on map
    @Published var mapRegion: MKCoordinateRegion = MKCoordinateRegion()
    let mapSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    
    //show list of locations
    @Published var showLocationsList: Bool = false
    
    // show location detail via sheet
    @Published var sheetLocation: Location? = nil
    
    init(){
        //initialize data
        let locations = LocationsDataService.locations
        self.locations = locations
        self.mapLocation = locations.first!
        //then we call class mapRegion from blank to current location
        self.updateMapRegion(location: locations.first!)
    }
    private func updateMapRegion(location: Location){
        mapRegion = MKCoordinateRegion(center: location.coordinates, span: mapSpan)
    }
    
    func toggleLocationsList() {
        withAnimation(.easeOut){
            showLocationsList = !showLocationsList
        }
    }
    func showNextLocation(location: Location){
        withAnimation(.easeInOut){
            mapLocation = location
            showLocationsList = false
        }
    }
    func nextButtonPressed(){
        //get current index
        guard let currentIndex = locations.firstIndex(where: { $0 == mapLocation}) else {
            print("Could not find current index in locations array should never happen.")
            return
        }
        //check if current index is valid
        
        let nextIndex = currentIndex + 1
        guard locations.indices.contains(nextIndex) else {
            //next index is not valid
            // restart from 0
            guard let firstLocation = locations.first else {return}
            showNextLocation(location: firstLocation)
            return
        }
        //next index is valid
        let nextLocation = locations[nextIndex]
        showNextLocation(location: nextLocation)
    }
}


