//
//  AccountProfilePic.swift
//  FoodPal
//
//  Created by Phila Dlamini on 6/25/24.
//

import SwiftUI

import Foundation
import SwiftUI

class AccountPic: ObservableObject {
    @Published var image: UIImage? = nil
   
    func downloadImage(from url: URL) {
        let task = URLSession.shared.dataTask(with: url) {localUrl, response, error in
            if error != nil {
                print("Error downloading user profile picture")
            } else if let data = localUrl, let downloadedImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = downloadedImage
                }
            }
        }
            
        task.resume()
    }
}
