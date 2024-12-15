//
//  FileManager.swift
//  Reset
//
//  Created by Prasanjit Panda on 15/12/24.
//

import Foundation

import UIKit

class FileManagerHelper {
    
    // Save UIImage to disk and return the file path
    static func saveImageToDisk(_ image: UIImage) -> String? {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return nil }
        let fileName = UUID().uuidString + ".jpg"
        let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        do {
            try data.write(to: fileURL)
            return fileURL.path
        } catch {
            print("Error saving image to disk: \(error)")
            return nil
        }
    }
    
    // Load UIImage from file path
    static func loadImageFromDisk(filePath: String) -> UIImage? {
        return UIImage(contentsOfFile: filePath)
    }
}

