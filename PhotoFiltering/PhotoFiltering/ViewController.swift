//
//  ViewController.swift
//  PhotoFiltering
//
//  Created by Mauricio Esteves on 2020-07-17.
//  Copyright © 2020 personal. All rights reserved.
//

import UIKit
import RxSwift

final class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var applyFilterButton: UIButton!

    //Prevent memory leak
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    //Is triggered when a navigation is happening
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navigationController = segue.destination as? UINavigationController, let photosCVC = navigationController.viewControllers.first as? PhotosCollectionViewController else {
            fatalError("Segue PhotosCollectionViewController was not found.")
        }

        photosCVC.selectedPhoto.subscribe(onNext: { [weak self] photo in
            DispatchQueue.main.async {
                self?.updateUI(with: photo)
            }
        }).disposed(by: disposeBag)
    }

    @IBAction func applyFilterImageTouched(_ sender: Any) {
        guard let sourceImage = self.imageView.image else {
            return
        }

        PhotoFilterManager().applyFilter(to: sourceImage).subscribe(onNext: { filteredImage in
            DispatchQueue.main.async {
                self.imageView.image = filteredImage
            }
        }).disposed(by: disposeBag)
    }

    private func updateUI(with photo: UIImage) {
        self.imageView.image = photo
        self.applyFilterButton.isHidden = false
    }
}
