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
    
    let dismissButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        let image = #imageLiteral(resourceName: "cancel_icon")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(onDismiss), for: .touchUpInside)
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
        }
        
        if let sampleBuffer = photoSampleBuffer, let previewBuffer = previewPhotoSampleBuffer, let dataImage = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: sampleBuffer, previewPhotoSampleBuffer: previewBuffer) {
            
            if (UIImage(data: dataImage)) != nil {
                let image = UIImage(data: dataImage)
                let view = UIImageView()
                view.image = image
                if currentDevice.position == .front {
                    view.transform = CGAffineTransform(scaleX: -1, y: 1)
                }
                self.view.addSubview(view)
                view.anchor(self.view.topAnchor, left: self.view.leftAnchor, bottom: nil, right: nil, topConstant: 300, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 75, heightConstant: 150)
            }
        }
    }
    
    func onDismiss() {
        print("Dismiss")
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        
        view.addSubview(captureButton)
        view.addSubview(dismissButton)
        
        captureButton.anchor(nil, left: nil, bottom: view.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 75, rightConstant: 0, widthConstant: 75, heightConstant: 75)
        
        let captureButtonCenterXConstraint = NSLayoutConstraint(item: captureButton, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        captureButton.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([captureButtonCenterXConstraint])
        
        dismissButton.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 10, leftConstant: 2, bottomConstant: 0, rightConstant: 0, widthConstant: 50, heightConstant: 50)

        let tap = UITapGestureRecognizer()
        tap.numberOfTapsRequired = 2
        tap.addTarget(self, action: #selector(toggleCam))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tap)
        
        super.viewDidLoad()
        view.backgroundColor = .clear
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
    
}
