//
//  ContainerViewController.swift
//  Taasky
//
//  Created by Audrey M Tam on 18/03/2015.
//  Copyright (c) 2015 Ray Wenderlich. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController, UIScrollViewDelegate {
  @IBOutlet weak var menuContainerView: UIView!
  @IBOutlet weak var scrollView: UIScrollView!
  
  private var detailViewController: DetailViewController?
    
  var menuItem: NSDictionary? {
    didSet {
      hideOrShowMenu(false, animated: true)
      if let detailViewController = detailViewController {
        detailViewController.menuItem = menuItem
      }
    }
  }
  
  var showingMenu = false
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    menuContainerView.layer.anchorPoint = CGPointMake(1.0, 0.5)
    hideOrShowMenu(showingMenu, animated: false)
  }
  
  // MARK: ContainerViewController
  func hideOrShowMenu(show: Bool, animated: Bool) {
    let xOffset = CGRectGetWidth(menuContainerView.bounds)
    scrollView.setContentOffset(show ? CGPointZero : CGPointMake(xOffset, 0), animated: animated)
    showingMenu = show
  }
  
  // MARK: - UIScrollViewDelegate
  func scrollViewDidScroll(scrollView: UIScrollView) {
    let multiplier = 1.0 / CGRectGetWidth(menuContainerView.bounds)
    let offset = scrollView.contentOffset.x * multiplier
    let fraction = 1.0 - offset
    //    println("didScroll offset \(offset)")
    menuContainerView.layer.transform = transformForFraction(fraction)
    menuContainerView.alpha = fraction
    
    if let detailViewController = detailViewController {
      if let rotatingView = detailViewController.hamburgerView {
        rotatingView.rotate(fraction)
      }
    }
    
    /*
    Fix for the UIScrollView paging-related issue mentioned here:
    http://stackoverflow.com/questions/4480512/uiscrollview-single-tap-scrolls-it-to-top
    */
    scrollView.pagingEnabled = scrollView.contentOffset.x < (scrollView.contentSize.width - CGRectGetWidth(scrollView.frame))
    
    let menuOffset = CGRectGetWidth(menuContainerView.bounds)
    showingMenu = !CGPointEqualToPoint(CGPoint(x: menuOffset, y: 0), scrollView.contentOffset)
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "DetailViewSegue" {
      let navigationController = segue.destinationViewController as! UINavigationController
      detailViewController = navigationController.topViewController as? DetailViewController
    }
  }
    
  // MARK: - Private
  
  func transformForFraction(fraction:CGFloat) -> CATransform3D {
    var identity = CATransform3DIdentity
    identity.m34 = -1.0 / 1000.0;
    let angle = Double(1.0 - fraction) * -M_PI_2
    let xOffset = CGRectGetWidth(menuContainerView.bounds) * 0.5
    let rotateTransform = CATransform3DRotate(identity, CGFloat(angle), 0.0, 1.0, 0.0)
    let translateTransform = CATransform3DMakeTranslation(xOffset, 0.0, 0.0)
    return CATransform3DConcat(rotateTransform, translateTransform)
  }


}
