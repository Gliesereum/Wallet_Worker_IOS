import Foundation
import UIKit

class NibLoadingView: UIView {

	@IBOutlet weak var view: UIView!

	override init(frame: CGRect) {
		super.init(frame: frame)
		nibSetup()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		nibSetup()
	}

	fileprivate func nibSetup() {
		backgroundColor = UIColor.clear

		view = loadViewFromNib()
		view.frame = bounds
		view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		view.translatesAutoresizingMaskIntoConstraints = true

        view.backgroundColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 1)
		addSubview(view)
	}

	fileprivate func loadViewFromNib() -> UIView {
		let bundle = Bundle.FlagPhoneNumber()
		let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
		let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView

		return nibView
	}
}
