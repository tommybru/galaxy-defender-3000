import UIKit

var theView = drawing()

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        theView = drawing(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        theView.isUserInteractionEnabled = false
        self.view.addSubview(theView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
