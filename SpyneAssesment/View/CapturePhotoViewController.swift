//
//  CapturePhotoViewController.swift
//  SpyneAssesment
//
//  Created by Sree Lakshman on 08/11/24.
//

import UIKit
import AVFoundation

class CapturePhotoViewController: UIViewController, AVCapturePhotoCaptureDelegate {

    // MARK: - UI Elements
    @IBOutlet weak var capturePreviewView: UIView!
    @IBOutlet weak var captureButton: UIButton!
    @IBOutlet weak var flashButton: UIButton!
    @IBOutlet weak var switchCameraButton: UIButton!

    // MARK: - ViewModel
    var viewModel = CapturePhotoViewModel()

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        checkCameraPermission()
    }

    // MARK: - Camera Permission
    private func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            // Permission granted, setup the camera preview
            setupCameraPreview()
        case .notDetermined:
            // Ask for permission
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    if granted {
                        self?.setupCameraPreview()
                    } else {
                        self?.showPermissionAlert()
                    }
                }
            }
        case .denied, .restricted:
            // Permission denied or restricted, show the alert
            showPermissionAlert()
        @unknown default:
            // Handle any future cases
            break
        }
    }

    // MARK: - Setup Camera Preview
    private func setupCameraPreview() {
        viewModel.setupCamera { [weak self] previewLayer in
            guard let previewLayer = previewLayer else { return }
            
            self?.capturePreviewView.layer.insertSublayer(previewLayer, at: 0)
            previewLayer.frame = (self?.capturePreviewView.frame)!
        }
    }

    // MARK: - Button Actions
    @IBAction func flashButtonTapped(_ sender: UIButton) {
        viewModel.toggleFlash()
        let flashImage = viewModel.isFlashOn ? "bolt.fill" : "bolt.slash.fill"
        flashButton.setImage(UIImage(systemName: flashImage), for: .normal)
    }

    @IBAction func switchCameraButtonTapped(_ sender: UIButton) {
        viewModel.switchCamera()
    }

    @IBAction func captureButtonTapped(_ sender: UIButton) {
        viewModel.capturePhoto(delegate: self)
    }

    // MARK: - AVCapturePhotoCaptureDelegate
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else { return }
        self.showPhotoPreview(with: image)
    }
    
    private func showPhotoPreview(with image: UIImage) {
        let photoPreviewView = PhotoPreviewView(frame: self.view.bounds)
        photoPreviewView.previewImageView.image = image

        // Handle button actions
        photoPreviewView.onRetake = { [weak self] in
            photoPreviewView.removeFromSuperview()
        }

        photoPreviewView.onProceed = { [weak self] in
            self?.handleCapturedImage(image)
        }

        // Add the preview view to the main view
        self.view.addSubview(photoPreviewView)
    }
    
    private func handleCapturedImage(_ image: UIImage) {
        // For now, simply print a message
        print("Image captured successfully. Ready to proceed.")
        // You can perform further actions like saving the image or uploading it here.
    }



    // MARK: - Alert for Permission
    private func showPermissionAlert() {
        let alert = UIAlertController(title: "Camera Permission Required",
                                      message: "Please enable camera access in settings to capture photos.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Open Settings", style: .default) { _ in
            guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(settingsURL)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
}
