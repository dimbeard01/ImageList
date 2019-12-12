//
//  Network.swift
//  ImageList
//
//  Created by Dima Surkov on 10.12.2019.
//  Copyright © 2019 Dima Surkov. All rights reserved.
//

import UIKit
import SwiftSoup

final class Network {

    static let shared = Network()
    
    func fetchImageURL(stringURL: String, completion: @escaping ([String]?) -> Void) {
        
        do {
            let doc: Document = try SwiftSoup.parseBodyFragment(stringURL)
        
            //Only images with JPG format
            let srcs: Elements = try doc.select("img[src$=.jpg]")
            let httpSrcs: Elements = try srcs.select("img[src~=http]")
            let srcsStringArray: [String] = httpSrcs.array().map { try! $0.attr("src").description }
            completion(srcsStringArray)
        } catch Exception.Error(type: _, Message: let message) {
            print(message)
            completion(nil)
        } catch {
            print("error")
        }
    }
    
    func fetchImage(stringUrl: String, completion: @escaping (ImageViewModel?) -> Void) {
        guard let url = URL(string: stringUrl) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error)
                completion(nil)
                return
            }
            
            #if DEBUG
            print(response.debugDescription)
            #endif
            
            if let data = data, let image = UIImage(data: data) {
                let imageModel = ImageViewModel(image: image, link: stringUrl, size: data.count, width: Int(image.size.width), height: Int(image.size.height))
                completion(imageModel)
            } else {
                completion(nil)
            }
        }.resume()
    }
}
