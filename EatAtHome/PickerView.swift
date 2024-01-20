import SwiftUI
import FirebaseStorage
import FirebaseFirestore
import Firebase


struct PickerView: View {
    @State var shown = false
    @State var beskrivning = ""
    
    @Environment(\.presentationMode) var present
    
    var body: some View {
        VStack(){
            
            Button(action:{present.wrappedValue.dismiss()}) {
                
                Image(systemName: "chevron.left")
                    .font(.system(size: 26, weight: .bold))
                
                Spacer()
            }
            .padding()
            
            Button(action: {
                
            }){
                NavigationLink(destination: CameraView()){
                    Image(systemName: "camera.fill")
                        .font(.system(size: 30, weight: .bold))
                }}
            
            Text("Beskriv kort din händelse, så tar vi hand om ditt ärende")
                .fontWeight(.bold)
            
            TextField("", text: self.$beskrivning)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .colorScheme(.light)
            
            Button(action: {
                saveToFirestore(itemName: beskrivning)
            }){
                
                Text("Skicka")
            }
            
            Spacer()
            
            Button(action: {
                
            }){
                NavigationLink(destination: PickerData()){
                    Image(systemName: "list.bullet.clipboard")
                        .fontWeight(.heavy)
                        .foregroundColor(.red)
                }
                    Text( "Pågående ärende")
                        .foregroundColor(.gray)
                    
                    
                }  .padding()
                Spacer()
            }
            Button(action: {
                self.shown.toggle()
            }){
                Text("Ladda upp bilden")
                
            }.sheet(isPresented: $shown) {
                
                imagePicker(shown: self.$shown)
            }
            .navigationBarBackButtonHidden(true)
        }
    }
func saveToFirestore(itemName: String) {
    
    let db = Firestore.firestore()
    
    let item = Itemm(name: itemName)
    guard let user = Auth.auth().currentUser else {return}
    
    do {
        _ = try db.collection("users").document(user.uid).collection("Case").addDocument(from: item)
    } catch {
        print("Error saving to DB")
    }
}
struct imagePicker : UIViewControllerRepresentable {
    
    func makeCoordinator() -> imagePicker.Coordinator {
        
        return imagePicker.Coordinator(parent1: self)
    }
    @Binding var shown : Bool
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<imagePicker>) -> UIImagePickerController {
        
        
        let imagepic = UIImagePickerController()
        imagepic.sourceType = .photoLibrary
        imagepic.delegate = context.coordinator
        return imagepic
    }
    func updateUIViewController(_ uiViewController: UIImagePickerController, context:
                                UIViewControllerRepresentableContext<imagePicker>) {
    }
    class Coordinator : NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        var parent : imagePicker!
        
        init(parent1 : imagePicker) {
            
            parent = parent1
           }
           func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:
                                       [UIImagePickerController.InfoKey : Any]) {
                
                let image = info[.originalImage] as! UIImage
                let storage = Storage.storage()
                storage.reference().child("Case").putData(image.jpegData(compressionQuality: 0.35)!, metadata:
                nil){ (_, err) in
                    
                    if err != nil{
                        
                        print((err?.localizedDescription)!)
                        return
                    }
                    print("success")
                }
                parent.shown.toggle()
               
           }
        }
    }
