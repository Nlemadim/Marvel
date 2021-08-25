//
//  ComicCollectionViewCell.swift
//  Marvel
//
//  Created by Tony Nlemadim on 12/3/19.
//  Copyright © 2019 Tony Nlemadim. All rights reserved.
//

import UIKit

class ComicCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imgComicCover: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(_ comic: Result) {
        imgComicCover.imageFromServerURL(forComic: comic, placeHolder: nil)
        lblTitle.text = comic.title
    }
}
