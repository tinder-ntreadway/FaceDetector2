//
//  SmileDetectorProtocol.swift
//  FaceDetector2
//
//  Created by Nichole Treadway on 5/17/20.
//  Copyright © 2020 Nichole Treadway. All rights reserved.
//

import UIKit

protocol SmileDetector {

    func detectSmile(in image: UIImage, completion: @escaping ((Bool, Double) -> Void))
}
