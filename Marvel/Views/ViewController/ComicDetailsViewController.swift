//
//  ComicDetailsViewController.swift
//  Marvel
//
//  Created by Tony Nlemadim on 12/18/19.
//  Copyright © 2019 Tony Nlemadim. All rights reserved.
//

import UIKit

class ComicDetailsViewController: UIViewController {

    @IBOutlet weak var lblComicDescription: UILabel!
    @IBOutlet weak var lblPriceOfComic: UILabel!
    
    var comicDetailsViewModel: ComicDetailsViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    private func configureView() {
        lblComicDescription.text = comicDetailsViewModel?.getSelectedComic()?.resultDescription?.cleanUpDescription()
        lblPriceOfComic.text = "Price: $" + (comicDetailsViewModel?.getSelectedComic()?.prices.first?.price.description ?? "")
    }
    
    @IBAction func btnDismiss(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
