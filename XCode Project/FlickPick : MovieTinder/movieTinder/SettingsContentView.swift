//
//  SettingsContentView.swift
//  movieTinder
//
//  Created by Colby Beach on 3/30/21.
//

import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseFirestore



//Used for switch case for sheets
enum ActiveSheetSettings: Identifiable {
    case profilePic, changePass, stremServ
    
    var id: Int {
        hashValue
    }
}



private var UserFunctions = UserStoreFunctions()

struct SettingsMainView : View{
    
    @ObservedObject private var user = UserViewModel()

        
    @Binding var loggingIn : Bool
    
    @State var userName = UserFunctions.getUsername(index: UserFunctions.getFireStoreUserIndex(uid: (Auth.auth().currentUser?.uid) ?? ""))
    
    @State var userIndex = UserFunctions.getFireStoreUserIndex(uid: (Auth.auth().currentUser?.uid) ?? "")

    @State var showingSettingSheet: ActiveSheetSettings?
    
    @State var notificationTogggle = false


    

    
    var body: some View{
        
        VStack {
            
            HStack {
                
                Text("Settings")
                    .font(.system(size: 40, weight: .black, design: .rounded))
                Spacer()
                    
            }
            
            .padding()
            .padding(.bottom, 30)
              

            Button {
                showingSettingSheet = .profilePic
                
            } label: {
                
                let profilePicUrl = URL(string: UserFunctions.getProfilePicture(index: userIndex))
                
                if #available(iOS 15.0, *) {
                    AsyncImage(url: profilePicUrl) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .frame(width: 220, height: 220)
                                .scaledToFit()
                                .cornerRadius(150)

                        } else if phase.error != nil {
                            Text("Network Error!")
                                .cornerRadius(150.0)
                                .frame(width: 220, height: 220)
                        } else {
                            ProgressView()
                                .cornerRadius(150.0)
                                .frame(width: 220, height: 220)
                            
                            } //else
                        }//async image
                    } //if aviablae
                } //Picture/Button
                   
            .padding(.bottom, 20)

            List{
                
                Section(header: Text("User Information")){
                    
                    HStack{
                        Text("Username: ")
                        Text(userName)
                            .foregroundColor(.pink)

                    }
                        .padding(5)
                    HStack{
                        Text("Email: ")
                        Text((Auth.auth().currentUser?.email ?? " "))
                            .foregroundColor(.pink)
                    }
                        .padding(5)
                    
                    Button(action: {
                        showingSettingSheet = .changePass
                    }, label: {
                        Text("Change Password")
                            .foregroundColor(.black)


                    })
                        .padding(5)
                }
                   
               
                Section(header: Text("Other")){
                    
                    Button(action: {
                        showingSettingSheet = .stremServ
                    }, label: {
                        Text("Streaming Services")
                            .foregroundColor(.black)


                    })
                        .padding(5)
                    
                    HStack{
                        Toggle("Notifications", isOn: $notificationTogggle)
                            .toggleStyle(SwitchToggleStyle(tint: .pink))
                            .padding(5)
                            .disabled(false)
                    }
                    
                }
              
            }.listStyle(InsetGroupedListStyle())
                
                
            Spacer()

                    
            HStack{
                Button{
                        
                        let firebaseAuth = Auth.auth()
                    do {
                      try firebaseAuth.signOut()
                    } catch let signOutError as NSError {
                      print("Error signing out: %@", signOutError)
                    }
                        loggingIn = false;
                                            
            
                } label: {
                    Text("Logout")
                        .frame(width: 350, height: 50)
                }
                        
                .font(.headline)
                .foregroundColor(.white)
                .frame(width: 350, height: 50)
                .background(Color.pink)
                .cornerRadius(15.0)
            }
            .padding()
            
            
            
            .sheet(item: $showingSettingSheet) { item in
                switch item {
                case .profilePic:
                    AddProfilePicView()
                case .stremServ:
                    StreamingServiceSettingsView()
                case .changePass:
                    ChangePasswordView()
                }

            }
         
          

        }
        .navigationBarHidden(true)

        .onAppear(){
            
            self.user.fetchData()

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                userName = UserFunctions.getUsername(index: UserFunctions.getFireStoreUserIndex(uid: (Auth.auth().currentUser?.uid) ?? ""))
            }
            

        }
    }
}

struct StreamingServiceSettingsView : View{
    
    @State private var trueToggle = true
    @State private var falseToggle = false

    var body: some View{
        
        VStack{
            
            HStack{
                Text("Streaming Services")
                    .font(.system(size: 35, weight: .black, design: .rounded))
            }
            .padding(.top, 60)
            
            
            
            LabelledDivider(label: "")
                .padding()
            
            List{
                                    
                Toggle("HBO Max", isOn: $trueToggle)
                    .toggleStyle(SwitchToggleStyle(tint: .pink))
                    .padding(5)
                    .disabled(true)
                Toggle("Netflix", isOn: $falseToggle)
                    .toggleStyle(SwitchToggleStyle(tint: .pink))
                    .padding(5)
                    .disabled(true)
                Toggle("Disney Plus", isOn: $falseToggle)
                    .toggleStyle(SwitchToggleStyle(tint: .pink))
                    .padding(5)
                    .disabled(true)
                Toggle("Hulu", isOn: $falseToggle)
                    .toggleStyle(SwitchToggleStyle(tint: .pink))
                    .padding(5)
                    .disabled(true)
                Toggle("Prime Video", isOn: $falseToggle)
                    .toggleStyle(SwitchToggleStyle(tint: .pink))
                    .padding(5)
                    .disabled(true)
                Toggle("Peacock", isOn: $falseToggle)
                    .toggleStyle(SwitchToggleStyle(tint: .pink))
                    .padding(5)
                    .disabled(true)
                Toggle("Paramount Plus", isOn: $falseToggle)
                    .toggleStyle(SwitchToggleStyle(tint: .pink))
                    .padding(5)
                    .disabled(true)
                
            }
            .padding()
            .foregroundColor(.gray)
     
            
        }
        
    }
    
    
}
