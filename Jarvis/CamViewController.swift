import UIKit
import AVFoundation
import LBTAComponents

class CamViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    
    let cameraOutput = AVCapturePhotoOutput()
    
    let captureSession: AVCaptureSession = {
        return AVCaptureSession()
    }()
    
    let frontCamera: AVCaptureDevice = {
        return AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: .front)
    }()
    
    let backCamera: AVCaptureDevice = {
        AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: .back)
    }()
    
    var captureDeviceInputBack:AVCaptureDeviceInput!
    
    var captureDeviceInputFront:AVCaptureDeviceInput!
    
    var currentDevice:AVCaptureDevice!
    
    let captureButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 75, height: 75))
        button.backgroundColor = .clear
        button.layer.borderWidth = 5
        button.layer.borderColor = UIColor(r: 232, g: 232, b: 232).cgColor
        button.layer.cornerRadius = 75/2
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(onCapture), for: .touchUpInside)
        return button
    }()
    
    let flipCamera: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        let image = #imageLiteral(resourceName: "camera_rotate_icon")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(toggleCam), for: .touchUpInside)
        return button
    }()
    
    func onCapture() {
        UIView.animate(withDuration: 0.05, animations: {
            self.captureButton.transform = CGAffineTransform.identity.scaledBy(x: 1.1, y: 1.1)
        }, completion: { (finish) in
            UIView.animate(withDuration: 0.05, animations: {
                self.captureButton.transform = CGAffineTransform.identity
            })
        })
        
        let settings = AVCapturePhotoSettings()
        let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first!
        let previewFormat = [
            kCVPixelBufferPixelFormatTypeKey as String: previewPixelType,
            kCVPixelBufferWidthKey as String: 160,
            kCVPixelBufferHeightKey as String: 160
        ]
        settings.previewPhotoFormat = previewFormat
        self.cameraOutput.capturePhoto(with: settings, delegate: self)
        
    }
    
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        if let sampleBuffer = photoSampleBuffer, let previewBuffer = previewPhotoSampleBuffer, let dataImage = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: sampleBuffer, previewPhotoSampleBuffer: previewBuffer) {
            
            if (UIImage(data: dataImage)) != nil {
                let view = UIImageView()
                view.image = UIImage(data: dataImage)
                if currentDevice.position == .front {
                    view.transform = CGAffineTransform(scaleX: -1.33, y: 1)
                } else {
                    view.transform = CGAffineTransform(scaleX: 1.33, y: 1)
                }
                present(CapturedImageView.init(view: view), animated: true, completion: nil)
            }
        }
    }
    
    func onDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .clear

        view.addSubview(flipCamera)
        flipCamera.anchor(view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 2, widthConstant: 50, heightConstant: 50)

        view.addSubview(captureButton)
        captureButton.anchor(nil, left: nil, bottom: view.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 25, rightConstant: 0, widthConstant: 75, heightConstant: 75)
        let captureButtonCenterXConstraint = NSLayoutConstraint(item: captureButton, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        captureButton.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([captureButtonCenterXConstraint])
        

        let tap = UITapGestureRecognizer()
        tap.numberOfTapsRequired = 2
        tap.addTarget(self, action: #selector(toggleCam))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tap)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        self.view.addGestureRecognizer(swipeDown)
        
        super.viewDidLoad()
        load()
    }
    
    func load() {
        currentDevice = frontCamera
        captureSession.startRunning()
        
        if  captureSession.canSetSessionPreset(AVCaptureSessionPresetHigh) {
            captureSession.sessionPreset = AVCaptureSessionPresetPhoto
        }
        
        do {
            try captureDeviceInputBack = AVCaptureDeviceInput(device: backCamera)
            try captureDeviceInputFront = AVCaptureDeviceInput(device: frontCamera)
            toggleCam()
        } catch {
            print("Could not get input")
            return
        }
        
        captureSession.addOutput(cameraOutput)
       
        let capturePreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        capturePreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        capturePreviewLayer?.frame = self.view.frame
        capturePreviewLayer?.bounds = self.view.bounds
        self.view.layer.insertSublayer(capturePreviewLayer!, at: 0)
    }
    
    func toggleCam() {
        if currentDevice.position == .front {
            captureSession.removeInput(captureDeviceInputFront)
            currentDevice = backCamera
            if captureSession.canAddInput(captureDeviceInputBack) {
                captureSession.addInput(captureDeviceInputBack)
            }
        } else {
            captureSession.removeInput(captureDeviceInputBack)
            currentDevice = frontCamera
            if captureSession.canAddInput(captureDeviceInputFront) {
                captureSession.addInput(captureDeviceInputFront)
            }
        }
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                print("Swiped right")
            case UISwipeGestureRecognizerDirection.down:
                print("Swiped down")
                onDismiss()
            case UISwipeGestureRecognizerDirection.left:
                print("Swiped left")
            case UISwipeGestureRecognizerDirection.up:
                print("Swiped up")
            default:
                break
            }
        }
    }

    
}
