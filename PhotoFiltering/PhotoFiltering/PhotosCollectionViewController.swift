//
//  PhotosCollectionViewController.swift
//  PhotoFiltering
//
//  Created by Mauricio Esteves on 2020-07-27.
//  Copyright © 2020 personal. All rights reserved.
//

import Foundation
import UIKit
import Photos
import RxSwift

final class PhotosCollectionViewController: UICollectionViewController {
    private var photos = [PHAsset]()

    //RxSwift
    private let selectedPhotoSubject = PublishSubject<UIImage>()
    var selectedPhoto: Observable<UIImage> {
        return selectedPhotoSubject.asObservable()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPhotosFromLocalLibrary()
    }

    private func fetchPhotosFromLocalLibrary() {
        //request accessing to Photo Library
        PHPhotoLibrary.requestAuthorization { [weak self] status in
            if status == .authorized {
                //access photos from Photo app library
                let assets = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil)
                assets.enumerateObjects { (object, count, stop)  in
                    self?.photos.append(object)
                }

                //most recent should be on the end of the array
                self?.photos.reverse()

                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            }
        }
    }

    // CollectionViews Methods
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedAsset = self.photos[indexPath.row]
        let manager = PHImageManager.default()
        manager.requestImage(for: selectedAsset, targetSize: CGSize(width: 300, height: 300), contentMode: .aspectFit, options: nil) { [weak self] image, info in

            guard let info = info else {
                return
            }

            let isDegradedImage = info["PHImageResultIsDegradedKey"] as! Bool
            if !isDegradedImage, let image = image {
                self?.selectedPhotoSubject.onNext(image)
                self?.dismiss(animated: true, completion: nil)
            }
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as? PhotoCollectionViewCell else {
            fatalError("PhotoCollectionViewCell not found")
        }

        let asset = self.photos[indexPath.row]
        let manager = PHImageManager.default()
        manager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFit, options: nil) { image, _ in
            DispatchQueue.main.async {
                cell.imageView.image = image
            }
        }

        return cell
    }
}
