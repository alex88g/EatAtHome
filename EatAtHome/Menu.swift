import SwiftUI
import Firebase

struct Menu: View {
    @ObservedObject var homeData : HomeViewModel
    
    @StateObject private var vm = LocationsViewModel()
    
    @State var color = Color.black
    
    @AppStorage("isDarkMode") private var isDarkMode = false
    var body: some View {
        VStack{
            NavigationLink(destination: CartView(homeData: homeData)){
                
                HStack(spacing: 15){
                    
                    Image(systemName: "cart")
                        .font(.title)
                        .foregroundColor(Color("red"))
                    
                    Text("Varukorg")
                        .fontWeight(.bold)
                    Spacer(minLength: 0)
                    
                        
                    }
                    .padding()
                }
                Spacer()
                
            
                    Button(action: {
                        
                        
                    }){
                        NavigationLink(destination: Restaurants()){
                            Image(systemName: "house.lodge.circle")
                                .foregroundColor(.red)
                            
                            Text("Bokningar")
                        }
                        .padding()
                        Spacer()
                    }
                        Button(action: {
                            
                        }){
                            NavigationLink(destination: LocationsView().environmentObject(vm)){
                                Image(systemName: "map")
                                    .foregroundColor(.red)
                                
                                Text("Restauranger")
                            }
                            .padding()
                            Spacer()
                        }
                            
                
                Button(action: {
                    
                }){
                    NavigationLink(destination: SwitchView()){
                        Image(systemName: "gearshape")
                            .fontWeight(.heavy)
                            .foregroundColor(.red)
                        
                        Text( "Inställningar")
                        
                    }
                    .padding()
                    Spacer()
                }
                Button(action: {
                }){
                    NavigationLink(destination: PickerView()){
                        Image(systemName: "questionmark.circle")
                            .fontWeight(.heavy)
                            .foregroundColor(.red)
                        
                        Text( "Hjälpcenter")
                    }
                    .padding()
                    Spacer()
                }
                
            Spacer()
                
                .padding(.vertical, 200)
               
            //Logout button
                Button(action: {
                    
                    try! Auth.auth().signOut()
                    UserDefaults.standard.set(false, forKey: "status")
                    NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                    
                }){
                    
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                    
                        .padding(.horizontal)
                        .fontWeight(.heavy)
                        .foregroundColor(.red)
                    
                    Text( "Logga ut")
                        .fontWeight(.heavy)
                }
            }
            
            .padding(10)
            .accentColor(.primary)
            .padding([.top,.trailing])
            .frame(width: UIScreen.main.bounds.width / 1.6)
            .background((self.isDarkMode ? Color.black : Color.white).edgesIgnoringSafeArea(.all)).overlay(Rectangle().stroke(Color.primary, lineWidth: 2).shadow(radius: 3).edgesIgnoringSafeArea(.all))
            
        }}


    
