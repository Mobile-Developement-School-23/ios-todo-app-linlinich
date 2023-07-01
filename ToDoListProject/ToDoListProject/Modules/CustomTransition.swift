//
//  CustomTransition.swift
//  ToDoListProject
//
//  Created by Ангелина Решетникова on 01.07.2023.
//

import UIKit

class CustomTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.9 // Установите желаемую продолжительность анимации
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
              let toVC = transitionContext.viewController(forKey: .to),
              let fromView = transitionContext.view(forKey: .from),
              let toView = transitionContext.view(forKey: .to) else {
            return
        }
        
        let containerView = transitionContext.containerView
        
        // Установите начальное состояние для анимации
        toView.frame = CGRect(x: 0, y: containerView.frame.height, width: containerView.frame.width, height: containerView.frame.height)
        
        // Добавьте новый view controller на контейнер
        containerView.addSubview(toVew)
        
        // Выполните анимацию
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            fromView.frame = CGRect(x: 0, y: -containerView.frame.height, width: containerView.frame.width, height: containerView.frame.height)
            toView.frame = CGRect(x: 0, y: 0, width: containerView.frame.width, height: containerView.frame.height)
        }) { (finished) in
            // Завершите анимацию и сообщите о ее завершении
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}

