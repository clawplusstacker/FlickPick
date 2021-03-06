//
//  User.swift
//  movieTinder
//
//  Created by Colby Beach on 3/24/21.
//


import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

private var db = Firestore.firestore()

struct UserStore: Identifiable {
    
    var id: String
    var userName : String
    var uid : String
    var moviesLiked : Array<String>
    var moviesDisliked : Array<String>
    var friends : Array<String>
    var profilePicture: String
    var bio : String
        
}

class UserStoreFunctions{
        
    
    private var UserView = UserViewModel()
    
    
    
    
    func getFireStoreUserIndex(uid: String) -> Int{

        self.UserView.fetchData()

        let numOfUsers = UserView.users.count
        var x = 0

        while x < numOfUsers {

            if UserView.users[x].uid == uid{
                return x
            }else{
                x += 1
            }
        }

        return x
    }
    
    func getFireStoreUserIndex(userName: String) -> Int{

        self.UserView.fetchData()

        let numOfUsers = UserView.users.count
        var x = 0

        while x < numOfUsers {

            if UserView.users[x].userName == userName{
                return x
            }else{
                x += 1
            }
        }

        return x
    }
    
    
    func getUsername(index: Int) -> String{
        
        self.UserView.fetchData()

        if(self.UserView.users.count > 0){
            
            if(self.UserView.users.count >= index+1){
                
                return UserView.users[index].userName
                
            }
            

        }
        
        return ""

    }
    
    func getBio(index: Int) -> String{
        
        self.UserView.fetchData()

        if(self.UserView.users.count > 0){
            
            if(self.UserView.users.count >= index+1){
                
                return UserView.users[index].bio
                
            }
            
        }
        
        return ""

    }
    

    func getMovieNum(index : Int) -> Int {
        
        self.UserView.fetchData()
        
        if(self.UserView.users.count >= index + 1){
            
            let currentUser = UserView.users[index]
            return currentUser.moviesDisliked.count + currentUser.moviesLiked.count


        }

        return 0
        
    }
    
