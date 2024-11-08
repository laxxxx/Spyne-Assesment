//
//  CapturePhotoViewModel.swift
//  SpyneAssesment
//
//  Created by Sree Lakshman on 09/11/24.
//

import AVFoundation
import UIKit

class CapturePhotoViewModel {
    // MARK: - Properties
    var captureSession: AVCaptureSession!
    var currentDevice: AVCaptureDevice!
    var photoOutput: AVCapturePhotoOutput!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var isFlashOn: Bool = false
    var isUsingFrontCamera: Bool = false
    
    // MARK: - Setup Camera
    func setupCamera(completion: @escaping (AVCaptureVideoPreviewLayer?) -> Void) {
        captureSession = AVCaptureSession()
        photoOutput = AVCapturePhotoOutput()
        
        configureCamera(for: .back)
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        
        // Start the session on a background queue to avoid UI blocking
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
            DispatchQueue.main.async {
                completion(self.previewLayer)
            }
        }
    }
    
    private func configureCamera(for position: AVCaptureDevice.Position) {
        captureSession.beginConfiguration()
        
        // Remove existing inputs
        if let currentInput = captureSession.inputs.first {
            captureSession.removeInput(currentInput)
        }
        
        // Set the new device
        currentDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: position)
        guard let device = currentDevice else { return }
        
        do {
            let input = try AVCaptureDeviceInput(device: device)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            }
            if captureSession.canAddOutput(photoOutput) {
                captureSession.addOutput(photoOutput)
            }
        } catch {
            print("Error configuring camera input: \(error)")
        }
        
        captureSession.commitConfiguration()
    }
    
    // MARK: - Toggle Flash
    func toggleFlash() {
        // Toggle the flash state
        isFlashOn.toggle()
        
        // Debugging output to check the flash state
        print("Flash is \(isFlashOn ? "ON" : "OFF")")
        
        // Ensure flash mode is applied only for the correct camera
        guard let device = currentDevice, device.hasFlash else {
            print("Device doesn't support flash or it's unavailable for the current camera")
            return
        }
        
        // Update flash mode in the settings for the next photo capture
        // No need to lock the device configuration anymore since we're using AVCapturePhotoSettings
        print("Flash mode set to: \(isFlashOn ? "ON" : "OFF")")
    }
    
    // MARK: - Switch Camera
    func switchCamera() {
        isUsingFrontCamera.toggle()
        let newPosition: AVCaptureDevice.Position = isUsingFrontCamera ? .front : .back
        configureCamera(for: newPosition)
    }
    
    // MARK: - Capture Photo
    func capturePhoto(delegate: AVCapturePhotoCaptureDelegate) {
        guard let device = currentDevice else { return }
            
            // Create new AVCapturePhotoSettings each time a photo is captured
            let settings = AVCapturePhotoSettings()
            
            // Apply the flash mode based on the current flash state
            if device.hasFlash {
                settings.flashMode = isFlashOn ? .on : .off
            }
            
            // Capture the photo with the new settings
            photoOutput.capturePhoto(with: settings, delegate: delegate)
    }
}
