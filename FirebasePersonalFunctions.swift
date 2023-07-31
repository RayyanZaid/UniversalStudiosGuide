// FirebasePersonalFunctions.swift
// UniversalStudiosGuide
//
// Created by Rayyan Zaid on 7/28/23.
//

import Foundation
import FirebaseFirestore

func getUsername(forEmail email: String, completion: @escaping (String) -> Void) {
    let db = Firestore.firestore()
    let userRef = db.collection("users").document(email)
    
    print("Querying Firestore for email: \(email)")
    
    var username = ""
    userRef.getDocument { document, error in
        if let error = error {
            print("Error getting document: \(error)")
            completion("") // Call the completion handler with an empty string to indicate an error or absence of data
            return
        }
        
        if let document = document, document.exists {
            if let usernameFromDB = document.data()?["username"] as? String {
                username = usernameFromDB
                completion(username) // Call the completion handler with the retrieved username
            }
        } else {
            print("Document does not exist")
            print("Logging in for the first time")
            completion("") // Call the completion handler with an empty string since the document doesn't exist
        }
    }
}

func setRidesInFirebase(rides: [Ride], email: String) {
    var selectedRides: [String] = []
    
    for ride in rides {

        if ride.isSelected {
            selectedRides.append(ride.name)
        }
    }
    
    let db = Firestore.firestore()
    let userRef = db.collection("users").document(email)
    
    // Set the "rides" field in the Firestore document with the selectedRides array
    userRef.setData(["rides": selectedRides], merge: true) { error in
        if let error = error {
            print("Error setting rides in Firestore: \(error.localizedDescription)")
        } else {
            print("Rides successfully updated in Firestore.")
        }
    }
}



func fetchSelectedRidesFromFirebase(email: String, completion: @escaping ([String]) -> Void) {
    let db = Firestore.firestore()
    let rideDatabaseRef = db.collection("users").document(email)

    rideDatabaseRef.getDocument { (documentSnapshot, error) in
        if let error = error {
            print("Error fetching document: \(error)")
            completion([])
        } else if let document = documentSnapshot, document.exists {
            if let selectedRides = document.data()?["rides"] as? [String] {
                completion(selectedRides)
            } else {
                completion([])
            }
        } else {
            print("Document does not exist")
            completion([])
        }
    }
}

