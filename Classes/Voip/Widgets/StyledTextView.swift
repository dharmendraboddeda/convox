/*
 * Copyright (c) 2010-2020 Belledonne Communications SARL.
 *
 * This file is part of linphone-iphone
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

import Foundation

class StyledTextView: UITextView, UITextViewDelegate {
	
	var placeholder:String?
	var style:TextStyle?
	var liveValue: MutableLiveData<String>? = nil

	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	init (_ style:TextStyle, placeHolder:String? = nil, liveValue: MutableLiveData<String>, readOnly:Bool = false) {
		self.style = style
		self.liveValue = liveValue
		super.init(frame:.zero, textContainer: nil)
		applyStyle(style)
		setFormInputBackground(readOnly:readOnly)
		placeHolder.map {
			self.placeholder = $0
		}
		delegate = self
		liveValue.readCurrentAndObserve { (value) in
			self.text = value
			if (value == nil || value?.count == 0) {
				self.showPlaceHolder()
			}
		}
		if (readOnly) {
			textColor = textColor?.withAlphaComponent(0.5)
		}
		isUserInteractionEnabled = !readOnly
   }
		
	func textViewDidBeginEditing(_ textView: UITextView) {
		if text == placeholder {
			placeholder = textView.text
			text = ""
			textColor = style?.fgColor.get().withAlphaComponent(1.0)
		}
	}

	func textViewDidEndEditing(_ textView: UITextView) {
		if text == "" {
			showPlaceHolder()
		}
	}
	
	private func showPlaceHolder() {
		text = placeholder
		textColor = style?.fgColor.get().withAlphaComponent(0.5)
	}
	
	func textViewDidChange(_ textView: UITextView) {
		liveValue?.value = textView.text
	}
	
}
