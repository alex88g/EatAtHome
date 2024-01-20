//
//  LocationsListView.swift
//  EatAtHomeExpress
//
//  Created by Alexander Gallorini on 2023-02-15.
//

import SwiftUI

struct LocationsListView: View {
    
    @EnvironmentObject private var vm: LocationsViewModel
    
    var body: some View {
        List{
            ForEach(vm.locations){ location in
                Button{
                    vm.showNextLocation(location: location)
                } label: {
                    listRowView(location: location)
                    }
                    .padding(.vertical, 4)
                    .listRowBackground(Color.clear)
             
                }
            }
        .listStyle(PlainListStyle())
        }
    }


struct LocationsListView_Previews: PreviewProvider {
    static var previews: some View {
        LocationsListView()
            .environmentObject(LocationsViewModel())
    }
}

extension LocationsListView {
    
    private func listRowView(location: Location) -> some View{
        
        
        HStack{
            
            if let image = location.image.first{
                Image(image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 45,height: 45)
                    .cornerRadius(10)
            }
            VStack(alignment: .leading){
                Text(location.name)
                    .font(.headline)
                Text(location.restaurant)
                    .font(.subheadline)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
