//
//  SmileDetectionView.swift
//  FaceDetector2
//
//  Created by Nichole Treadway on 5/17/20.
//  Copyright © 2020 Nichole Treadway. All rights reserved.
//

import UIKit


class SmileDetectionView: UIView {

    lazy var imageView = UIImageView()
    lazy var photoIndexLabel = UILabel()
    lazy var smileLabel = UILabel()

    var image: UIImage? = nil {
        didSet {
            imageView.image = image
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(imageView)
        addSubview(photoIndexLabel)
        addSubview(smileLabel)

        imageView.frame = CGRect(x: 100, y: 200, width: 200, height: 200)

        photoIndexLabel.textAlignment = .center
        photoIndexLabel.frame = CGRect(x: 0, y: 650, width: frame.width, height: 20)

        smileLabel.textAlignment = .center
        smileLabel.frame = CGRect(x: 0, y: 700, width: frame.width, height: 30)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    func updateSmileLabel(hasSmile: Bool?) {
        guard let hasSmile = hasSmile else {
            smileLabel.text = "?"
            return
        }

        smileLabel.text = hasSmile ? "😃" : "😐"
    }

    func updateImageNumber(imageNum: Int, totalCount: Int) {
        photoIndexLabel.text = "\(imageNum) of \(totalCount) Photos"
    }
}

