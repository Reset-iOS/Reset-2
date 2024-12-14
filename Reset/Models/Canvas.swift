//
//  Canvas.swift
//  Reset
//
//  Created by Prasanjit Panda on 03/12/24.
//

import Foundation
import UIKit

enum CanvasItem {
    case image(UIImage)
    case text(String)
}

class Model: NSObject {
    var items: [CanvasItem] = [
        .image(UIImage(named: "Emily")!),
        .text("Sample text 1"),
        .image(UIImage(named: "Emily")!),
        .text("Sample text 2"),
        .image(UIImage(named: "Emily")!)
    ]
}

