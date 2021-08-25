//
//  Utility.swift
//  Marvel
//
//  Created by Tony Nlemadim on 12/1/19.
//  Copyright © 2019 Tony Nlemadim. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

struct Utility {
    static func getPlistValue(forkey: String) -> String? {
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
            if let dic = NSDictionary(contentsOfFile: path),
                let value = dic[forkey] as? String  {
                return (value)
            }
        }
        return nil
    }
    
    static func print(_ items: Any..., separator: String = " ", terminator: String = "\n", _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
        #if DEBUG
        let stringItem = items.map {"\($0)"} .joined(separator: separator)
        Swift.print("\(stringItem)", terminator: terminator)
        #endif
    }
}

extension Int {
    public var isSuccessHTTPCode: Bool {
        print("http code -- Success \(self)")
        return 200 <= self && self < 300
    }
    public var isUnAuthorizedCode: Bool {
        print("http code -- Failure \(self)")
        return 401 == self
    }
}

extension Dictionary {
    var jsonDescription: String {
        if let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted),
            let dataString = String(data: data, encoding: .utf8) {
            return dataString
        }
        return "Invalid Json Dictionary"
    }
}

extension UIViewController {
    public func showToastWith(title titleText:String , message messageText:String , withAction actionArray:[UIAlertAction]? ,withPrefferedStyle:UIAlertController.Style = .alert) {
        
        let alert = UIAlertController(title: titleText, message: messageText, preferredStyle: withPrefferedStyle)
        guard actionArray != nil else {
            alert.addAction(
                UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        for action in actionArray! {
            alert.addAction(action)
        }
        self.present(alert, animated: true, completion: nil)
    }
}

extension UIImageView {
    
    func imageFromServerURL(forComic comic: Result, placeHolder: UIImage?, completion: (() -> Void)? = nil) {
        self.image = nil
        if let url = URL(string: comic.thumbnail.path + ".jpg") {
            sd_setImage(with: url, placeholderImage: placeHolder, options: [.retryFailed, .scaleDownLargeImages]) { (_, _, _, _) in
                completion?()
            }
        } else {
            self.image = placeHolder
            completion?()
        }
    }
}

extension String {
    func cleanUpDescription() -> String {
         return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}