    func addProfilePicture(index: Int, pictureURL: URL){
        
        self.UserView.fetchData()
        
        let pictureURLString = pictureURL.absoluteString
    
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
        
            let currentUserUID = self.UserView.users[index].id

            print(currentUserUID)
            
            let userDoc = db.collection("users").document(currentUserUID)

            userDoc.updateData([
                "profilePicture": pictureURLString
            ])
      
            
        }
    }
    
    func addBio(index: Int, bio: String){

        let currentUserUID = UserView.users[index].id

        self.UserView.fetchData()

        let userDoc = db.collection("users").document(currentUserUID)

        userDoc.updateData([
            "bio": bio
        ])
        
    }
    
    
    func addToMoviesLiked(index: Int, movie_id: String){
        

        let currentUserUID = UserView.users[index].id

        self.UserView.fetchData()


        let userDoc = db.collection("users").document(currentUserUID)

        userDoc.updateData([
            "moviesLiked": FieldValue.arrayUnion([movie_id])
        ])
        
    }
    
    func addToMoviesDisliked(index: Int, movie_id: String){
        
        
        let currentUserUID = UserView.users[index].id

        self.UserView.fetchData()

        
        let userDoc = db.collection("users").document(currentUserUID)
        
        userDoc.updateData([
            "moviesDisliked": FieldValue.arrayUnion([movie_id])
        ])
        
    }
    func removeFromLiked(index: Int, movie_id: String){
        
        let currentUserUID = UserView.users[index].id

        self.UserView.fetchData()


        let userDoc = db.collection("users").document(currentUserUID)

        userDoc.updateData([
            "moviesLiked": FieldValue.arrayRemove([movie_id])
        ])
        
    }
    
    func removeFromDisliked(index: Int, movie_id: String){
        
        
        let currentUserUID = UserView.users[index].id

        self.UserView.fetchData()

        
        let userDoc = db.collection("users").document(currentUserUID)
        
        userDoc.updateData([
            "moviesDisliked": FieldValue.arrayRemove([movie_id])
        ])
        
    }
    func getProfilePicture(index: Int) -> String{
        
        self.UserView.fetchData()
        
        if(self.UserView.users.count >= index + 1){
        
            let profilePicture = UserView.users[index].profilePicture
            
            return profilePicture
        }
        
        return "defaultImage"
    }
    
    func getFreindsList(index: Int)-> Array<String>{
        
        self.UserView.fetchData()
        
        
        if(self.UserView.users.count >= index + 1){

            let currentUserFriends = UserView.users[index].friends

            return currentUserFriends
        }
        
        return ["Loading Friends"]
                
    }
    
    func getLikedList(index: Int)-> Array<String>{
        
        self.UserView.fetchData()
        
        
        if(self.UserView.users.count >= index + 1){
                            
            let likedList = UserView.users[index].moviesLiked

            return likedList

       
        }
        
        return ["Loading Movies"]
                
    }
    
    func getDislikedList(index: Int)-> Array<String>{
        
        self.UserView.fetchData()
        
        
        if(self.UserView.users.count >= index + 1){

            let dislikedList = UserView.users[index].moviesDisliked

            return dislikedList
        }
        
        return ["Loading Movies"]
                
    }
    
    func checkFriendListContains(index: Int, userName: String) -> Bool{
        
        var friendsList = self.getFreindsList(index: index)
        
        if(friendsList.contains(userName)){
            return true
        }

        return false
    }
    
    func addUserToFriends(index: Int, userName: String){
    

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                

                    let currentUserUID = self.UserView.users[index].id
                        
                    let userDoc = db.collection("users").document(currentUserUID)
                        
                    userDoc.updateData([
                        "friends": FieldValue.arrayUnion([userName])
                    ])
            }
        
        self.UserView.fetchData()
        }
    
    func removeUserFromFriends(index: Int, userName: String){
    

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                

                    let currentUserUID = self.UserView.users[index].id
                        
                    let userDoc = db.collection("users").document(currentUserUID)
                        
                    userDoc.updateData([
                        "friends": FieldValue.arrayRemove([userName])
                    ])
            }
        
        self.UserView.fetchData()
        }
    
    
    
    func getMatches(indexOfSelf: Int, userNameOfOther: String) -> Array<String>{
        
        self.UserView.fetchData()
        
        var result = [String]()

        if(self.UserView.users.count >= indexOfSelf + 1){

            let currentUserMovies = UserView.users[indexOfSelf].moviesLiked
            
            let otherUserMovies = UserView.users[getFireStoreUserIndex(userName: userNameOfOther)].moviesLiked
            
            for movie in currentUserMovies{
                if otherUserMovies.contains(movie){
                    result.append(movie)
                }
            }
        }
        
        return result
    }
    
    

}
    
class UserViewModel:  ObservableObject{
    
    @Published var users = [UserStore]()
    
    private var db = Firestore.firestore()
    
    func fetchData() {
        
        db.collection("users").addSnapshotListener{ (QuerySnapshot, Error) in
            guard let documents = QuerySnapshot?.documents else{
                print("No Documents")
                return
            }

            self.users = documents.map {  (QueryDocumentSnapshot) -> UserStore in
                
                let data = QueryDocumentSnapshot.data()
                
                let id = QueryDocumentSnapshot.documentID
                let userName = data["userName"] as? String ?? ""
                let uid = data["uid"] as? String ?? ""
                let bio = data["bio"] as? String ?? ""
                let moviesLiked = data["moviesLiked"] as? Array<String> ?? []
                let moviesDisliked = data["moviesDisliked"] as? Array<String> ?? []
                let friends = data["friends"] as? Array<String> ?? []
                let profilePicture = data["profilePicture"] as? String ?? ""

                
                return UserStore(id: id, userName: userName, uid: uid, moviesLiked: moviesLiked, moviesDisliked: moviesDisliked, friends: friends, profilePicture: profilePicture, bio: bio)
              
            }
        }

    }

}
