//
//  CustomFlipTransition.swift
//  Pods
//
//  Created by MILLMAN on 2016/9/21.
//
//

import UIKit

enum TransitionMode: Int {
    case Present, Dismiss
}

public class CustomFlipTransition: NSObject,UIViewControllerAnimatedTransitioning {
    var duration = 0.3
    var transitionMode:TransitionMode = .Present
    var cardView:UICollectionViewCell!
    var originalCardFrame = CGRect.zero
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let containerView = transitionContext.containerView as? UIView else {
            return
        }
        let toView = transitionContext.view(forKey: .to)
        let fromView = transitionContext.view(forKey: .from)
        let viewRadius = self.cardView.layer.cornerRadius
        
        if self.transitionMode == .Present {
            originalCardFrame = self.cardView.frame
            var toViewF = self.cardView.convert(self.cardView.superview!.frame, to: toView!)
            toView?.frame = self.cardView.bounds
            toView?.layer.cornerRadius = viewRadius
            self.cardView.addSubview(toView!)
    
            UIView.transition(with: self.cardView, duration: 0.7, options: [.transitionFlipFromRight,.curveEaseIn], animations: {
                self.cardView.frame = CGRect.init(x: self.originalCardFrame.origin.x, y: self.originalCardFrame.origin.y, width: toViewF.width, height: toViewF.height)
                }, completion: { (finish) in
                    toView?.frame = toViewF
                    toView?.removeFromSuperview()
                    containerView.addSubview(toView!)
                    transitionContext.completeTransition(true)
            })
        } else {

            var toViewF = self.cardView.superview!.convert(self.cardView.superview!.frame, to: fromView!)

            self.cardView.isHidden = true
            let content = self.cardView.contentView
            let originalCrolor = content.backgroundColor
            content.backgroundColor = self.cardView.backgroundColor
            content.layer.cornerRadius = viewRadius
            fromView?.addSubview(content)
            UIView.transition(with: fromView!, duration: 0.7, options: [.transitionFlipFromLeft,.curveEaseInOut], animations: {
                fromView?.frame = CGRect.init(x: fromView!.frame.origin.x, y: fromView!.frame.origin.y, width: self.originalCardFrame.width, height: self.originalCardFrame.height)
                content.frame = CGRect.init(x: fromView!.frame.origin.x, y: fromView!.frame.origin.y, width: self.originalCardFrame.width, height: self.originalCardFrame.height)
                self.cardView.frame = CGRect.init(x: 0, y: self.originalCardFrame.origin.y, width: self.originalCardFrame.width, height: self.originalCardFrame.height)

                }, completion: { (finish) in
                    content.backgroundColor = originalCrolor
                    content.removeFromSuperview()
                    self.cardView.addSubview(content)
                    self.cardView.isHidden = false
                    transitionContext.completeTransition(true)
            })
        }
    }
    
    public convenience init(duration:TimeInterval) {
        self.init()
        self.duration = duration
    }
}
