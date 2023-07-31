//
//  EnterUsernameView.swift
//  AutoVolley
//
//  Created by Rayyan Zaid on 7/22/23.
//

import SwiftUI
import FirebaseFirestore


struct EnterUsernameView: View {
    @AppStorage("username") private var username: String = ""
    @FocusState private var isUsernameFocused: Bool

    // Add the 'email' parameter to the initializer
    var email: String

    // Add the initializer to accept the 'email' parameter
    init(email: String) {
        self.email = email
 
    }
    
    @State private var isSuccessful = false;
    
    
    
    var body: some View {
        
        if isSuccessful == false {
            content
        }
        
        else {
            HomeView(email: email)
        }
    }
    var content: some View {
        
            ZStack {
                
                
               
                Rectangle()
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.051, green: 0.196, blue: 0.302), // Custom color with RGB values
                            Color(red: 0.498, green: 0.353, blue: 0.514) // Custom color with RGB values
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    ))
                    .edgesIgnoringSafeArea(.all)

              

                VStack {
                    
                    Spacer()
                        
                    Text("Enter your username: ")
                        .bold()
                        .padding(EdgeInsets(top: 20, leading: 0, bottom: 10, trailing: 0))
                        .foregroundColor(.white)
                        .font(.custom("Chalkboard SE", size: UIScreen.main.bounds.width * 0.07))
                  
                        
                    Spacer()
                    
                    
                    TextField("Username", text: $username)
                        .focused($isUsernameFocused)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .foregroundColor(.black)
                        .accentColor(.black)
                        .padding(.horizontal, 20)
                        .font(.system(size: 20)) // Set a custom font size, adjust the value as needed
                        .autocapitalization(.none)
                        .multilineTextAlignment(.center)
                        .frame(width: UIScreen.main.bounds.height * 0.7, height: UIScreen.main.bounds.height * 0.1, alignment: .center)

                            
                    
                        
                            
                
                    
                    Spacer()
                    
                    
                    Button(action: {
                        print("Username Submit Button Clicked")


                        let db = Firestore.firestore()
                        let userRef = db.collection("users").document(self.email)

                        userRef.getDocument { (document, error) in
                            if let document = document, document.exists {
                                // Document with the given username already exists, you can handle the situation as needed.
                                print("Document with username already exists. Do something here.")
                            } else {
                                // Document with the given username does not exist, you can create one.
                                userRef.setData([
                                    "username": username,
                                    "email": self.email
                                ], merge: true) { error in
                                    if let error = error {
                                        print("Error creating user document:", error.localizedDescription)
                                    } else {
                                        print("User document created successfully.")
                                    }
                                }
                                
                                isSuccessful = true
                                
                          
                                
                            }
                        }

                      
                        
                        
                    }) {
                        Text("Submit")
                            .font(.system(size: 20)) // Set a custom font size for the "Submit" text
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.black.border(Color.black, width: 1))
                                .cornerRadius(20)
                                .padding(.horizontal, 5)
                    }
                    .padding(.vertical, 10)
                    .frame(width: UIScreen.main.bounds.width * 0.7, height: UIScreen.main.bounds.height * 0.2, alignment: .center)
                    
                    
                    Spacer()
                    Spacer()
                    Spacer()
                }
            }
        
          
        
        
        
    }
}





struct EnterUsernameView_Previews: PreviewProvider {
    static var previews: some View {
        EnterUsernameView(email: "") // Provide a dummy email value for preview
    }
}

