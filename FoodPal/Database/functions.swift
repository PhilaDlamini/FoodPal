//
//  functions.swift
//  FoodPal
//
//  Created by Phila Dlamini on 6/29/24.
//  All database functions performed by this application 

import FirebaseDatabase
import FirebaseStorage
import Foundation
import CoreLocation
import FirebaseAuth


func cancelPickUp(post: Post, account: Account) {
    let ref = Database.database().reference()
    
    //remove post from the users's claimed posts
    ref.child("claimed/\(account.uid)/\(post.id)").removeValue()
    
    //notify posting user this user canceled the claim
    ref.child("users/\(post.uid)/token").getData {error, snapshot in
        if let snapshot {
            if snapshot.value is String {
                let notif = NotificationData(userHandle: account.handle, title: post.title, token: snapshot.value as! String)
                let notifJson = toDict(model: notif)
                ref.child("notifications/unclaimed/\(notif.id)").setValue(notifJson)
            }
        }
    }
}

//Blocks the poster of this post from being seen by the user
func blockPoster(of post: Post, from account: Account) {
    print("Entered block poster function")
    let ref = Database.database().reference()
    
    ref.child("blocked/\(account.uid)").getData { error, snapshot in
        if let snapshot = snapshot {
            let blockedUsers = [post.uid]
            
            if var blockedUsers = snapshot.value as? [String] {
                blockedUsers.removeAll(where: {$0 == post.uid})
                blockedUsers.append(post.uid)
            }
            
            //first time. just upload the new list
            ref.child("blocked/\(account.uid)").setValue(blockedUsers) {error, _ in
                if error == nil {
                    print("Successfully blocked user ")
                } else {
                    print("\(error!.localizedDescription)")
                }
                
            }
        } else if error != nil {
            print("Error getting blocked information")
        }
    }
}

func deleteAccount(account: Account) {
    let ref = Database.database().reference()
    
    //remove post from the user who posted it 's posts
    ref.child("user posts/\(account.uid)").removeValue()
    
    //remove the post from this user's favorites, if any
    ref.child("favorited/\(account.uid)").removeValue()
    
    //remove the post from this user's claimed posts
    ref.child("claimed/\(account.uid)").removeValue()
    
    //free handle
    ref.child("handles/\(account.handle)").removeValue()
    
    //remove user data
    ref.child( "users/\(account.uid)" ).removeValue()
    
    //remove user pics
    Storage.storage().reference().child("profile pictures").child(account.uid).delete { error in
        if error != nil {
            print("Failed to delete profile picture")
        } else {
            print("Deleted user profile picture")
        }
    }
    
    //Delete user information
    Auth.auth().currentUser?.delete { error in
        if error != nil {
            print("Failed to delete user")
        } else {
            print("Successfully deleted user")
        }
    }
    
}


func deletePost(post: Post, account: Account, address: Address) {
    let ref = Database.database().reference()
      
    //remove post from the main posts section
    ref.child("posts/\(address.country)/\(address.state)/\(address.city)/\(post.id)").removeValue()
    
    //remove post from the user who posted it 's posts
    ref.child("user posts/\(post.uid)/\(post.id)").removeValue()
    
    //remove the post from this user's favorites, if any
    ref.child("favorited/\(account.uid)/\(post.id)").removeValue()
    
    //remove the post from this user's claimed posts
    ref.child("claimed/\(account.uid)/\(post.id)").removeValue()
    
    //remove pics associated with post
    let storageRef = Storage.storage().reference().child("post pictures/\(address.country)/\(address.state)/\(address.city)/\(post.id)")
    
    for i in 0..<post.images.count {
        storageRef.child("\(i)").delete{ error in
            if error != nil {
                print("Failed to delete media associated with post")
            } else {
                print("Deleted associated post media successfully")
            }
        }
    }
}


func report(account: Account, post: Post) {
    print("reporting this post")
}

//attempts to claim the post
func claim(post: Post, account: Account, postUnavailable: PostUnavailable) {
    getAddress(for: CLLocation(latitude: post.latitude, longitude: post.longitude)) {address in
        
        //check if the post exists
        let ref = Database.database().reference()
        ref.child("posts/\(address.country)/\(address.state)/\(address.city)/\(post.id)").getData {error, snapshot in
            if let snapshot = snapshot {
                if snapshot.value is [String: Any] {
                    
                    //post exists. claim it
                    print("Post was available. Proceeding to claim")
                    let jsonData = toDict(model: post)
                    ref.child("claimed/\(account.uid)/\(post.id)").setValue(jsonData)
                    
                    //send user the notification that it was claimed
                    ref.child("users/\(post.uid)/token").getData {error, snapshot in
                        if let snapshot {
                            if snapshot.value is String {
                                let notif = NotificationData(userHandle: account.handle, title: post.title, token: snapshot.value as! String)
                                let notifJson = toDict(model: notif)
                                ref.child("notifications/claimed/\(notif.id)").setValue(notifJson)
                            }
                        }
                    }
                    
                } else {
                    print("Post not available for claiming. Canceling")
                    
                    //post does not exist
                    postUnavailable.unavailable = true
                    
                    //remove post from currrent user favorites (post must have been claimed from favorites)
                    ref.child("favorited/\(account.uid)/\(post.id)").removeValue()
                }
            }
        }
    }
}

func favorite(account: Account, post: Post) {
            
    //add the post to favorited posts
    Database.database().reference().child("favorited/\(account.uid)/\(post.id)").setValue(toDict(model: post)) {error, _ in
        if error != nil {
            print("Error favoriting post")
        } else {
            print("Favorited post successfully")
        }
    }
}

func unfavorite(account: Account, post: Post) {
    
    //romove post from favorites
    Database.database().reference().child("favorited/\(account.uid)/\(post.id)").removeValue() {error, _ in
        if error != nil {
            print("Error unfavoriting post")
        } else {
            print("Unfavorited post")
        }
    }
}



