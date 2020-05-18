//
//  ViewController.swift
//  FaceDetector2
//
//  Created by Nichole Treadway on 5/12/20.
//  Copyright © 2020 Nichole Treadway. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    enum DetectionType {
        case coreImage
        case firebase
    }

    var currentIndex = 0
    var paths: [String] = []

    // Views
    var smileView: SmileDetectionView?

    // Detectors
    lazy var coreImageDetector = CoreImageDetector(accuracy: CIDetectorAccuracyHigh)
    lazy var firebaseDetector = FirebaseDetector(performanceMode: .fast)
    let detectionType: DetectionType = .firebase // .firebase

    // Results
    var smileDetectionsCSV = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        smileView = SmileDetectionView(frame: view.frame)
        view.addSubview(smileView!)

        paths = Bundle.main.paths(forResourcesOfType: "png", inDirectory: "FER2013Test")
        // paths = Bundle.main.paths(forResourcesOfType: "jpg", inDirectory: "Spain 2019")
        cycleThroughImages()
    }

    func cycleThroughImages() {
        let imageLimit =  paths.count // 100
        guard currentIndex < imageLimit else {
            print(smileDetectionsCSV)
            return
        }

        detectImage(at: currentIndex, detectionType: detectionType, completion: {
            let deadline = DispatchTime.now() + .milliseconds(100)  // Change this value to be able to view the results on the view more easily
            DispatchQueue.main.asyncAfter(deadline: deadline) {
                self.currentIndex += 1
                self.cycleThroughImages()
            }
        })
    }


    func detectImage(at index: Int, detectionType: DetectionType, completion: @escaping (() -> Void)) {
        let image = displayImage(at: index)

        detectSmile(in: image!, detectionType: detectionType, completion: { hasSmile, timeTaken in
            self.smileView?.updateSmileLabel(hasSmile: hasSmile)
            self.saveResult(forImageAt: index, hasSmile: hasSmile, timeTaken: timeTaken)
            completion()
        })
    }


    func detectSmile(in image: UIImage,
                     detectionType: DetectionType,
                     completion: @escaping ((Bool, Double) -> Void)) {
        switch detectionType {
        case .coreImage:
            coreImageDetector.detectSmile(in: image, completion: completion)
        case .firebase:
            firebaseDetector.detectSmile(in: image, completion: completion)
        }
    }


    func displayImage(at index: Int) -> UIImage? {
        let imagePath = paths[index]
        let image = UIImage(contentsOfFile: imagePath)
        smileView?.image = image

        smileView?.updateSmileLabel(hasSmile: nil)

        smileView?.updateImageNumber(imageNum: currentIndex + 1, totalCount: paths.count)

        return image
    }


    func saveResult(forImageAt index: Int, hasSmile: Bool, timeTaken: Double) {
        let imagePath = paths[index]
        let pathLast = imagePath.components(separatedBy: "/")
        let fileName = pathLast.last
        self.smileDetectionsCSV += "\(fileName!),\(hasSmile ? 1 : 0),\(timeTaken)\n"
    }
}

