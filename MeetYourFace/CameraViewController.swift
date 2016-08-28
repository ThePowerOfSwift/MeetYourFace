//
//  CameraViewController.swift
//  MeetYourFace
//
//  Created by liusy182 on 28/8/16.
//  Copyright © 2016 liusy182. All rights reserved.
//

import UIKit
import CoreImage
import AVFoundation
import Cartography

class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    private let videoDataOutput = AVCaptureVideoDataOutput()
    private let videoDataOutputQueue = dispatch_queue_create("VideoDataOutputQueue", DISPATCH_QUEUE_SERIAL)
    private let previewLayer = AVCaptureVideoPreviewLayer()
    private let previewView = UIView()
    private let borderImage = UIImage(named: "focus.png")
    private let faceDetector = CIDetector(
        ofType: CIDetectorTypeFace,
        context:nil,
        options:[ CIDetectorAccuracy: CIDetectorAccuracyLow ])

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
        setupAVCapture()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    private func setup() {
        previewView.frame = view.bounds
        view.addSubview(previewView)
        
    }
    
    private func layout() {
        constrain(previewView) {
            $0.edges == $0.superview!.edges
        }
    }
    
    private func setupAVCapture() {
        let session = AVCaptureSession()
        session.beginConfiguration()
        session.sessionPreset = AVCaptureSessionPreset640x480
        
        // find the back facing camera
        let devices = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo) as! [AVCaptureDevice]
        var device: AVCaptureDevice? = nil
        for d in devices {
            if d.position == .Back {
                device = d
                break
            }
        }
        
        // get the input device
        let deviceInput: AVCaptureDeviceInput
        do {
            try deviceInput = AVCaptureDeviceInput(device:device)
        } catch { return }
        
        // add the input to the session
        if(session.canAddInput(deviceInput)) {
            session.addInput(deviceInput)
        }
        
        
        // configure a video data output
        videoDataOutput.videoSettings = [ kCVPixelBufferPixelFormatTypeKey: Int(kCMPixelFormat_32BGRA) ]
        videoDataOutput.alwaysDiscardsLateVideoFrames = true

        // create a serial dispatch queue used for the sample buffer delegate
        // a serial dispatch queue must be used to guarantee that video frames will be delivered in order
        videoDataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
        if(session.canAddOutput(videoDataOutput)) {
            session.addOutput(videoDataOutput)
        }
        
        // get the output for doing face detection.
        let connection = videoDataOutput.connectionWithMediaType(AVMediaTypeVideo)
        connection.videoOrientation = AVCaptureVideoOrientation.Portrait
        connection.enabled = true
        
        previewLayer.session = session
        previewLayer.backgroundColor = UIColor.blackColor().CGColor
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspect
        let rootLayer = previewView.layer
        rootLayer.masksToBounds = true
        previewLayer.frame = rootLayer.bounds
        rootLayer.addSublayer(previewLayer)
        session.commitConfiguration()
        session.startRunning()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //AVCaptureVideoDataOutputSampleBufferDelegate
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, fromConnection connection: AVCaptureConnection!) {
        print("captureOutput")
        // get the image
        let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
//        let attachments = CMCopyDictionaryOfAttachments(kCFAllocatorDefault, sampleBuffer, kCMAttachmentMode_ShouldPropagate)
        let ciImage = CIImage.init(CVPixelBuffer: pixelBuffer!)
        

        // make sure your device orientation is not locked.

        let features = faceDetector.featuresInImage(
            ciImage,
            options: [CIDetectorImageOrientation: 6])

        // get the clean aperture
        // the clean aperture is a rectangle that defines the portion of the encoded pixel dimensions
        // that represents image data valid for display.
        let fdesc = CMSampleBufferGetFormatDescription(sampleBuffer)
        let cleanAperture = CMVideoFormatDescriptionGetCleanAperture(fdesc!, false)
        
        dispatch_async(dispatch_get_main_queue()) {
            self.drawFaces(features,
                        forVideoBox: cleanAperture,
                        orientation: UIDeviceOrientation.Portrait)
        }
        
    }
    
    func drawFaces(
        features: [CIFeature]?,
        forVideoBox clearAperture : CGRect,
        orientation: UIDeviceOrientation) {
        let sublayers = previewLayer.sublayers
        let sublayersCount = sublayers!.count
        var currentSublayer = 0
        let featuresCount = features!.count
        var currentFeature = 0

        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue,
                               forKey:kCATransactionDisableActions)
        
        // hide all the face layers
        for layer in sublayers! {
            if layer.name == "FaceLayer" {
                layer.hidden = true
            }
        }
        if featuresCount == 0 {
            CATransaction.commit()
            return
        }

        
        let parentFrameSize = previewView.frame.size
        let gravity = previewLayer.videoGravity
        
        //let isMirrored = previewLayer.mir
        let previewBox = videoPreviewBoxForGravity(gravity,
            frameSize: parentFrameSize,
            apertureSize: clearAperture.size)

        for ff in features! {
            // find the correct position for the square layer within the previewLayer
            // the feature box originates in the bottom left of the video frame.
            // (Bottom right if mirroring is turned on)
            var faceRect = ff.bounds
            
            // flip preview width and height
            var temp = faceRect.size.width
            faceRect.size.width = faceRect.size.height
            faceRect.size.height = temp
            temp = faceRect.origin.x
            faceRect.origin.x = faceRect.origin.y
            faceRect.origin.y = temp
            // scale coordinates so they fit in the preview box, which may be scaled
            let widthScaleBy = previewBox.size.width / clearAperture.size.height
            let heightScaleBy = previewBox.size.height / clearAperture.size.width
            faceRect.size.width *= widthScaleBy
            faceRect.size.height *= heightScaleBy
            faceRect.origin.x *= widthScaleBy
            faceRect.origin.y *= heightScaleBy

            if false {//isMirrored
                faceRect = CGRectOffset(faceRect, previewBox.origin.x + previewBox.size.width - faceRect.size.width - (faceRect.origin.x * 2), previewBox.origin.y)
            }
            else {
                faceRect = CGRectOffset(faceRect, previewBox.origin.x, previewBox.origin.y)
            }
            
            var featureLayer: CALayer?
            
            // re-use an existing layer if possible
            while currentSublayer < sublayersCount {
                let currentLayer = sublayers![currentSublayer]
                currentSublayer += 1
                if currentLayer.name == "FaceLayer" {
                    featureLayer = currentLayer
                    currentLayer.hidden = false
                    break
                }
            }
            
            // create a new one if necessary
            if (featureLayer != nil) {
                featureLayer = CALayer()
                featureLayer!.contents = borderImage!.CGImage
                featureLayer!.name = "FaceLayer"
                previewLayer.addSublayer(featureLayer!)
                //featureLayer = nil
            }
            featureLayer!.frame = faceRect
            featureLayer!.setAffineTransform(
                CGAffineTransformMakeRotation(0))
           
            
            currentFeature += 1
        }
        CATransaction.commit()

    }
    
    // find where the video box is positioned within the preview layer based on the video size and gravity
    func videoPreviewBoxForGravity (
        gravity: NSString,
        frameSize: CGSize,
        apertureSize:CGSize) -> CGRect {
        let apertureRatio = apertureSize.height / apertureSize.width
        let viewRatio = frameSize.width / frameSize.height
    
        var size = CGSizeZero
        if (gravity.isEqualToString(AVLayerVideoGravityResizeAspectFill)) {
            if (viewRatio > apertureRatio) {
                size.width = frameSize.width
                size.height = apertureSize.width * (frameSize.width / apertureSize.height)
            } else {
                size.width = apertureSize.height * (frameSize.height / apertureSize.width)
                size.height = frameSize.height
            }
        } else if (gravity.isEqualToString(AVLayerVideoGravityResizeAspect)) {
            if (viewRatio > apertureRatio) {
                size.width = apertureSize.height * (frameSize.height / apertureSize.width)
                size.height = frameSize.height
            } else {
                size.width = frameSize.width
                size.height = apertureSize.width * (frameSize.width / apertureSize.height)
            }
        
        } else if (gravity.isEqualToString(AVLayerVideoGravityResize)) {
            size.width = frameSize.width
            size.height = frameSize.height
        }
    
        var videoBox = CGRect()
        videoBox.size = size
        if (size.width < frameSize.width) {
            videoBox.origin.x = (frameSize.width - size.width) / 2
        } else {
            videoBox.origin.x = (size.width - frameSize.width) / 2
        }
    
        if ( size.height < frameSize.height ) {
            videoBox.origin.y = (frameSize.height - size.height) / 2
        } else {
            videoBox.origin.y = (size.height - frameSize.height) / 2
        }
        
        return videoBox
    }


}
