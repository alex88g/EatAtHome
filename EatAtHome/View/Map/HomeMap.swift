import SwiftUI
import CoreLocation
import MapKit


struct HomeMap: View {
    
    @Environment(\.presentationMode) var present
    @StateObject var mapData = MapViewModel()
    //location manager
    @State var locationManager = CLLocationManager()

   var body: some View{
            ZStack{
                    MapView()
                    //using it as evironment object so that it can be used ints subViews
                        .environmentObject(mapData)
                        .ignoresSafeArea(.all, edges: .all)
                    
                    VStack{
                        
                        HStack(spacing: 20){
                            
                            Button(action:{present.wrappedValue.dismiss()}) {
                               
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 26, weight: .heavy))
                                    .foregroundColor(Color(.red))
                                
                                Spacer()
                              }
                            .padding()
                        }
                      VStack{
                            
                          VStack{
                                
                                Button(action: mapData.focusLocation, label: {
                                    
                                    Image(systemName: "location.fill")
                                        .font(.title2)
                                        .padding(10)
                                        .background(Color(.white).opacity(0.25))
                                        .clipShape(Circle())
                                        .foregroundColor(.red)
                                        .shadow(radius: 10)
                                })
                                
                                Button(action: mapData.updateMapType, label: {
                                    
                                    Image(systemName: mapData.mapType ==
                                        .standard ? "map.fill" : "map")
                                    .font(.title2)
                                    .padding(10)
                                    .background(Color(.white).opacity(0.25))
                                    .clipShape(Circle())
                                    .foregroundColor(.red)
                                    .shadow(radius: 10)
                                    
                                })
                            }
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.top)
                            .padding()
                            
                            Spacer()
                        
                          VStack{
                                
                                VStack(spacing:0){
                                    
                                    HStack{
                                        
                                        Image(systemName: "magnifyingglass")
                                            .foregroundColor(.gray)
                                        
                                        TextField("Sök i kartor", text: $mapData.searchTxt)
                                            .colorScheme(.light)
                                        
                                    }
                                    .padding(.vertical, 10)
                                    .padding(.horizontal)
                                    .background(.white)
                                    .cornerRadius(10)
                                    .shadow(radius: 10)
                                    
                                    //displaying results
                                    
                                    if !mapData.places.isEmpty && mapData.searchTxt
                                        != ""{
                                        
                                        ScrollView{
                                            
                                            VStack(spacing: 15){
                                                
                                                ForEach(mapData.places){ place in
                                                    
                                                    Text(place.place.name ?? "")
                                                    
                                                        .foregroundColor(.black)
                                                        .frame(maxWidth: .infinity,alignment: .leading)
                                                        .padding(.leading)
                                                        .onTapGesture {
                                                            mapData.selectPlace(place: place)
                                                        }
                                                    
                                                    Divider()
                                                    
                                                }
                                                
                                            }
                                            .padding(.top)
                                        }
                                        .background(Color.white)
                                        .shadow(radius: 10)
                                    }
                                    
                                }
                                .padding()
                                
                            }
                            
                        }
                        
                        .onAppear(perform: {
                            //settings delegate
                            locationManager.delegate = mapData
                            locationManager.requestWhenInUseAuthorization()
                            
                        })
                        //permission denied alert
                        .alert(isPresented: $mapData.permissionDenied, content: {
                            
                            Alert(title: Text("Åtkomst nekad"), message: Text("Vänligen Aktivera Behörighet i Appens Inställningar "), dismissButton: .default(Text("Gå till inställningar"), action: {
                                
                                //redigering user to settings
                                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                                
                            }))
                        })
                        
                        .onChange(of: mapData.searchTxt, perform: { value in
                            
                            //searching places
                            
                            //you can use your own delay time to avoid continous search request
                            
                            let delay = 0.3
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + delay)
                            {
                                
                                if value == mapData.searchTxt{
                                    
                                    //search
                                    self.mapData.searchQuery()
                                    
                                }
                            }
                            
                            
                        })
                    }.navigationBarBackButtonHidden(true)
                }
            }
        }
