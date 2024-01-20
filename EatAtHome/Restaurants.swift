import SwiftUI
import Firebase

struct Restaurants: View {
    @Environment(\.presentationMode) var present

    @StateObject var placesModel = PlacesViewModel()
    
    var body: some View {
        
        HStack(spacing: 20){
            
            Button(action:{present.wrappedValue.dismiss()}) {
                
                Image(systemName: "chevron.left")
                    .font(.system(size: 26, weight: .heavy))
                    .foregroundColor(Color(.red))
             
                Spacer()
            }
            .padding()
        }
        ZStack{
         
            VStack(){
                
                Divider()

                HStack(){
                    
                    TextField("Sök restauranger för bokningar", text: $placesModel.search)
                    
                        .colorScheme(.light)
                        .padding(.vertical, 10)
                        .padding(.horizontal)
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(radius: 10)
                    
                    
                    Spacer()
                    
                    
                    if placesModel.search != ""{
                        
                        Button(action: {}, label: {
                            
                            Image(systemName:  "magnifyingglass")
                                .font(.title2)
                                .foregroundColor(.gray)
                        })
                        .animation(.easeIn)
                    }
                }
                
                .padding(.horizontal)
                
                Divider()
                
                if placesModel.place.isEmpty{
                    
                    Spacer()
                    
                    ProgressView()
                    
                    Spacer()
                }
                else{
                    ScrollView(.vertical, showsIndicators: false, content: {
                        
                        VStack(spacing: 25){
                            
                            ForEach(placesModel.filtered){ place in
                                
                                // places view
                                
                                ZStack(alignment: Alignment(horizontal: .center, vertical: .top), content: {
                                    
                                    PlacesView(place: place)
                                    
                                    HStack{
                                        
                                        Text("Boka din favorit stället")
                                            .foregroundColor(.black)
                                            .padding(.vertical,10)
                                            .padding(.horizontal)
                                            .background(Color(.yellow))
                                        
                                        Spacer(minLength: 0)
                                        

                                    }
                                    .padding(.trailing,10)
                                    .padding(.top,10)
                                    
                                })
                                
                                .frame(width: UIScreen.main.bounds.width - 30)
                                .foregroundColor(.red)
                                .cornerRadius(15)
                                .shadow(radius: 10)
                            }
                        }
                        .padding(.top, 10)
                     })
                    
                }
                
            }
            
        }.navigationBarBackButtonHidden(true)
        .onAppear(perform: {
            // calling location delegate
            placesModel.locationManager.delegate = placesModel
        })
        .onChange(of: placesModel.search, perform: { value in
            
            // to avoid continues search request
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                
                if value == placesModel.search && placesModel.search != ""{
                    
                    // search data
                    
                    placesModel.filterData()
                }
            }
            if placesModel.search == ""{
                // reset all data
                withAnimation(.linear){placesModel.filtered = placesModel.place}
            }
        })
    }
}

