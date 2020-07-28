//
//  ViewController.swift
//  PhotoFiltering
//
//  Created by Mauricio Esteves on 2020-07-17.
//  Copyright © 2020 personal. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
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
            self?.imageView.image = photo
        }).disposed(by: disposeBag)
    }
}

