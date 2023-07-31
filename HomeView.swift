import SwiftUI
import FirebaseFirestore

import CoreLocation
import MapKit

struct HomeView: View {
    
    @State private var selectedTab: TabItem = .home
    
    var email : String
    
    init(email: String) {
        self.email = email
    }
    
    
    var body: some View {
        
        ZStack {
            Rectangle()
                .fill(LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.051, green: 0.196, blue: 0.302),
                        Color(red: 0.498, green: 0.353, blue: 0.514)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                ))
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                
                if selectedTab == .home {
                    MainHomeView(email: self.email)
                }
                
                if selectedTab == .rides {
                    RideView(email: self.email)
                }
                
                if selectedTab == .map {
                    MapPage(location: CLLocation(latitude: 34.1409 , longitude: 118.354 ))
                }
                
                ZStack {
                    RoundedRectangle(cornerRadius: UIScreen.main.bounds.height * 0.025 )
                        .frame(width: UIScreen.main.bounds.width , height: UIScreen.main.bounds.height * 0.1)
                        .foregroundColor(.white)
                        .shadow(radius: 50)
                    
                        HStack {
                            ForEach([TabItem.home, TabItem.rides, TabItem.map], id: \.self) { tab in
                                Button(action: {
                                    selectedTab = tab
                                }) {
                                    Image(systemName: tab.imageName)
                                        .imageScale(.large)
                                        .foregroundColor(selectedTab == tab ? .blue : .gray)
                                        .padding(20)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                    
                    
                }
            }
        }.frame(maxHeight: .infinity, alignment: .top)
            .ignoresSafeArea(.container , edges: .bottom)
       
        
        
    }
    
   
   
}


struct MainHomeView: View {
    var email: String
    @State private var username: String = ""

    init(email: String) {
        self.email = email
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Hi, \(username)")
                    .font(.custom("Chalkboard SE", size: UIScreen.main.bounds.width * 0.09).bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.white)
                Spacer()
                Image(systemName: "gearshape.fill")
                    .imageScale(.large)
                    .foregroundColor(.white)
            }
            .frame(height: 70)
            .padding(.horizontal, 20)
            Spacer()
            
            Text("Your Schedule").frame(maxWidth: .infinity, alignment: .center)
                .foregroundColor(.white)
                .font(.custom("Chalkboard SE", size: UIScreen.main.bounds.width * 0.09).bold())
            
            Spacer()
            RideBox(email: self.email)
            
            Spacer()
        }
        .onAppear {
            // Fetch the username when the view appears
            getUsername(forEmail: email) { retrievedUsername in
                self.username = retrievedUsername
            }
        }
    }
}


struct RideBox: View {
    var email: String
    @State private var selectedRides: [String] = []

    init(email: String) {
        self.email = email
    }

    private func fetchSelectedRidesFromFirebase() {
        let db = Firestore.firestore()
        let rideDatabaseRef = db.collection("users").document(email)

        rideDatabaseRef.getDocument { (documentSnapshot, error) in
            if let error = error {
                print("Error fetching document: \(error)")
            } else if let document = documentSnapshot, document.exists {
                if let selectedRides = document.data()?["rides"] as? [String] {
                    self.selectedRides = selectedRides
                } else {
                    self.selectedRides = []
                }
            } else {
                print("Document does not exist")
            }
        }
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.6)
                .foregroundColor(.white)
                .shadow(radius: 50)
            
                       
            VStack {

                    
                List(selectedRides, id: \.self) { ride in
                    Text(ride)
                }
                .onAppear {
                    fetchSelectedRidesFromFirebase()
                }
            }
            .padding() // Add padding to the VStack if needed
        }
    }
}








struct MapView: View {
    var body: some View {

        Text("Map View")
            .font(.custom("Chalkboard SE", size: UIScreen.main.bounds.width * 0.09).bold())
            .foregroundColor(.white)
            .multilineTextAlignment(.center)
    }
}

#Preview {
    HomeView(email: "")
}
