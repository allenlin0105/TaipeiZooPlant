//
//  ShrinkHeaderExtension.swift
//  iOS Exercise
//
//  Created by allen on 2022/4/8.
//

import UIKit

// MARK: - ScrollViewDelegate

extension ContentViewController {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let absoluteTop: CGFloat = 0
        // absoluteBottom 是指 contentOffset 會出現的最底位置
        let absoluteBottom: CGFloat = scrollView.contentSize.height - scrollView.frame.size.height
        let offsetY = scrollView.contentOffset.y
        
        // 滑動的距離
        let scrollDiff = offsetY - previousScrollOffset
        
        // 第二個條件是確定目前的上/下滑動是合法的，合法的情況下才去變更 header constraint 的 height
        let isScrollingDown = scrollDiff > 0 && offsetY > absoluteTop
        let isScrollingUp = scrollDiff < 0 && offsetY < absoluteBottom
        
        if canAnimateHeader(scrollView) {
            var newHeight = headerHeightConstraint.constant
            if isScrollingDown {
                // 往下滑的話，header 要逐漸縮小，但最小只能縮到 minHeaderHeight
                newHeight = max(minHeaderHeight, headerHeightConstraint.constant - abs(scrollDiff))
            } else if isScrollingUp && offsetY <= minHeaderHeight {
                // 往上滑的話，header 要逐漸變大，但最大只能到 maxHeaderHeight
                newHeight = min(maxHeaderHeight, headerHeightConstraint.constant + abs(scrollDiff))
            }
            
            if newHeight != headerHeightConstraint.constant {
                // needs to update height
                headerHeightConstraint.constant = newHeight
                // Update header label
                updateHeaderLabelAlpha()
                // 當 header 有在滑動的時候，不要更新 scrollView 的 contentOffset
                if isScrollingDown {
                    scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: previousScrollOffset)
                }
            }
        }
        
        previousScrollOffset = scrollView.contentOffset.y
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // the user removes his finger off the screen
        if !decelerate {
            // deceleration is finished
            scrollViewDidStopScrolling(scrollView)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // 使用者滑完之後可能會需要時間減速讓 scroll view 停下來，當停下來的時候 delegate 就會呼叫這個 function
        scrollViewDidStopScrolling(scrollView)
    }
}

// MARK: - Helpers for ShrinkHeader

extension ContentViewController {
    
    func updateHeaderLabelAlpha() {
        let range = maxHeaderHeight - minHeaderHeight
        let openAmount = headerHeightConstraint.constant - minHeaderHeight
        let percentage = openAmount / range
        
        upperHeaderLabel.alpha = percentage
        lowerHeaderLabel.alpha = 1 - percentage
    }
    
    /// Make sure that when header is collapsed, there is still room to scroll
    private func canAnimateHeader(_ scrollView: UIScrollView) -> Bool {
        // Calculate the size of the scrollView when header is collapsed
        // 計算 scrollView 的高 + 目前的 header 高 - shrink 之後的 header 高
        let scrollViewMaxHeight = scrollView.frame.height + headerHeightConstraint.constant - minHeaderHeight

        return scrollView.contentSize.height > scrollViewMaxHeight
    }
    
    private func scrollViewDidStopScrolling(_ scrollView: UIScrollView) {
        let midPoint = (maxHeaderHeight + minHeaderHeight) / 2
        if headerHeightConstraint.constant > midPoint {
            // header 還縮不夠起來 => Expand header
            UIView.animate(withDuration: 0.2) {
                self.headerHeightConstraint.constant = self.maxHeaderHeight
                self.updateHeaderLabelAlpha()
                scrollView.contentOffset = CGPoint(x: 0.0, y: 0.0)
                self.view.layoutIfNeeded()
            }
        } else {
            // header 縮的夠了 => Shrink header
            UIView.animate(withDuration: 0.2) {
                self.headerHeightConstraint.constant = self.minHeaderHeight
                self.updateHeaderLabelAlpha()
                self.view.layoutIfNeeded()
            }
        }
    }
}
