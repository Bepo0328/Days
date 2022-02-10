//
//  IconPickerViewController.swift
//  Days
//
//  Created by 전윤현 on 2022/02/10.
//

import Foundation
import UIKit

protocol IconPickerViewControllerDelegate: AnyObject {
    func iconPickerViewController(_ controller: IconPickerViewController, didSelectIcon icon: Int)
}

class IconPickerCell: UICollectionViewCell {
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var iconView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.container.layer.cornerRadius = 10
        self.container.layer.cornerCurve = .continuous
        self.container.layer.shadowOffset = .zero
        self.container.layer.shadowColor = UIColor.black.cgColor
        self.container.layer.shadowOpacity = 0.2
        self.container.layer.shadowRadius = 2
    }
}

class IconPickerViewController: UIViewController {
    weak var delegate: IconPickerViewControllerDelegate?
}

extension IconPickerViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IconPickerCell", for: indexPath) as! IconPickerCell
        cell.iconView.image = UIImage(named: "icon_\(indexPath.item + 1)")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let columns: CGFloat = 5
        let horizontalSpacing: CGFloat = 20
        let cellSpacing: CGFloat = 10
        let size = (collectionView.frame.width - horizontalSpacing - (cellSpacing * (columns - 1))) / columns
        
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.iconPickerViewController(self, didSelectIcon: indexPath.row + 1)
    }
}
