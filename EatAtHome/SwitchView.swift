import SwiftUI

struct SwitchView: View {
    
    @Environment(\.presentationMode) var present
    
    @AppStorage("isDarkMode") private var isDarkMode = false
    var body: some View {
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
                Picker("Mode", selection: $isDarkMode){
                    Text("Light")
                        .tag(false)
                    Text("Dark")
                        .tag(true)
                    
                }.pickerStyle(SegmentedPickerStyle())
                    .padding()
                
            Spacer()
            
        }.navigationBarBackButtonHidden(true)
    }
}
struct SwitchView_Previews: PreviewProvider {
    static var previews: some View {
        SwitchView()
    }
}
