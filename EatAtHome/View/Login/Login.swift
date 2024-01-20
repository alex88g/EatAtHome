import SwiftUI
import Firebase

struct Login: View {
    @State var color = Color.black.opacity(0.7)
    @State var email = ""
    @State var pass = ""
    @State var visible = false
    @Binding var show : Bool
    @State var alert = false
    @State var error = ""
    
    var body: some View {
        
        ZStack{
            
            ZStack(alignment: .topTrailing) {
                
                GeometryReader{_ in
                    
                    VStack{
                    }
                    // the background that is appropriate for the app
                    Color.red
                        .ignoresSafeArea()
                        .padding(.top, -20)
                        
                    Circle()
                        .scale(1.6)
                        .foregroundColor(.white.opacity(0.15))
                    Circle()
                        .scale(1.25)
                        .foregroundColor(.white)
                        .padding(.top, 250)
                    
                    GeometryReader{_ in
                        
                        VStack{
                            // App logo
                            Image("logo")
                                .padding(.top, 35)
                            
                            // Information about log in
                            Text("Logga in på ditt konto")
                                .font(.title)
                                .fontWeight(.bold)
                                .padding(.top, 15)
                            
                            // TextField for entering email
                            TextField("Email", text: self.$email)
                                .autocapitalization(.none)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 15).stroke(self.email != "" ? Color("red") : self.color,lineWidth: 2))
                                .padding(.top, 25)
                                .foregroundColor(Color.black)
                            
                            HStack(spacing: 10){
                                
                                VStack {
                                    
                                    if self.visible{
                                        
                                        //TextField with entering a paswword
                                        TextField("Lösenord", text: self.$pass)
                                            .autocapitalization(.none)
                                            .foregroundColor(Color.black)
                                    }
                                    else{
                                            SecureField("Lösenord", text: self.$pass)
                                            .autocapitalization(.none)
                                            .foregroundColor(Color.black)
                                    }
                                }
                                
                                // Button with hide and visible eye slash
                                Button(action: {
                                    
                                    self.visible.toggle()
                                }) {
                                    Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill")
                                        .foregroundColor(self.color)
                                }
                            }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 15).stroke(self.pass != "" ? Color("red") : self.color,lineWidth: 2))
                            .padding(.top, 25)
                            
                             HStack{
                                
                                Spacer()
                                
                                 // Forget password button
                                Button(action: {
                                    self.reset()
                                }){
                                    Text("Glömt lösenord")
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.red)
                                }
                            }
                            .padding(.top, 20)
                            
                            Button(action: {
                                self.verify()
                            }){
                                // Log in button
                                Text("Logga in")
                                    .foregroundColor(.white)
                                    .padding(.vertical)
                                    .frame(width: UIScreen.main.bounds.width - 50)
                            }
                            .background(Color.red)
                            .cornerRadius(15)
                            .padding(.top, 25)
                        }
                        .padding(.horizontal, 25)
                    }
                    // button for register
                    Button(action: {
                         self.show.toggle()
                    }){
                        Text("Skapa konto")
                            .fontWeight(.bold)
                            .foregroundColor(self.color)
                    }
                    .padding(.top, 550)
                    .padding(.horizontal, 30)
                }
            }
            // Shows error alert
            if self.alert{
                    ErrorView(alert: self.$alert, error: self.$error)
            }
        }
    }
    func verify(){
        
        if self.email != "" && self.pass != ""{
            //here shows that you have successfully changed password with firebase
            Auth.auth().signIn(withEmail: self.email, password: self.pass) { (res,
                                                                              err) in
                if err != nil{
                    
                    self.error = err!.localizedDescription
                    self.alert.toggle()
                    return
                }
                //UserDefaults saves the log in when you exit the app
                print("success")
                UserDefaults.standard.set(true, forKey: "status")
                NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
            }
        }
        else {
            // Must fill in all information correctly when logging with firebase
            self.error = "Vänligen fyll i allt inehåll ordentligt"
            self.alert.toggle()
        }
    }
    func reset(){
        
        if self.email != "" {
            //Here you confirm your email if you have forgotten your password
            Auth.auth().sendPasswordReset(withEmail: self.email) { (err) in
                
                if err != nil{
                    
                    self.error = err!.localizedDescription
                    self.alert.toggle()
                    return
                    
                }
                self.error = "ÅTERSTÄLLA"
                self.alert.toggle()
            }
        }
        else{
            // Email must be filled in correctly
            self.error = "Email Id är tom"
            self.alert.toggle()
        }
    }
}
