//
//  ComicScreenViewController.swift
//  Marvel
//
//  Created by Tony Nlemadim on 12/3/19.
//  Copyright © 2019 Tony Nlemadim. All rights reserved.
//

import UIKit

class ComicViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var comicViewModel = ComicViewModel()
    private var selectedComic: Result?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadComicData()
    }
    
    private func loadComicData() {
        activityIndicator.startAnimating()
        
        comicViewModel.loadComicData {[weak self] (error) in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                guard error == nil else {
                    self?.showToastWith(title: Alert.alertTitle, message: error?.localizedDescription ?? "",
                                        withAction: nil)
                    return
                }
                //We have valid Comic data
                self?.collectionView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segue.detailsSegue {
            guard let comicViewController = segue.destination as? ComicDetailsViewController, let selectedComic = selectedComic else { return }
            let comicDetailsViewModel = ComicDetailsViewModel(selectedComic)
            comicViewController.comicDetailsViewModel = comicDetailsViewModel
        }
    }
}

extension ComicViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comicViewModel.getComicDataSource().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.landingPageCell, for:indexPath) as? ComicCollectionViewCell
        let comic = comicViewModel.getComicDataSource()[indexPath.row]
        cell?.configureCell(comic)
        return cell ?? UICollectionViewCell()
    }
}

extension ComicViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedComic = comicViewModel.getComicDataSource()[indexPath.row]
        performSegue(withIdentifier: Segue.detailsSegue, sender: self)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
