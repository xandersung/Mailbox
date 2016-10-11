//
//  MailboxViewController.swift
//  Mailbox
//
//  Created by Sung, Alexander on 10/6/16.
//  Copyright © 2016 Capital One. All rights reserved.
//

import UIKit

class MailboxViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var rightIcon: UIImageView!
    @IBOutlet weak var leftIcon: UIImageView!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var messageView: UIImageView!
    @IBOutlet weak var feedView: UIImageView!
    @IBOutlet weak var rescheduleImageView: UIImageView!
    @IBOutlet weak var listImageView: UIImageView!
    
    var messageOriginalCenter: CGPoint!
    var leftIconOriginalCenter: CGPoint!
    var rightIconOriginalCenter: CGPoint!

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: 320, height: 1600)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func messagePanned(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        print(translation.x)
        if sender.state == .began {
            messageOriginalCenter = messageView.center
            leftIconOriginalCenter = leftIcon.center
            rightIconOriginalCenter = rightIcon.center
        } else if sender.state == .changed {
            messageView.center = CGPoint(x: messageOriginalCenter.x  + translation.x, y: messageOriginalCenter.y)
            if translation.x < 0 {
                leftIcon.alpha = 0
            } else {
                rightIcon.alpha = 0
            }
            rightIcon.image = UIImage(named:"later_icon")
            leftIcon.image = UIImage(named:"archive_icon")
            self.rightIcon.alpha = self.convertValue(value: Float(translation.x), r1Min: 0, r1Max: -60, r2Min: 0, r2Max: 1)
            self.leftIcon.alpha = self.convertValue(value: Float(translation.x), r1Min: 0, r1Max: 60, r2Min: 0, r2Max: 1)
            if translation.x < -60 && translation.x > -260 {
                cellView.backgroundColor = UIColor.yellow
                rightIcon.center = CGPoint(x: rightIconOriginalCenter.x + translation.x + 60, y: rightIconOriginalCenter.y)
            } else if translation.x < -260 {
                cellView.backgroundColor = UIColor.brown
                rightIcon.image = UIImage(named:"list_icon")
                rightIcon.center = CGPoint(x: rightIconOriginalCenter.x + translation.x + 60, y: rightIconOriginalCenter.y)
            } else if translation.x > 60 && translation.x < 260 {
                cellView.backgroundColor = UIColor.green
                leftIcon.image = UIImage(named:"archive_icon")
                leftIcon.center = CGPoint(x: leftIconOriginalCenter.x + translation.x - 60, y: leftIconOriginalCenter.y)
            } else if translation.x > 260 {
                cellView.backgroundColor = UIColor.red
                leftIcon.image = UIImage(named:"delete_icon")
                leftIcon.center = CGPoint(x: leftIconOriginalCenter.x + translation.x - 60, y: leftIconOriginalCenter.y)
            } else {
                cellView.backgroundColor = UIColor.lightGray
            }
        } else if sender.state == .ended {
            print(translation.x)
            if translation.x > -60 && translation.x < 0 {
                UIView.animate(withDuration:0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options:[] ,
                               animations: { () -> Void in
                                self.messageView.center = self.messageOriginalCenter
                                self.rightIcon.center = self.rightIconOriginalCenter
                    }, completion: nil)
            } else if translation.x < -60 && translation.x > -260 {
                UIView.animate(withDuration:0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options:[] ,
                               animations: { () -> Void in
                                self.messageView.frame.origin.x = (self.messageView.frame.size.width * -1)
                                self.rightIcon.frame.origin.x = 15
                    }, completion: {(Bool)  in
                        self.rescheduleImageView.alpha = 1
                })
            } else if translation.x < -260 {
                UIView.animate(withDuration:0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options:[] ,
                               animations: { () -> Void in
                                self.messageView.frame.origin.x = (self.messageView.frame.size.width * -1)
                                self.rightIcon.frame.origin.x = 15
                    }, completion: {(Bool)  in
                        self.listImageView.alpha = 1
                })
            }
            if translation.x < 60 && translation.x > 0 {
                UIView.animate(withDuration:0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options:[] ,
                               animations: { () -> Void in
                                self.messageView.center = self.messageOriginalCenter
                                self.leftIcon.center = self.leftIconOriginalCenter
                    }, completion: nil)
            } else if translation.x > 60 && translation.x < 260 {
                UIView.animate(withDuration:0.4, delay: 0, options:[] ,
                               animations: { () -> Void in
                                self.messageView.frame.origin.x = self.messageView.frame.size.width
                                self.leftIcon.frame.origin.x = self.messageView.frame.size.width - 45
                    }, completion: {(Bool)  in
                        UIView.animate(withDuration:0.4, delay: 0, options:[] ,
                                       animations: { () -> Void in
                                        self.feedView.frame.origin.y = self.messageView.frame.origin.y
                            }, completion:nil)
                })
            } else if translation.x > 260 {
                UIView.animate(withDuration:0.4, delay: 0, options:[] ,
                               animations: { () -> Void in
                                self.messageView.frame.origin.x = self.messageView.frame.size.width
                                self.leftIcon.frame.origin.x = self.messageView.frame.size.width - 45
                    }, completion: {(Bool)  in
                        UIView.animate(withDuration:0.4, delay: 0, options:[] ,
                                       animations: { () -> Void in
                                        self.feedView.frame.origin.y = self.messageView.frame.origin.y
                            }, completion:nil)
                })
            }
        }
        
    }
    @IBAction func optionsViewTapped(_ sender: UITapGestureRecognizer) {
        self.rescheduleImageView.alpha = 0
        UIView.animate(withDuration:0.3, delay: 0, options:[] ,
                       animations: { () -> Void in
                        self.feedView.frame.origin.y = self.messageView.frame.origin.y
            }, completion: nil)
    }
    
    @IBAction func listViewTapped(_ sender: UITapGestureRecognizer) {
        self.listImageView.alpha = 0
        UIView.animate(withDuration:0.3, delay: 0, options:[] ,
                       animations: { () -> Void in
                        self.feedView.frame.origin.y = self.messageView.frame.origin.y
            }, completion: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < -20 {
            self.messageView.center = self.messageOriginalCenter
            self.leftIcon.center = self.leftIconOriginalCenter
            self.rightIcon.center = self.rightIconOriginalCenter
            self.feedView.frame.origin.y = (self.messageView.frame.origin.y + self.messageView.frame.size.height)
        }
    }
    
    func convertValue(value: Float, r1Min: Float, r1Max: Float, r2Min: Float, r2Max: Float) -> CGFloat {
        let ratio = (r2Max - r2Min) / (r1Max - r1Min)
        return CGFloat(value * ratio + r2Min - r1Min * ratio)
    }

}
