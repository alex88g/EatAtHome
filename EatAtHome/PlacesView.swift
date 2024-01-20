import SwiftUI
import FirebaseStorage
import SDWebImageSwiftUI

struct PlacesView: View {
    
    var place: Places
    
    @StateObject var PlacesModel = PlacesViewModel()
    var body: some View {
        VStack{
            
            // Downloading image from web
            WebImage(url: URL(string: place.image))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.main.bounds.width - 30,height: 250)
            
            HStack(spacing: 8){
                
                Text(place.name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                Spacer(minLength: 0)
                
                // ratings view
                ForEach(1...5,id: \.self){index in
                    
                    Image(systemName: "star.fill")
                        .foregroundColor(index <= Int(place.ratings) ?? 0 ?
                                         Color(.red) : .gray)
                }
            }
            HStack{
                
                Text(place.details)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .lineLimit(2)
            }
                     HStack{
                         
                         Link(destination: URL(string: place.url)!) {
                             Text("Sök sidan")
                                 .font(.caption)
                                 .foregroundColor(.gray)
                                 .lineLimit(2)
                }
            }
        }
    }
}

