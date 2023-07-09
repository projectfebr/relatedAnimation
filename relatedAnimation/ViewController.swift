//
//  ViewController.swift
//  relatedAnimation
//
//  Created by Aleksandr Bolotov on 09.07.2023.
//

import UIKit

class ViewController: UIViewController {
    private let rect = UIView()
    private lazy var animator = UIViewPropertyAnimator()
    private lazy var isTouched = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rect.backgroundColor = .blue
        rect.layer.cornerRadius = 12
        rect.frame = CGRect(x: 10, y: 200, width: 100, height: 100)
        view.addSubview(rect)
        
        let slider = UISlider()
        slider.frame = CGRect(x: 10, y: 350, width: (view.frame.width - 20), height: 50)
        slider.value = 0
        view.addSubview(slider)
        
        slider.addTarget(self, action: #selector(didChangeValue(_ :)), for: .valueChanged)
        slider.addTarget(self, action: #selector(didEndEdit(_:)), for: [.touchUpInside, .touchUpOutside])
        setupAnimator()
    }
    
    @objc
    private func didChangeValue(_ sender: UISlider) {
        let value = CGFloat(sender.value)
        animator.fractionComplete = isTouched ? 1 - value : value
    }
    
    @objc
    private func didEndEdit(_ sender: UISlider) {
        animator.isReversed = isTouched
        
        animator.addCompletion { _ in
            self.isTouched = true
            self.setupAnimator()
        }
        
        animator.startAnimation()
        sender.setValue(1.0, animated: true)
    }
    
    private func resultFrame() -> CGRect {
        return isTouched ?
        CGRect(x: 10, y: 200, width: 100, height: 100) :
        CGRect(x: (view.frame.width - 150 - 10), y: 200, width: 150, height: 150)
    }
    
    private func setupAnimator() {
        animator = UIViewPropertyAnimator(duration: 0.7, curve: .easeInOut)
        
        animator.addAnimations { [unowned self] in
            let edge = isTouched ? 0 : (CGFloat.pi / 2)
            rect.transform = CGAffineTransform(rotationAngle: edge)
            rect.frame = resultFrame()
        }
    }
}
