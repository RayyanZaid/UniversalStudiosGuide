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
//                    MapPage(location: CLLocation(latitude: 34.1409 , longitude: 118.354 ))
                   ContentView()
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
    @State private var isShowingPurpleSquare: Bool = false
    @State private var selectedRideName: String = ""

    init(email: String) {
        self.email = email
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.6)
                .foregroundColor(.white)
                .shadow(radius: 50)

            VStack {
                if selectedRides.count != 0 {
                    ScrollView {
                        // Use a ScrollView instead of a List
                        VStack(spacing: 10) {
                            ForEach(selectedRides, id: \.self) { ride in
                                Button(action: {
                                    selectedRideName = ride
                                    isShowingPurpleSquare = true
                                }) {
                                    Text(ride)
                                        .foregroundColor(.black)
                                        .font(.custom("Chalkboard SE", size: UIScreen.main.bounds.width * 0.04).bold())
                                        .padding()
                                }
                            }
                        }
                    }.frame(maxHeight: UIScreen.main.bounds.height * 0.6)
                } else {
                    Text("No rides selected")
                        .foregroundColor(.black)
                        .font(.custom("Chalkboard SE", size: UIScreen.main.bounds.width * 0.09).bold())
                        .padding(.all, 20)
                        .multilineTextAlignment(.center)

                    Text("Click on the bottom middle icon to add rides")
                        .font(.custom("Chalkboard SE", size: UIScreen.main.bounds.width * 0.04).bold())
                        .foregroundColor(.black)
                        .frame(maxWidth: UIScreen.main.bounds.width * 0.5, alignment: .center)
                        .multilineTextAlignment(.center)
                }
            }
            .padding()
            .onAppear {
                fetchSelectedRidesFromFirebase(email: self.email) { fetchedSelectedRides in
                    self.selectedRides = fetchedSelectedRides
                }

            }
            
            if isShowingPurpleSquare {
                // Purple square view on top of everything
                ZStack {
                    RoundedRectangle(cornerRadius: 25)
                        .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.3)
                        .foregroundColor(.white)
                        .shadow(radius: 50)
                    
                    Text(selectedRideName)
                        .foregroundColor(.black)
                        .font(.custom("Chalkboard SE", size: UIScreen.main.bounds.width * 0.04).bold())
                        .padding()
                        .frame(maxWidth: UIScreen.main.bounds.width * 0.8)
                        
                }
            }
        }
    }
}






#Preview {
    HomeView(email: "")
}
