import SwiftUI

struct CardView<Content>: View where Content: View {
   
    var content: () -> Content
        
    var body: some View {
      content()
    }
}
struct CreditCardFront: View{
    @Environment(\.presentationMode) var present
    
    let name: String
    let expires: String
    let number: String
    
    var body: some View{
        HStack(spacing: 20){
            
            Button(action:{present.wrappedValue.dismiss()}) {
                
                Image(systemName: "x.circle.fill")
                    .font(.system(size: 26, weight: .heavy))
                    .foregroundColor(Color(.red))
                
                Spacer()
                
            }.padding()
        }

        VStack(alignment: .leading){
            
            HStack(alignment: .top){
                
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(Color.white)
                    .padding(.vertical, 5)
                    .padding(.horizontal, 5)
                
                Spacer()
                
                Text("VISA")
                    .foregroundColor(Color.white)
                    .font(.system(size: 24))
                    .fontWeight(.bold)
                    .padding(.vertical, 5)
                    .padding(.horizontal, 5)
             }
                Spacer()
            
            Text("**** **** **** 0000")
                .foregroundColor(Color.white)
                .font(.system(size: 32))
                .padding(.vertical, 5)
                .padding(.horizontal, 5)
        
            Text(number)
                .font(.caption)
                .foregroundColor(Color.white)
                .fontWeight(.bold)
            
            Spacer()
            
            HStack{
                 
                VStack(alignment: .leading){
                    Text("VALID THRU")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(Color.gray)
                    .padding(.vertical, 5)
                    .padding(.horizontal, 5)
                
                    Text(name)
                        .font(.caption)
                        .foregroundColor(Color.white)
                        .fontWeight(.bold)
                }
                Spacer()
                
                VStack{
                    
                    Text("MONTH/YEAR")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(Color.gray)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 5)
                    Text(expires)
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                }
            }
        }
        .navigationBarBackButtonHidden()
        .frame(width: 300,height: 200)
            .background(LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(10)
    }
}
struct CreditCardBack: View{
    
    let cvv: String
    
    var body: some View{
        VStack{
            
            Rectangle()
                .frame(maxWidth: .infinity,maxHeight: 20)
                .padding([.top])
            
            Spacer()
            
            HStack{
                
                Text(cvv).foregroundColor(Color.black)
                    .rotation3DEffect(.degrees(180), axis: (x: 0.0, y: 1.0, z: 0.0))
                    .padding(5)
                    .frame(width: 100,height: 20)
                    .background(Color.white)
                
                Spacer()
                
            .navigationBarHidden(false)
            }
            .padding()
        }
        .frame(width: 300, height: 200)
            .background(LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(10)
    }
}
struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView<CreditCardFront>(content: { CreditCardFront(name: "Alexander Gallorini", expires: "02/06", number: "**** **** **** 0000") } )
    }
}
struct onTap: View{
    
    @State private var degrees: Double = 0
    @State private var flipped: Bool = false
    @State private var name: String = ""
    @State private var expires: String = ""
    @State private var number: String = ""
    @State private var cvv: String = ""

    var body: some View{
        VStack {
           
            CardView{
              
                VStack{
                    Group{
                        if flipped {
                            CreditCardBack(cvv: cvv)
                        }else{
                            CreditCardFront(name: name, expires: expires, number: number)
                        }
                    }
                }
                .rotation3DEffect(.degrees(degrees), axis: (x: 0.0, y: 1.0, z: 0.0)
                )
            }.onTapGesture {
                withAnimation{
                    degrees += 180
                    flipped.toggle()
                    
                }
            }
            
            
            TextField("Bankkort", text: $number)
                  .textFieldStyle(RoundedBorderTextFieldStyle())
                  .padding([.top,.leading,.trailing])
            
            TextField("Namn och fternamn", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding([.top,.leading,.trailing])
            
            TextField("Utgångsdatum", text: $expires)
                  .textFieldStyle(RoundedBorderTextFieldStyle())
                  .padding([.top,.leading,.trailing])
            
            TextField("CVV", text: $cvv) { (editingChanged) in
                if editingChanged{
                    withAnimation{
                        degrees += 180
                        flipped.toggle()
                    }
                }else{
                    withAnimation{
                        degrees += 180
                        flipped.toggle()
                    }
                }
            } onCommit: {
        }
            .textFieldStyle(RoundedBorderTextFieldStyle())
                  .padding([.top,.leading,.trailing])
                 
            
        } .background(Color("").ignoresSafeArea())
            .navigationBarHidden(false)
            .navigationBarBackButtonHidden(true)
    }
}
