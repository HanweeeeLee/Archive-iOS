//
//  DetailCardCollectionViewCell.swift
//  Archive
//
//  Created by hanwe on 2021/12/26.
//

import UIKit
import Kingfisher

class DetailCardCollectionViewCell: UICollectionViewCell, ClassIdentifiable {

    // MARK: IBOutlet
    @IBOutlet weak var mainBackgroundView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mainContetnsView: UIView!
    
    @IBOutlet weak var topContainerView: UIView!
    @IBOutlet weak var topContainerViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var centerContainerView: UIView!
    @IBOutlet weak var miniEmotionImageView: UIImageView!
    @IBOutlet weak var emotionLabel: UILabel!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var emotionCoverImageView: UIImageView!
    
    @IBOutlet weak var bottomContainerView: UIView!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    
    @IBOutlet weak var friendsCollectionView: UICollectionView!
    
    // MARK: private property
    
    // MARK: internal property
    
    var infoData: ArchiveDetailInfo? {
        didSet {
            guard let info = self.infoData else { return }
            DispatchQueue.main.async { [weak self] in
                self?.setNewEmotion(info.emotion)
                self?.mainImageView.kf.setImage(with: URL(string: info.mainImage),
                                               placeholder: nil,
                                               options: [.cacheMemoryOnly],
                                               completionHandler: { [weak self] _ in
                    self?.mainImageView.fadeIn(duration: 0.1, completeHandler: nil)
                })
                self?.eventNameLabel.text = info.name
                self?.eventDateLabel.text = info.watchedOn
            }
        }
    }
    
    // MARK: lifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
        ImageCache.default.clearCache()
    }
    
    // MARK: private function
    
    private func initUI() {
        self.scrollView.backgroundColor = .clear
        self.mainContetnsView.backgroundColor = .clear
        
        self.topContainerView.backgroundColor = .clear
        
        self.centerContainerView.backgroundColor = .clear
        
        self.emotionLabel.font = .fonts(.subTitle)
        self.emotionLabel.textColor = Gen.Colors.white.color
        
        self.bottomContainerView.backgroundColor = Gen.Colors.white.color
        
        self.eventNameLabel.font = .fonts(.header2)
        self.eventNameLabel.textColor = Gen.Colors.black.color
        
        self.eventDateLabel.font = .fonts(.header3)
        self.eventDateLabel.textColor = Gen.Colors.black.color
        
        self.friendsCollectionView.register(UINib(nibName: DetailFriendsCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: DetailFriendsCollectionViewCell.identifier)
        self.friendsCollectionView.showsHorizontalScrollIndicator = false
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 9, bottom: 0, right: 0)
        layout.minimumLineSpacing = 12
//        layout.itemSize = CGSize(width: 264, height: 365)
        self.friendsCollectionView.collectionViewLayout = layout
        self.friendsCollectionView.dataSource = self
        self.friendsCollectionView.delegate = self
        self.friendsCollectionView.backgroundColor = .clear
        
    }
    
    private func setNewEmotion(_ emotion: Emotion) {
        self.emotionCoverImageView.image = emotion.coverAlphaImage
        self.mainContetnsView.backgroundColor = emotion.color
        self.emotionLabel.text = emotion.localizationTitle
        self.miniEmotionImageView.image = emotion.preImage
    }
    
    private func getFriendsCellWidth(_ text: String) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: UIFont.fonts(.subTitle)]
        return (text as NSString).size(withAttributes: fontAttributes).width + 25
    }
    
    // MARK: internal function
    
    // MARK: action

}

extension DetailCardCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.infoData?.companions?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: DetailFriendsCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailFriendsCollectionViewCell.identifier, for: indexPath) as? DetailFriendsCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        if let title = self.infoData?.companions?[indexPath.item] {
            cell.mainTitleLabel.text = title
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var cellSize: CGSize = CGSize(width: 10, height: 10)
        if let companions = self.infoData?.companions {
            let text = companions[indexPath.item]
            cellSize = CGSize(width: self.getFriendsCellWidth(text), height: 36)
        }
        
        return cellSize
    }
}
