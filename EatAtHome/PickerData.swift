import SwiftUI
import Firebase
import FirebaseAuth

struct PickerData: View {
    @State var signedIn = false
    
    var body: some View {
        if !signedIn {
            SigningInView(signedIn: $signedIn)
        } else   {
            ShoppinListView()
        }
    }
}
struct SigningInView: View {
    @Binding var signedIn : Bool
    
    var body: some View {
        
        Text("Not working signing in")
            .onAppear(){
                Auth.auth().signInAnonymously { authResult, error in
                    if let error = error {
                        print("error signing in \(error)")
                        
                    } else {
                        print("Signed in \(Auth.auth().currentUser?.uid)")
                        signedIn = true
                }
            }
        }
    }
}
struct ShoppinListView: View {
    let db = Firestore.firestore()
    
    @State var items = [Itemm]()
    
    var body: some View {
        VStack {
            List {
                ForEach(items) { item in
                    ItemRowView(item: item)
                }.onDelete() { indexSet in
                    for index in indexSet {
                        let item = items[index]
                        if let id = item.id,
                           let user = Auth.auth().currentUser
                        {
                            db.collection("users").document(user.uid).collection("Case").document(id).delete()
                        }
                    }
                }
            }
        }.onAppear() {
//            saveToFirestore(itemName: "" )
            listenToFirestore()
        }
        .padding()
    }
    func saveToFirestore(itemName: String) {
        let item = Itemm(name: itemName)
        guard let user = Auth.auth().currentUser else {return}
        
        do {
            _ = try db.collection("users").document(user.uid).collection("Case").addDocument(from: item)
        } catch {
            print("Error saving to DB")
        }
    }
    
    func listenToFirestore() {
        
        guard let user = Auth.auth().currentUser else {return}
        
        db.collection("users").document(user.uid).collection("Case").addSnapshotListener { snapshot, err in
            guard let snapshot = snapshot else {return}
            
            if let err = err {
                print("Error getting document \(err)")
            } else {
                items.removeAll()
                for document in snapshot.documents {

                    let result = Result {
                        try document.data(as: Itemm.self)
                    }
                    switch result  {
                    case .success(let item)  :
                        items.append(item)
                    case .failure(let error) :
                        print("Error decoding item: \(error)")
                    }
                }
            }
        }
    }
}
struct ItemRowView: View {
    let db = Firestore.firestore()
    
    let item : Itemm
    
    var body: some View {
        HStack {
            Text(item.name)
            Spacer()
            Button(action: {
                if let id = item.id,
                   let user = Auth.auth().currentUser
                {
                    db.collection("users").document(user.uid)
                        .collection("Case").document(id).updateData(["done": !item.done])
                }
            }) {
                
                Image(systemName: item.done ? "checkmark.square" : "square")
            }
        }
    }
}
