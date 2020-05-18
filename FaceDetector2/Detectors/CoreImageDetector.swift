//
//  CoreImageDetector.swift
//  FaceDetector2
//
//  Created by Nichole Treadway on 5/17/20.
//  Copyright © 2020 Nichole Treadway. All rights reserved.
//

import Foundation
import CoreImage
import UIKit

class CoreImageDetector: SmileDetector {

    let accuracy: String

    init(accuracy: String) {
        self.accuracy = accuracy
    }

    func detectSmile(in image: UIImage, completion: @escaping ((Bool, Double) -> Void)) {
        let startTime = NSDate().timeIntervalSince1970

        let ciImage = CIImage(image: image)
        let options = [CIDetectorAccuracy: accuracy, CIDetectorSmile: true] as [String : Any]
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: options)

        let features = faceDetector!.features(in: ciImage!, options: options)

        // Iterate over features
        for feature in features as! [CIFaceFeature] {
            if feature.hasSmile {
                let endTime = NSDate().timeIntervalSince1970 - startTime
                print("Time Spent:\(endTime)")

                completion(true, endTime)
                return
            }
        }

        // No face or smile detected
        let endTime = NSDate().timeIntervalSince1970 - startTime
        print("Time Spent:\(endTime)")
        completion(false, endTime)
    }
}
