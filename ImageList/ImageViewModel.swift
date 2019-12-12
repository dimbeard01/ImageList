//
//  ImageViewModel.swift
//  ImageList
//
//  Created by Dima Surkov on 11.12.2019.
//  Copyright © 2019 Dima Surkov. All rights reserved.
//

import UIKit

final class ImageViewModel {

    let image: UIImage
    let link: String
    let size: Int
    let width: Int
    let height: Int
    
    init(image: UIImage, link: String, size: Int, width: Int, height: Int) {
        self.image = image
        self.link = link
        self.size = size
        self.width = width
        self.height = height
    }
}


