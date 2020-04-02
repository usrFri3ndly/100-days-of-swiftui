//
//  ImageSaver.swift
//  project13
//
//  Created by Sc0tt on 02/04/2020.
//  Copyright © 2020 Sc0tt. All rights reserved.
//

import UIKit

class ImageSaver: NSObject {
    var successHandler: (() -> Void)?
    var errorHandler: ((Error) -> Void)?
    
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveError), nil)
    }
    
    @objc func saveError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer)
    {
        if let error = error {
            errorHandler?(error)
        } else {
            successHandler?()
        }
    }
}
