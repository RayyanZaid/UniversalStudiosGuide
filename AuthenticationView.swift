import SwiftUI
import Firebase
import FirebaseFirestore

struct AuthenticationView: View {
    
    
    @AppStorage("email") private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var errorMessage: String?
    @State private var isLoginMode = true
    @State private var firstTimeLogin : Bool = false
    
    
    // to track signup status
    @State private var showAlert = false
  

    
    // to track login status
    
    @AppStorage("successfulLogin") var successfulLogin = false
    
    
    var body: some View {
        
        
        
        
        let authScreenContent = ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            GeometryReader { geometry in
                VStack(spacing: 20) {
                    Image("Logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width * 0.6)
                        .padding(.top, 30)

                    VStack(spacing: 15) {
                        TextField("Email", text: $email)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .foregroundColor(.black)
                            .accentColor(.black)
                            .padding(.horizontal, 20)
                            .font(.headline)
                            .autocapitalization(.none)

                        SecureField("Password", text: $password)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .foregroundColor(.black)
                            .accentColor(.black)
                            .padding(.horizontal, 20)
                            .font(.headline)
                            .autocapitalization(.none)

                        if !isLoginMode {
                            SecureField("Confirm Password", text: $confirmPassword)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .foregroundColor(.black)
                                .accentColor(.black)
                                .padding(.horizontal, 20)
                                .font(.headline)
                                .autocapitalization(.none)
                        }

                        if let errorMessage = errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.white)
                                .padding(.top, 5)
                        }
                    }
                    .padding(.vertical, 20)

                    Button(action: {
                        if isLoginMode {
                            login()
                        } else {
                            signUp()
                        }
                    }) {
                        Text(isLoginMode ? "Login" : "Signup")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(8)
                            .padding(.horizontal, 20)
                    }
                    .padding(.vertical, 10)

                    Button(action: {
                        isLoginMode.toggle()
                    }) {
                        Text(isLoginMode ? "Don't have an account? Sign up" : "Already have an account? Log in")
                            .foregroundColor(Color.white)
                            .underline()
                    }
                }
            }
        }
            .navigationBarHidden(true)
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Verification Sent"),
                      message: Text("An email verification link has been sent to your email address."),
                      dismissButton: .default(Text("OK")))
            }
    
        
        
        if successfulLogin {
                if firstTimeLogin { // Check for successful login
                    EnterUsernameView(email: email)
                } else {
                    HomeView(email: email)
                }
            }
        
        else {
                 authScreenContent
            }
        
        
        
        
        
    }

    func login() {
        errorMessage = nil
        if (email.isEmpty || password.isEmpty) {
            errorMessage = "Please type in your information"
            return
        }

        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                errorMessage = error?.localizedDescription ?? ""
            } else {
                print("Information is correct. Now checking if it's the first time")
               firstTimeLoginFunction()
                successfulLogin = true
            }
        }
    }
    
    func firstTimeLoginFunction() {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(email)
        
        print("Querying Firestore for email: \(email)")
        
        userRef.getDocument { document, error in
            if let error = error {
                print("Error getting document: \(error)")
                return
            }
            
            if let document = document, document.exists {
                print("Document exists")
                firstTimeLogin = false // User exists, not the first time
            } else {
                print("Document does not exist")
                print("Logging in for the first time")
                firstTimeLogin = true // User does not exist, first time login
            }
        }
    }


    

    func signUp() {
        errorMessage = nil
        if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
            errorMessage = "Please fill in all fields"
            return
        }

        if password != confirmPassword {
            errorMessage = "Passwords do not match"
            return
        }

        Auth.auth().createUser(withEmail: email, password: password) { [self] result, error in
            if let error = error as NSError? {
                errorMessage = error.localizedDescription
            } else {
  
               sendEmailVerification()
                    
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                isLoginMode = true
                            }
            }
        }
    }

    
    func sendEmailVerification() {
            Auth.auth().currentUser?.sendEmailVerification { error in
                if let error = error as NSError? {
                    print("Error sending email verification:", error.localizedDescription)
                } else {
                    print("Email verification sent.")
                    showAlert = true
               
                }
            }
        }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView()
    }
}
