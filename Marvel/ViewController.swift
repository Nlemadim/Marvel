//
//  ViewController.swift
//  Marvel
//
//  Created by Tony Nlemadim on 11/30/19.
//  Copyright © 2019 Tony Nlemadim. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ComicApi.getComic { (comicData, error) in
            guard error == nil  else { return }
            Utility.print("Comic Data is \(String(describing: comicData))")
        }
    }


}

