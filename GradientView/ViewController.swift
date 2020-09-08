//
//  ViewController.swift
//  GradientView
//
//  Created by Duncan Champney on 9/3/20.
//  Copyright © 2020 Duncan Champney. All rights reserved.
//

import UIKit

enum AnimationTypes: Int {
    case radialAnimation
    case shadowAnimation
}

class ViewController: UIViewController {


    var animationType: AnimationTypes = .radialAnimation {
        didSet {
            switch animationType {
            case .radialAnimation:
                maskedView.isHidden = false
                shadowMaskedImageView.isHidden = true
                stepDelaySwitch.isEnabled = true
                blurSliderLabel.text = "Blur %"
            case .shadowAnimation:
                stepDelaySwitch.isEnabled = false
                maskedView.isHidden = true
                shadowMaskedImageView.isHidden = false
                blurSliderLabel.text = "Blur pixels"
            }
        }
    }
    let durationDefaultValue: Double = 0.25
    let blurPercentDefaultValue: Double = 20.0
    @IBOutlet weak var maskedView: RadialMaskedImageView!
    @IBOutlet weak var shadowMaskedImageView: ShadowMaskImageView!
    
    @IBOutlet weak var animationTypeControl: UISegmentedControl!
    @IBOutlet weak var blurSliderLabel: UILabel!
    @IBOutlet weak var blurPercentSlider: UISlider!
    @IBOutlet weak var blurPercentTextField: UITextField!

    @IBOutlet weak var durationSlider: UISlider!
    @IBOutlet weak var durationTextField: UITextField!
    @IBOutlet weak var stepDelaySwitch: UISwitch!
    @IBOutlet weak var showImageViewSwitch: UISwitch!

    weak var targetTextField: UITextField? = nil

    var blurPercent: Double = 20 {
        didSet {
            if blurPercent < Double(blurPercentSlider.minimumValue) {
                blurPercent = Double(blurPercentSlider.minimumValue)
            } else if blurPercent > Double(blurPercentSlider.maximumValue) {
                blurPercent = Double(blurPercentSlider.maximumValue)
            }
            blurPercentSlider.value = Float(blurPercent)
            blurPercentTextField.text = String(format: "%.1f", blurPercent)
            maskedView.blurPercent = blurPercent / 100.0
            shadowMaskedImageView.blurRadius = blurPercent
        }
    }
    
    var duration: Double = 0.2 {
        didSet {
            if duration < Double(durationSlider.minimumValue) {
                duration = Double(durationSlider.minimumValue)
            } else if duration > Double(durationSlider.maximumValue) {
                duration = Double(durationSlider.maximumValue)
            }
            durationSlider.value = Float(duration)
            durationTextField.text = String(format: "%.2f", duration)
            maskedView.totalDuration = duration
            shadowMaskedImageView.totalDuration = duration
        }
    }

    override func viewDidLoad() {
        animationType = .radialAnimation
        super.viewDidLoad()
        blurPercent = blurPercentDefaultValue
        duration = durationDefaultValue
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    func enableControls(_ enable: Bool) {
        blurPercentSlider.isEnabled = enable
        blurPercentTextField.isEnabled = enable

        durationSlider.isEnabled = enable
        durationTextField.isEnabled = enable
        stepDelaySwitch.isEnabled = enable && animationType == .radialAnimation
        showImageViewSwitch.isEnabled = enable

    }

    @IBAction func handleblurPercentSlider(_ sender: Any) {
        blurPercent = Double(blurPercentSlider.value)
    }

    @IBAction func handleStepDelaySwitch(_ sender: Any) {
        maskedView.midStepDelay = stepDelaySwitch.isOn ? 0.5 : 0
    }

    @IBAction func handleDurationSlider(_ sender: Any) {
        duration = Double(durationSlider.value)
    }

    @IBAction func handleShowImageSwitch(_ sender: UISwitch) {
        let value = sender.isOn
        enableControls(false)
        switch animationType {
        case .radialAnimation:
            maskedView.show(value) { _ in
                self.enableControls(true)
            }
        case .shadowAnimation:
            shadowMaskedImageView.show(value) { _ in
                self.enableControls(true)
            }
        }
    }

    @IBAction func handleAnimationTypeControl(_ sender: UISegmentedControl) {
        animationType = AnimationTypes(rawValue: sender.selectedSegmentIndex)!
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if let targetTextField = targetTextField,
                self.view.frame.origin.y == 0  {
                var shiftAmount = view.safeAreaInsets.bottom + 5 + targetTextField.frame.origin.y + targetTextField.frame.height
                shiftAmount -= (view.bounds.height - keyboardSize.height)
                if shiftAmount > 0 {
                    self.view.frame.origin.y -= shiftAmount
                    
                }
            }
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }

    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        targetTextField = textField
        textField.text = ""
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case durationTextField:
            let durationValue = Double(durationTextField.text ?? "")
            duration = durationValue ?? duration
        case blurPercentTextField:
            let blurPercentValue = Double(blurPercentTextField.text ?? "")
            blurPercent = blurPercentValue ?? blurPercent
            default:
            break
        }
    }
}
