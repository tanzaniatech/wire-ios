//
// Wire
// Copyright (C) 2018 Wire Swiss GmbH
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program. If not, see http://www.gnu.org/licenses/.
//

import Foundation

extension KeyboardAvoidingViewController {
    @objc func keyboardFrameWillChange(_ notification: Notification?) {

        ///TODO: cancel last animation instead of flag
        print("⏱️ \(Date().timeIntervalSince1970)")

        if #available(iOS 10.0, *) {
            guard let duration = notification?.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval,
                  let curveRawValue = notification?.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? Int,
                  let animationCurve = UIViewAnimationCurve(rawValue: curveRawValue) else { return }

            let keyboardFrameInView = UIView.keyboardFrame(in: self.view, forKeyboardNotification: notification)


            animator?.stopAnimation(true)
            animator = UIViewPropertyAnimator(duration: duration, curve: animationCurve, animations: {
                let bottomOffset: CGFloat = -keyboardFrameInView.size.height
                print("⏱️ bottomOffset = \(bottomOffset)")
                ///TODO: step 1: 0. step 2: -291
                // 0 => -291 first first appear
                if self.bottomEdgeConstraint.constant != bottomOffset {
                    self.bottomEdgeConstraint.constant = bottomOffset
                    self.view.layoutIfNeeded()
                }
            })

            animator?.startAnimation()
        } else {

            UIView.animate(withKeyboardNotification: notification,
                           in: view,
                           animations: { keyboardFrameInView in
                            let bottomOffset: CGFloat = -keyboardFrameInView.size.height
                            print("⏱️ bottomOffset = \(bottomOffset)")
                            ///TODO: step 1: 0. step 2: -291
                            // 0 => -291 first first appear
                            if self.bottomEdgeConstraint.constant != bottomOffset {
                                self.bottomEdgeConstraint.constant = bottomOffset
                                self.view.layoutIfNeeded()
                            }
            }, completion: nil
            )
        }
    }
}

