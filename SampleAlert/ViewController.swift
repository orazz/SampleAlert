//
//  ViewController.swift
//  SampleAlert
//
//  Created by Atakishiyev Orazdurdy on 12/4/14.
//  Copyright (c) 2014 Atakishiyev Orazdurdy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var overlayView: UIView!
    var alertView: UIView!
    var animator: UIDynamicAnimator!
    var attachmentBehavior : UIAttachmentBehavior!
    var snapBehavior : UISnapBehavior!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // Initialize the animator
        animator = UIDynamicAnimator(referenceView: view)
        
        // Create the dark background view and the alert view
        createOverlay()
        createAlert()
    }
    
    func createOverlay() {
        // Create a gray view and set its alpha to 0 so it isn't visible
        overlayView = UIView(frame: view.bounds)
        overlayView.backgroundColor = UIColor.grayColor()
        overlayView.alpha = 0.0
        view.addSubview(overlayView)
    }
    
    func createAlert() {

        let alertWidth: CGFloat = 250
        let alertHeight: CGFloat = 230
        let alertViewFrame: CGRect = CGRectMake(0, 0, alertWidth, alertHeight)
        alertView = UIView(frame: alertViewFrame)
        alertView.backgroundColor = UIColor(red: 236/255, green: 240/255, blue: 241/255, alpha: 1.0)
        alertView.alpha = 0.0
        alertView.layer.cornerRadius = 10;
        alertView.layer.shadowColor = UIColor.blackColor().CGColor;
        alertView.layer.shadowOffset = CGSizeMake(0, 5);
        alertView.layer.shadowOpacity = 0.3;
        alertView.layer.shadowRadius = 10.0;
        
        var backimage:UIImage = UIImage(named: "backalert1")!
        var backview:UIImageView = UIImageView(image: backimage)
        backview.frame = CGRect(x: 0, y: 45, width: alertWidth, height: 135)
        alertView.addSubview(backview)
        
        
        let backviewtop = UIView(frame: CGRectMake(0, 0, alertWidth, 50.0))
        backviewtop.backgroundColor = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1.0)
        
        let lbl_title = UILabel(frame: CGRectMake(0, 5, alertWidth, 20))
        lbl_title.textAlignment = NSTextAlignment.Center
        lbl_title.textColor = UIColor(red: 236/255, green: 240/255, blue: 241/255, alpha: 1.0)
        lbl_title.font = UIFont(name: "Arial", size: 14)
        lbl_title.text = "Some Title"
        
        let lbl_author = UILabel(frame: CGRectMake(0, 20, alertWidth, 20))
        lbl_author.textAlignment = .Center
        lbl_author.textColor = UIColor(red: 236/255, green: 240/255, blue: 241/255, alpha: 1.0)
        lbl_author.font = UIFont(name: "Arial", size: 12)
        var nstext: NSTextAttachment = NSTextAttachment()
        nstext.image = Resize(UIImage(named: "avatar.jpg")!, size: CGSize(width: 10, height: 10))
        var nsattr = NSAttributedString(attachment: nstext)
        var nsmutattr = NSMutableAttributedString(attributedString: nsattr)
        nsmutattr.appendAttributedString(NSAttributedString(string: " Orazz | sample alert"))
        lbl_author.attributedText = nsmutattr
        
        backviewtop.addSubview(lbl_author)
        backviewtop.addSubview(lbl_title)
        
        let btnlike = UIButton.buttonWithType(UIButtonType.System) as UIButton
        btnlike.setTitle(" Like", forState: UIControlState.Normal)
        btnlike.setTitleColor(UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1.0), forState: UIControlState.Normal)
        var likeimg = UIImage(named: "like.png")
        btnlike.setImage(likeimg, forState: UIControlState.Normal)
        btnlike.backgroundColor = UIColor.clearColor()
        btnlike.frame = CGRectMake(0, 180, (alertWidth / 2), 45)
        btnlike.addTarget(self, action: Selector("dismissAlert"), forControlEvents: UIControlEvents.TouchUpInside)
        
        let btnshare = UIButton.buttonWithType(UIButtonType.System) as UIButton
        btnshare.setTitle(" Share", forState: UIControlState.Normal)
        btnshare.setTitleColor(UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1.0), forState: UIControlState.Normal)
        var shareimg = UIImage(named: "share.png")
        btnshare.setImage(shareimg, forState: UIControlState.Normal)
        btnshare.backgroundColor = UIColor.clearColor()
        btnshare.frame = CGRectMake(125, 180, (alertWidth / 2), 45)
        btnshare.addTarget(self, action: Selector("dismissAlert"), forControlEvents: UIControlEvents.TouchUpInside)
        
        alertView.addSubview(btnshare)
        alertView.addSubview(btnlike)
        alertView.addSubview(backviewtop)
        view.addSubview(alertView)
    }
    
    func showAlert() {

        if (alertView == nil) {
            createAlert()
        }
        
        // I create the pan gesture recognizer here and not in ViewDidLoad() to
        // prevent the user moving the alert view on the screen before it is shown.
        // Remember, on load, the alert view is created but invisible to user, so you
        // don't want the user moving it around when they swipe or drag on the screen.
        createGestureRecognizer()
        
        animator.removeAllBehaviors()
        
        // Animate in the overlay
        UIView.animateWithDuration(0.4) {
            self.overlayView.alpha = 1.0
        }
        
        // Animate the alert view using UIKit Dynamics.
        alertView.alpha = 1.0
        
        var snapBehaviour: UISnapBehavior = UISnapBehavior(item: alertView, snapToPoint: view.center)
        animator.addBehavior(snapBehaviour)
    }
    
    func dismissAlert() {
        
        animator.removeAllBehaviors()
        
        var gravityBehaviour: UIGravityBehavior = UIGravityBehavior(items: [alertView])
        gravityBehaviour.gravityDirection = CGVectorMake(0.0, 10.0);
        animator.addBehavior(gravityBehaviour)
        
        // This behaviour is included so that the alert view tilts when it falls, otherwise it will go straight down
        var itemBehaviour: UIDynamicItemBehavior = UIDynamicItemBehavior(items: [alertView])
        itemBehaviour.addAngularVelocity(CGFloat(-M_PI_2), forItem: alertView)
        animator.addBehavior(itemBehaviour)
        
        // Animate out the overlay, remove the alert view from its superview and set it to nil
        // If you don't set it to nil, it keeps falling off the screen and when Show Alert button is
        // tapped again, it will snap into view from below. It won't have the location settings we defined in createAlert()
        // And the more it 'falls' off the screen, the longer it takes to come back into view, so when the Show Alert button
        // is tapped again after a considerable time passes, the app seems unresponsive for a bit of time as the alert view
        // comes back up to the screen
        UIView.animateWithDuration(0.4, animations: {
            self.overlayView.alpha = 0.0
            }, completion: {
                (value: Bool) in
                self.alertView.removeFromSuperview()
                self.alertView = nil
        })
        
    }
    
    @IBAction func showAlertView(sender: UIButton) {
        showAlert()
    }
    
    func createGestureRecognizer() {
        let panGestureRecognizer: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: Selector("handlePan:"))
        view.addGestureRecognizer(panGestureRecognizer)
    }
    
    // This gets called when a pan gesture is recognized. It was set as the selector for the UIPanGestureRecognizer in the
    // createGestureRecognizer() function
    // We check for different states of the pan and do something different in each state
    // In Began, we create an attachment behaviour. We add an offset from the center to make the alert view twist in the
    // the direction of the pan
    // In Changed we set the attachment behaviour's anchor point to the location of the user's touch
    // When the user stops dragging (In Ended), we snap the alert view back to the view's center (which is where it was originally located)
    // When the user drags the view too far down, we dismiss the view
    // I check whether the alert view is not nil before taking action. This ensures that when the user dismisses the alert view
    // and drags on the screen, the app will not crash as it tries to move a view that hasn't been initialized.
    func handlePan(sender: UIPanGestureRecognizer) {
        
        if (alertView != nil) {
            let panLocationInView = sender.locationInView(view)
            let panLocationInAlertView = sender.locationInView(alertView)
            
            if sender.state == UIGestureRecognizerState.Began {
                animator.removeAllBehaviors()
                
                let offset = UIOffsetMake(panLocationInAlertView.x - CGRectGetMidX(alertView.bounds), panLocationInAlertView.y - CGRectGetMidY(alertView.bounds));
                attachmentBehavior = UIAttachmentBehavior(item: alertView, offsetFromCenter: offset, attachedToAnchor: panLocationInView)
                
                animator.addBehavior(attachmentBehavior)
            }
            else if sender.state == UIGestureRecognizerState.Changed {
                attachmentBehavior.anchorPoint = panLocationInView
            }
            else if sender.state == UIGestureRecognizerState.Ended {
                animator.removeAllBehaviors()
                
                snapBehavior = UISnapBehavior(item: alertView, snapToPoint: view.center)
                animator.addBehavior(snapBehavior)
                
                if sender.translationInView(view).y > 100 {
                    dismissAlert()
                }
            }
        }
        
    }
    
    func Resize(image: UIImage, size: CGSize) -> UIImage
    {
        var newSize:CGSize = size
        let rect = CGRectMake(0,0, newSize.width, newSize.height)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        
        // image is a variable of type UIImage
        image.drawInRect(rect)
        
        
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

}

