import UIKit

final class CustomSearchBar: UISearchBar {
    
    //MARK: Properties
    
    var preferredFont: UIFont? {
        didSet {
            searchTextField.font = preferredFont
        }
    }
    
    var preferredTextColor: UIColor? {
        didSet {
            searchTextField.textColor = preferredTextColor
        }
    }
    
    //MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame        
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { return nil }
    
    //MARK: Draw
    
    override internal func draw(_ rect: CGRect) {
        searchTextField.frame = CGRect(x: 5.0, y: 5.0, width: frame.size.width - 10.0, height: frame.size.height)
        
        searchBarStyle = .default
        backgroundImage = UIImage()
        isTranslucent = false
        searchTextField.leftView = UIView()
        searchTextField.backgroundColor = barTintColor
        searchTextField.borderStyle = .none
        
        drawTextLayer()
        
        super.draw(rect)
    }
    
    private func drawTextLayer() {
        let startPoint = CGPoint(x: 20, y: frame.size.height)
        let endPoint = CGPoint(x: frame.size.width - 20, y: frame.size.height)
        
        let path = UIBezierPath()
        path.move(to: startPoint)
        path.addLine(to: endPoint)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.lineWidth = 2.5
        
        layer.addSublayer(shapeLayer)
    }
}
