//
//  ImagePicker.swift
//  FoodPal
//
//  Created by Phila Dlamini on 6/5/24.
//

import Foundation
import UIKit
import SwiftUI

//The bridge between the UIKit class and our SwiftUI project
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var images: [UIImage]
    @Binding var isPickerShowing: Bool
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera //change to .photoLibrary to select from user library
       // picker.allowsEditing = true
        picker.delegate = context.coordinator
        return picker
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self) //pass a reference of the ImagePicker to the Coordinator
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        //left empty is there's nothing to update
    }
}

//The class contacted when an image is selected. Receives the events
class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var parent: ImagePicker
    
    init(_ parent: ImagePicker) {
        self.parent = parent
    }
    
    //Code to run when an inage is selected
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            //We got image. Run the this code in the UI thread
            DispatchQueue.main.async {
                self.parent.images.append(image)
            }
        }
        self.parent.isPickerShowing = false
        
        print("image selected")
    }
    
    //Code to run when the user cancels the picker UI
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled")
    }
}
