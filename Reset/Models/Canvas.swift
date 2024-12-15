//
//  Canvas.swift
//  Reset
//
//  Created by Prasanjit Panda on 03/12/24.
//

import Foundation
import UIKit

import Foundation
import UIKit

enum CanvasItem: Codable {
    case image(String)  // Store image file path as a String
    case text(String)   // Store text as String
    
    private enum CodingKeys: String, CodingKey {
        case type, data
    }
    
    private enum ItemType: String, Codable {
        case image, text
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(ItemType.self, forKey: .type)
        
        switch type {
        case .image:
            let filePath = try container.decode(String.self, forKey: .data)
            self = .image(filePath)
        case .text:
            let text = try container.decode(String.self, forKey: .data)
            self = .text(text)
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case .image(let filePath):
            try container.encode(ItemType.image, forKey: .type)
            try container.encode(filePath, forKey: .data)
        case .text(let text):
            try container.encode(ItemType.text, forKey: .type)
            try container.encode(text, forKey: .data)
        }
    }
    
    // Method to get the image file path (URL)
    func imageURL() -> URL? {
        if case .image(let filePath) = self {
            // If the item is an image, return the file path as a URL
            return URL(string: filePath)
        }
        return nil
    }
}


class Model: NSObject {
    var items: [CanvasItem] = []
    
    private let userDefaultsKey = "canvasItems"
    private let imagesDirectoryURL: URL
    
    override init() {
        // Create the directory to store images (if it doesn't exist)
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        imagesDirectoryURL = documentsURL.appendingPathComponent("CanvasImages")
        
        if !fileManager.fileExists(atPath: imagesDirectoryURL.path) {
            try? fileManager.createDirectory(at: imagesDirectoryURL, withIntermediateDirectories: true, attributes: nil)
        }
        
        super.init()
        loadItems()
    }
    
    // Save items to UserDefaults
    func saveItems() {
        do {
            let data = try JSONEncoder().encode(items)
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        } catch {
            print("Failed to save items: \(error.localizedDescription)")
        }
    }
    
    // Load items from UserDefaults
    func loadItems() {
        guard let savedData = UserDefaults.standard.data(forKey: userDefaultsKey) else { return }
        
        do {
            let decodedItems = try JSONDecoder().decode([CanvasItem].self, from: savedData)
            items = decodedItems
        } catch {
            print("Failed to load items: \(error.localizedDescription)")
        }
    }
    
    // Save an image and return its URL
    func saveImage(_ image: UIImage) -> URL? {
        let imageData = image.pngData()!
        let imageName = UUID().uuidString + ".png"
        let imageURL = imagesDirectoryURL.appendingPathComponent(imageName)
        
        do {
            try imageData.write(to: imageURL)
            return imageURL
        } catch {
            print("Failed to save image: \(error.localizedDescription)")
            return nil
        }
    }
}


