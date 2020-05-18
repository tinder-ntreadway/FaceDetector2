//
//  FirebaseDetector.swift
//  FaceDetector2
//
//  Created by Nichole Treadway on 5/17/20.
//  Copyright © 2020 Nichole Treadway. All rights reserved.
//

import UIKit
import Firebase


class FirebaseDetector: SmileDetector {

    lazy var vision = Vision.vision()
    let performanceMode: VisionFaceDetectorPerformanceMode // .accurate or .fast

    init(performanceMode: VisionFaceDetectorPerformanceMode) {
        self.performanceMode = performanceMode
    }

    func detectSmile(in image: UIImage, completion: @escaping ((Bool, Double) -> Void)) {
        let startTime = NSDate().timeIntervalSince1970

        let options = VisionFaceDetectorOptions()
        options.performanceMode = performanceMode
        options.landmarkMode = .all
        options.classificationMode = .all

        let faceDetector = vision.faceDetector(options: options)
        let visionImage = VisionImage(image: image)

        faceDetector.process(visionImage) { faces, error in
          guard error == nil, let faces = faces, !faces.isEmpty else {
            let endTime = NSDate().timeIntervalSince1970 - startTime
            print("Time Spent:\(endTime)")
            completion(false, endTime)
            return
          }

            for face in faces {
                if face.hasSmilingProbability {
                    let smileProb = face.smilingProbability

                    if smileProb > 0.5 {
                        let endTime = NSDate().timeIntervalSince1970 - startTime
                        print("Time Spent:\(endTime)")
                        completion(true, endTime)
                        return
                    } else {
                        let endTime = NSDate().timeIntervalSince1970 - startTime
                        print("Time Spent:\(endTime)")
                        completion(false, endTime)
                        return
                    }
                }
            }


            let endTime = NSDate().timeIntervalSince1970 - startTime
            print("Time Spent:\(endTime)")
            completion(false, endTime)
        }
    }
}
