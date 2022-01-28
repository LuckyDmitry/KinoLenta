//
//  SearchedMoviesTransitionManager.swift
//  KinoLenta
//
//  Created by Trifonov Dmitry on 1/14/22.
//

import Foundation
import UIKit

final class SearchedMoviesTransitionManager: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration = 0.25
    let toViewController: MovieDetailViewController
    let fromViewController: SearchedMoviesViewController
    let cellViewController: SearchedMovieTableViewCell
    
    init(toVC: MovieDetailViewController,
         fromVC: SearchedMoviesViewController,
         cell: SearchedMovieTableViewCell) {
        self.toViewController = toVC
        self.fromViewController = fromVC
        self.cellViewController = cell
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        
        let presentedView = toViewController.view!
        presentedView.setNeedsLayout()
        presentedView.layoutIfNeeded()
        
        containerView.addSubview(presentedView)
        
        guard let posterCell = toViewController.getCellFor(section: .poster) else { return }
        
        let window = toViewController.view.window ?? fromViewController.view.window
        let presentedImageViewRect = posterCell.convert(posterCell.bounds, to: window)
        
        let selectedCellImageViewRect = cellViewController.ratingView.convert(cellViewController.ratingView.bounds,
                                                          to: window)
        
        let presentedImageView = UIImageView(frame: presentedImageViewRect)
        presentedImageView.image = cellViewController.ratingView.image
        presentedImageView.alpha = 0
        
        let selectedCellImageView = cellViewController.ratingView.snapshotView(afterScreenUpdates: false)!
        selectedCellImageView.frame = selectedCellImageViewRect
        
        [presentedImageView, selectedCellImageView].forEach { containerView.addSubview($0) }
        
        presentedView.alpha = 0
        
        UIView.animateKeyframes(withDuration: duration,
                                delay: 0,
                                options: .calculationModeCubic,
                                animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1, animations: {
                selectedCellImageView.frame = presentedImageViewRect
                presentedImageView.frame = presentedImageViewRect
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.10, relativeDuration: 0.9, animations: {
                selectedCellImageView.alpha = 0
                presentedImageView.alpha = 1
            })
            
        }, completion: { _ in
            presentedView.alpha = 1
            selectedCellImageView.removeFromSuperview()
            presentedImageView.removeFromSuperview()
            
            transitionContext.completeTransition(true)
        })
    }
}
