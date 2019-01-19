//
//  FirebaseManager.swift
//  BatchShare
//
//  Created by Steve Lederer on 1/15/19.
//  Copyright © 2019 Cameron Milliken. All rights reserved.
//

import Foundation
import Firebase

class FirebaseManager {
    
    static let shared = FirebaseManager()
    
    func signUp(name: String, email: String, username: String, password: String, completion: @escaping (AppUser?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                print("There was an error creating user with email address \(email). \(error) ; \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let user = authResult?.user else {
                print("Error unwrapping user.")
                return
            }
            
            let uuid = user.uid
            
            let newUser = AppUser(uuid: uuid, name: name, username: username, emailAddress: email)
            
            self.saveData(object: newUser, completion: { (error) in
                if let error = error {
                    print("Error saving user to FireStore: \(error); \(error.localizedDescription)")
                    completion(nil)
                    return
                }
            })
            completion(newUser)
            return
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping (AppUser?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                print("There was an error signing in user with email addresss \(email). \(error) ; \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let user = authResult?.user else {
                print("error unwrapping user.")
                return
            }
            
            let uuid = user.uid
            
            let collectionReference = Firestore.firestore().collection("users")
            
            collectionReference.document(uuid).getDocument(completion: { (fetchedUserSnapshot, error) in
                if let error = error {
                    print("There was an error in \(#function): \(error) ; \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                guard let fetchedUserData = fetchedUserSnapshot, fetchedUserData.exists, let fetchedUserDictionary = fetchedUserData.data() else { completion(nil) ; return }

                let signedInuser = AppUser(with: fetchedUserDictionary, id: fetchedUserData.documentID)
                completion(signedInuser)
            })
            
        }
    }
    
    func signOut(user: AppUser, completion: @escaping (Error?) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(nil)
        } catch {
            print("There was an error signing out for the user \(user.username). \(error) ; \(error.localizedDescription)")
            completion(error)
        }
    }
    
    func forgotPassword(email: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if let error = error {
                print("There was an error sending password reset to \(email). \(error) ; \(error.localizedDescription)")
                completion(false)
                return
            } else {
                completion(true)
                return
            }
        }
    }
        
    func fetchFromFirestore<T: FirestoreFetchable>(uuid: String, completion: @escaping (T?) -> Void) {
        let collectionReference = T.collection
        
        collectionReference.document(uuid).getDocument { (documentSnapshot, error) in
            if let error = error {
                print("There was an error in \(#function) \(error) \(error.localizedDescription)")
                completion(nil)
                return
            }
            guard let documentSnapshot = documentSnapshot, documentSnapshot.exists, let objectDictionary = documentSnapshot.data() else { completion(nil) ; return }
            
            let object = T(with: objectDictionary, id: documentSnapshot.documentID)
            completion(object)
        }
    }

    func fetchAllInACollectionFromFirestore<T: FirestoreFetchable>(completion: @escaping ([T]?) -> Void) {
        let collectionReference = T.collection
        
        collectionReference.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("There was an error in \(#function) \(error) \(error.localizedDescription)")
                completion(nil)
                return
            }
            guard let documents = querySnapshot?.documents else { completion(nil) ; return }
            let dictionaries = documents.compactMap{ $0.data() }
            var returnValue: [T] = []
            for dictionary in dictionaries {
                guard let uuid = dictionary["uuid"] as? String,
                    let object = T(with: dictionary, id: uuid) else { completion(nil) ; return }
                returnValue.append(object)
            }
            completion(returnValue)
        }
    }

    func fetchFirestoreWithFieldAndCriteria<T: FirestoreFetchable>(for field: String, criteria: String, completion: @escaping ([T]?) -> Void) {
        let collectionReference = T.collection
        let filteredCollection = collectionReference.whereField(field, isEqualTo: criteria)
        filteredCollection.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("There was an error in\(#function) \(error) \(error.localizedDescription)")
                completion(nil)
                return
            }
            guard let documents = querySnapshot?.documents else { completion(nil) ; return }
            let dictionaries = documents.compactMap{ $0.data() }
            var returnValue: [T] = []
            for dictionary in dictionaries {
                guard let uuid = dictionary["uuid"] as? String,
                    let object = T(with: dictionary, id: uuid) else { completion(nil) ; return }
                returnValue.append(object)
            }
            completion(returnValue)
        }
    }
    
    func saveData<T: FirestoreFetchable>(object: T, completion: @escaping (Error?) -> Void) {
        let collectionReference = T.collection
        let documentReference = collectionReference.document(object.uuid)
        documentReference.setData(object.dictionary) { (error) in
            if let error = error {
                print("Error! \(error) \(error.localizedDescription)")
                completion(error)
                return
            }
            completion(nil)
        }
    }
    
    func updateData<T: FirestoreFetchable>(obect: T, dictionary: [String : Any], completion: @escaping (Error?) -> Void) {
        let documentReference = T.collection.document(obect.uuid)
        documentReference.updateData(dictionary) { (error) in
            if let error = error {
                print("There was an error in \(#function) ---- \(error) \(error.localizedDescription)")
                completion(error)
                return
            }
            completion(nil)
        }
        
    }
    
    func deleteData<T: FirestoreFetchable>(object: T, completion: @escaping (Bool) -> Void) {
        let collectionReference = T.collection
        collectionReference.document().delete()
        completion(true)
    }
}
