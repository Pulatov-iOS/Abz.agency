//
//  ImagePickerView.swift
//  abz.agency
//
//  Created by Alexander on 11.06.25.
//

import UIKit
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    let sourceType: UIImagePickerController.SourceType
    @Binding var selectedImage: UIImage?

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let ipc = UIImagePickerController()
        ipc.sourceType = sourceType
        ipc.delegate = context.coordinator
        ipc.allowsEditing = true
        return ipc
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        init(_ parent: ImagePicker) { self.parent = parent }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let img = info[.editedImage] as? UIImage ??
                        info[.originalImage] as? UIImage {
                parent.selectedImage = img
            }
            picker.dismiss(animated: true)
        }
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}
