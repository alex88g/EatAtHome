import SwiftUI
import Firebase


struct ContentView: View {
    @State var show = false
    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
    
    @AppStorage("isDarkMode") private var isDarkMode = false
    var body: some View {
        NavigationView{
            
            VStack{
                
                if self.status{
                    Home()
                }
                else{
                    
                    ZStack{
                        
                        NavigationLink(destination: SignUp(show: self.$show), isActive: self.$show) {
                            
                            Text("")
                        }
                        .hidden()
                    }
                    Login(show: self.$show)
                }
            }
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onAppear{
            
            NotificationCenter.default.addObserver(forName: NSNotification.Name("status"), object: nil, queue: .main){
                (_) in self.status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
            }
        }
    }
}
struct ContentView_Previews: PreviewProvider {
        
        static var previews: some View {
            ContentView()
//                .environmentObject(HomeModel())
           Home()
            
           
             
               
            
            
            
            
        }
        
    }
        

