//
//  RootViewController.swift
//  ABC Elementary
//
//  Created by Dmitry on 15/11/2019.
//  Copyright © 2019 ABC. All rights reserved.
//

import Foundation

import UIKit
import CocoaLumberjack

let isPadIdiom = (UIDevice.current.userInterfaceIdiom == .pad)

class RootViewController: UIViewController {

    var statusBarStyle: UIStatusBarStyle = .lightContent
    
    private var current: UIViewController
    private(set) public var mainViewController: MainViewController?
    var windowsScene: UIWindowScene?
    
    static let sharedInstance = RootViewController()
    
    lazy var backgroundView: UIView = {
        let view = UIView.init(frame: self.view.frame)
        view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.view.addSubview(view)
        return view
    }()
    
    init() {
        current = R.storyboard.main.mainViewController()!
        super.init(nibName:  nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChild(current)
        current.view.frame = view.bounds
        view.addSubview(current.view)
        current.didMove(toParent: self)
    }
    
    private func animateFadeTransition(to new: UIViewController, completion: (() -> Void)? = nil) {
        current.willMove(toParent: nil)
        addChild(new)
        view.addSubview(new.view)
        
        transition(from: current, to: new, duration: 0.3, options: [.transitionCrossDissolve, .curveEaseOut], animations: {
            
        }) { completed in
            self.current.removeFromParent()
            new.didMove(toParent: self)
            self.current = new
            completion?()
        }
    }
    
    private func animateDismissTransition(to new: UIViewController, completion: (() -> Void)? = nil) {
        
        let initialFrame = CGRect(x: -view.bounds.width, y: 0, width: view.bounds.width, height: view.bounds.height)
        current.willMove(toParent: nil)
        addChild(new)
        new.view.frame = initialFrame
        
        transition(from: current, to: new, duration: 0.3, options: [], animations: {
            new.view.frame = self.view.bounds
        }) { completed in
            self.current.removeFromParent()
            new.didMove(toParent: self)
            self.current = new
            completion?()
        }
    }
    
//    func show(url: URL!){
//        //UIApplication.shared.open( url, options: [:], completionHandler: nil)
//        let controller = R.storyboard.results.webViewController()!
//        controller.contentURL = url
//        self.show(controller: controller, popoverPresentation: true, animated: true, barButtonItem: nil, preferredContentSize: nil)
//    }
    
    //MARK: show messages
    func show(controller: UIViewController,
                         popoverPresentation: Bool? = false,
                         animated: Bool? = nil,
                         barButtonItem: UIBarButtonItem? = nil, preferredContentSize: CGSize? = nil){
           if isPadIdiom == true {
               controller.modalPresentationStyle = .formSheet
               if popoverPresentation == true {
                   let popover =  controller.popoverPresentationController
                   popover?.permittedArrowDirections = UIPopoverArrowDirection.any
                   popover?.sourceView = current.view
                   popover?.delegate = self
                   popover?.barButtonItem = barButtonItem
                   if preferredContentSize != nil {
                      controller.preferredContentSize = preferredContentSize!
                   }
               }
            }
            else{
               controller.modalPresentationStyle = .overFullScreen
           }
           current.present(controller, animated: (animated ?? true), completion: nil)
       }
       
       func showAlertController(message: String?, parentController: UIViewController? = nil){
            if message != nil {
                showAlertController(title: "", message: message!, completion: nil, animated: true, parentController: parentController)
            }
        }
        
        func showAlertController(title: String, message: String, completion: (()->())?, animated: Bool? = true, parentController: UIViewController? = nil){
            showDialogController(title: title,
                                 message: message,
                                 cancel: nil,
                                 success: completion,
                                 animated: animated,
                                 parentController: parentController)
        }
        
        func showDialogController(title: String,
                                  message: String,
                                  cancelTitle: String? = "Отмена",
                                  cancel: (()->())?,
                                  succesTtitle: String? = "Ок",
                                  success: (()->())?,
                                  animated: Bool?,
                                  parentController: UIViewController? = nil){
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            // change the background color
            let subview = (alertController.view.subviews.first?.subviews.first?.subviews.first!)! as UIView
            subview.layer.cornerRadius = 8
            //subview.backgroundColor = PDAUI.PDAColors.pdaSecondBackgroundColor
//            alertController.setValue(NSAttributedString(string: title,
//                                                        attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17),
//                                                                     NSAttributedString.Key.foregroundColor : PDAUI.PDAColors.pdaInactiveTextColor]),
//                                     forKey: "attributedTitle")
//            alertController.setValue(NSAttributedString(string: message,
//                                                        attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13),
//                                                                     NSAttributedString.Key.foregroundColor : PDAUI.PDAColors.pdaInactiveColor]),
//                                     forKey: "attributedMessage")
       
            if cancel != nil {
              alertController.addAction(UIAlertAction(title: cancelTitle, style: .cancel) { (action: UIAlertAction) in
                  cancel?()
              })
            }
            
            alertController.addAction(UIAlertAction(title: succesTtitle, style: .default) { (action: UIAlertAction) in
                  success?()
            })
            
            if let presentController = parentController{
                presentController.present(alertController, animated: animated ?? true, completion:  nil)
            }
            else{
                if windowsScene != nil {
                    alertController.show(animated ?? true, windowScene: windowsScene!)
                }
                else{
                    alertController.show(animated ?? true)
                }
                
            }
        }

}


extension RootViewController: UIPopoverPresentationControllerDelegate {
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        backgroundView.isHidden = true
    }
    
    func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
        backgroundView.isHidden = false
    }
}
