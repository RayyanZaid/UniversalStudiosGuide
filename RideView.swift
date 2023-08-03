

    


import SwiftUI
import FirebaseFirestore

struct Ride: Identifiable {
    var id: Int
    var name: String
    var isSelected: Bool
}

struct RideView: View {
    var email: String
    
    @State private var rides = [
               Ride(id: 6045, name: "Despicable Me Minion Mayhem", isSelected: false),
               Ride(id: 6046, name: "DinoPlay", isSelected: false),
               Ride(id: 6047, name: "Flight of the Hippogriff™", isSelected: false),
               Ride(id: 6048, name: "Harry Potter and the Forxbidden Journey™", isSelected: false),
               Ride(id: 6049, name: "Jurassic World — The Ride", isSelected: false),
               Ride(id: 6057, name: "Kung Fu Panda Adventure", isSelected: false),
               Ride(id: 11513, name: "Mario Kart™: Bowser’s Challenge", isSelected: false),
               Ride(id: 6056, name: "Ollivanders™", isSelected: false),
               Ride(id: 6050, name: "Revenge of the Mummy – The Ride", isSelected: false),
               Ride(id: 6051, name: "Studio Tour", isSelected: false),
               Ride(id: 12038, name: "Super Nintendo World™ Power-Up Band™ & App", isSelected: false),
               Ride(id: 6052, name: "Super Silly Fun Land", isSelected: false),
               Ride(id: 7332, name: "The Secret Life of Pets: Off the Leash", isSelected: false),
               Ride(id: 6053, name: "The Simpsons Ride™", isSelected: false),
               Ride(id: 6055, name: "TRANSFORMERS™: The Ride-3D", isSelected: false)
           ]
    
    
    var body: some View {
        VStack {
            Text("Select rides")
                .font(.custom("Chalkboard SE", size: UIScreen.main.bounds.width * 0.09).bold())
                .frame(maxWidth: .infinity, alignment: .center)
                .foregroundColor(.white)
            
            List(rides.sorted { $0.isSelected && !$1.isSelected }) { ride in
                RideRow(ride: ride, isSelected: binding(for: ride))
            }
            .listStyle(PlainListStyle())

            
            Spacer()
            
            Button(action: {
                print("Submit Rides Button Pressed")
                setRidesInFirebase(rides: rides, email: email)
            }) {
                Text("Submit")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.black)
                    .cornerRadius(20)
                    .padding(.horizontal, 5)
            }
            .padding(.top, UIScreen.main.bounds.height * 0.10)
            .frame(width: UIScreen.main.bounds.width * 0.7, height: UIScreen.main.bounds.height * 0.1, alignment: .center)
        }
        .padding(.bottom, UIScreen.main.bounds.height * 0.1)
        .onAppear {
            fetchSelectedRidesFromFirebase()
        }
    }
    
    private func fetchSelectedRidesFromFirebase() {
        let db = Firestore.firestore()
        let rideDatabaseRef = db.collection("users").document(email)
        
        rideDatabaseRef.getDocument { (documentSnapshot, error) in
            if let error = error {
                print("Error fetching document: \(error)")
            } else if let document = documentSnapshot, document.exists {
                if let selectedRides = document.data()?["rides"] as? [String] {
                    // Update the isSelected property for each ride based on the selectedRides data
                    for index in rides.indices {
                        rides[index].isSelected = selectedRides.contains(rides[index].name)
                    }
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    
    private func binding(for ride: Ride) -> Binding<Bool> {
        guard let index = rides.firstIndex(where: { $0.id == ride.id }) else {
            fatalError("Ride not found")
        }
        return $rides[index].isSelected
    }
}







struct CircleColorView: View {
    @Binding var isChecked: Bool

    var body: some View {
        Button(action: {
            isChecked.toggle()
        }) {
            ZStack {
                Circle()
                    .fill(isChecked ? Color.green : Color.gray)

                if isChecked {
                    Image(systemName: "checkmark")
                        .foregroundColor(.white)
                }
            }
        }
        .frame(width: 50, height: 50)
    }
}

struct RideRow: View {
    var ride: Ride
    @Binding var isSelected: Bool

    var body: some View {
        ZStack {
            HStack {
                Spacer()
                Text(ride.name)
                    .font(.custom("Chalkboard SE", size: UIScreen.main.bounds.width * 0.05))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(.white)
                    
                Spacer()

                CircleColorView(isChecked: $isSelected)

                Spacer()
                
            

            }
        }
        .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.1)
        .padding()
    }
}

// Preview is unchanged
#if DEBUG
struct RideView_Previews: PreviewProvider {
    static var previews: some View {
        RideView(email: "")
    }
}
#endif
