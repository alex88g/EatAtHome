import SwiftUI
import SDWebImageSwiftUI

struct CartView: View {
    @ObservedObject var homeData: HomeViewModel
    @Environment(\.presentationMode) var present
    
    var body: some View {
        VStack{
            
            HStack(spacing: 20){
                
                Button(action:{present.wrappedValue.dismiss()}) {
                    
                    Image(systemName: "chevron.left")
                        .font(.system(size: 26, weight: .heavy))
                }
                Text("Min vagn")
                    .font(.title)
                    .fontWeight(.heavy)
                
                Spacer()
            }
            .padding()
            
            ScrollView(.vertical, showsIndicators: false){
                
                LazyVStack(spacing: 0){
                    
                    ForEach(homeData.cartItems){ cart in
                        
                        // CartItemView
                        
                        HStack(spacing: 15){
                            
                            WebImage(url: URL(string: cart.item.item_image))
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 130, height: 130)
                                .cornerRadius(15)
                                .shadow(radius: 10)
                            
                                .background(Color(UIColor.secondarySystemBackground).cornerRadius(15))
                            
                            
                            VStack(alignment: .leading, spacing: 10){
                                
                                Text(cart.item.item_name)
                                    .fontWeight(.semibold)
                                    .shadow(radius: 10)
                                
                                Text(cart.item.item_details)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.gray)
                                    .lineLimit(2)
                                    .shadow(radius: 10)
                                
                                HStack(spacing: 15){
                                    
                                    Text(homeData.getPrice(value: Float(truncating: cart.item.item_cost)))
                                        .font(.title2)
                                        .fontWeight(.heavy)
                                        .shadow(radius: 10)
                                    
                                    Spacer(minLength: 0)
                                    
                                    // add - sub button
                                    Button(action: {
                                        if cart.quantity > 1{
                                            homeData.cartItems [homeData.getIndex(item: cart.item,isCartIndex: true) ].quantity -= 1
                                            
                                        }
                                        
                                    }) {
                                        
                                        Image(systemName: "minus")
                                            .font(.system(size: 16, weight: .heavy))
                                            .shadow(radius: 10)
                                        
                                        
                                    }
                                    Text("\(cart.quantity)")
                                        .fontWeight(.heavy)
                                        .foregroundColor(.gray)
                                        .padding(.vertical,5)
                                        .padding(.horizontal,10)
                                        .shadow(radius: 10)
                                    
                                    Button(action: {
                                        
                                        homeData.cartItems [homeData.getIndex(item: cart.item,isCartIndex: true) ].quantity += 1
                                    }) {
                                        
                                        Image(systemName: "plus")
                                            .font(.system(size: 16, weight: .heavy))
                                            .shadow(radius: 10)
                                    }
                                }
                            }
                            .padding()
                            .contextMenu{
                                
                                // for deleting
                                Button(action: {
                                    // deleting items from cart
                                    let index = homeData.getIndex(item: cart.item, isCartIndex: true)
                                    let itemIndex = homeData.getIndex(item: cart.item, isCartIndex: false)
                                    
                                    homeData.items[itemIndex].isAdded = false
                                    homeData.filtered[itemIndex].isAdded = false
                                    
                                    homeData.cartItems.remove(at: index)
                                    
                                }){
                                    Text("Ta bort")
                                }
                            }
                        }
                    }
                }
                
                // Bottom view
                VStack{
                    
                    HStack{
                        
                        Text("Total kostnad:")
                            .fontWeight(.heavy)
                        
                        Spacer()
                        
                        //calculating total price
                        Text(homeData.calculateTotalPrice())
                            .font(.title)
                            .fontWeight(.heavy)
                    }
                    .padding([.top,.horizontal])
                    
                    Button(action: homeData.updateOrder) {
                        
                        
                        Text(homeData.ordered ? "Avbryt" : "Bekräfta")
                        
                            .font(.title2)
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                            .padding(.vertical)
                            .padding(.bottom, 0)
                            .frame(width: UIScreen.main.bounds.width - 30)
                            .background(Color(.red))
                            .cornerRadius(15)
                        
                    }
                    
                    Button(action: {
                        
                    }){
                        NavigationLink(destination: onTap()){
                            
                            Text("Lägg till kort betalning")
                            
                                .padding(.bottom, 5)
                                .padding(.leading)
                                .fontWeight(.bold)
                                .foregroundColor(.gray)
                            
                            Image(systemName: "creditcard.circle").resizable()
                            
                                .frame(width: 30, height: 30)
                                .foregroundColor(.gray)
                                .padding(.bottom, 5)
                                .padding(.leading, -240)
                            }
                        }
                    }
                    .background(Color(UIColor.secondarySystemBackground))
                    .shadow(radius: 10)
                    .cornerRadius(15)
                    
                    Spacer()
                }
                .background(Color("").ignoresSafeArea())
                .shadow(radius: 10)
                .cornerRadius(15)
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
            }
        }
    }

