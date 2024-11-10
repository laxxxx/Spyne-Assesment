//
//  PhotoPreviewView.swift
//  SpyneAssesment
//
//  Created by Sree Lakshman on 09/11/24.
//

import UIKit

class PhotoPreviewView: UIView {

    // MARK: - Outlets
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var retakeButton: UIButton!
    @IBOutlet weak var proceedButton: UIButton!

    // MARK: - Actions
    var onRetake: (() -> Void)?
    var onProceed: (() -> Void)?

    @IBAction func retakeButtonTapped(_ sender: UIButton) {
        onRetake?()
    }

    @IBAction func proceedButtonTapped(_ sender: UIButton) {
        onProceed?()
    }

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        guard let view = Bundle.main.loadNibNamed("PhotoPreviewView", owner: self, options: nil)?.first as? UIView else {
            return
        }
        view.frame = self.bounds
        addSubview(view)
    }
}
