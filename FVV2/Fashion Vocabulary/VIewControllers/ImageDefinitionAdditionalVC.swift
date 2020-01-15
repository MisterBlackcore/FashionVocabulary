import UIKit

class ImageDefinitionAdditionalVC: UIViewController {

    @IBOutlet weak var englishWordLabel: UILabel!
    @IBOutlet weak var wordImageView: UIImageView!
    @IBOutlet weak var englishDefinitionLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var viewUnderBackButton: UIView!
    @IBOutlet weak var englishWordView: UIView!
    @IBOutlet weak var fixedSizeViewForButton: UIView!
    @IBOutlet weak var bottomContainerView: UIView!
    @IBOutlet weak var viewForImageView: UIView!
    
    var word:Word?
    var imageScaled = false
    var fullImageView = UIImageView()
    
    let space = " "
    let shadowRadius:CGFloat = 10
    let colorArray = [UIColor.red.cgColor, UIColor.green.cgColor, UIColor.gray.cgColor, UIColor.purple.cgColor, UIColor.orange.cgColor,UIColor.white.cgColor,UIColor.cyan.cgColor]
    
    //MARK: - Main Functions
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        customzeBackButton()
        customizeEnglishWordLabel()
        customizeImageView()
        createfullScaledImageView()
        customizeViewUnderButton()
        addDepthToBottomContainerView()
        fillInLabels()
    }
    
    //MARK: - IBActions
    
    @IBAction func backButtonIsPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func fullScreenPicture() {
        if imageScaled == false {
            UIView.animate(withDuration: 0.3) {
                self.fullImageView.frame = self.view.frame
            }
            imageScaled = true
        } else {
            UIView.animate(withDuration: 0.3) {
                self.fullImageView.frame = CGRect(x: self.viewForImageView.frame.origin.x,
                                                  y: self.viewForImageView.frame.origin.y,
                                                  width: self.viewForImageView.frame.size.width ,
                                                  height: self.viewForImageView.frame.size.height)
            }
            imageScaled = false
        }
    }
    
    //MARK: - Flow Functions
    
    func customizeEnglishWordLabel() {
        englishWordLabel.layer.cornerRadius = 5
        englishWordLabel.layer.borderWidth = 1
        englishWordLabel.layer.borderColor = UIColor.black.cgColor
    }
    
    func fillInLabels() {
        if let englishWord = word?.englishWord {
            englishWordLabel.text = space + englishWord + space
        }
        englishDefinitionLabel.text = word?.englishDefinition
    }
    
    func customzeBackButton() {
        backButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        backButton.layer.cornerRadius = 10
        backButton.backgroundColor = .black
        backButton.setTitleColor(UIColor.white, for: .normal)
    }
    
    func createfullScaledImageView() {
        fullImageView.backgroundColor = .black
        fullImageView.contentMode = .scaleAspectFit
        fullImageView.frame = CGRect(x: viewForImageView.frame.origin.x,
                                     y: englishWordView.frame.size.height,
                                     width: self.view.frame.size.width ,
                                     height: viewForImageView.frame.size.height)
        fullImageView.image = wordImageView.image
        fullImageView.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(fullScreenPicture))
        fullImageView.addGestureRecognizer(tap)
        
        view.addSubview(fullImageView)
    }
    
    func customizeImageView() {
        wordImageView.backgroundColor = .black
        wordImageView.contentMode = .scaleAspectFit
        wordImageView.image = word?.wordImage
    }
    
    func customizeViewUnderButton() {
        self.viewUnderBackButton.frame.origin.x += 10
        self.viewUnderBackButton.frame.origin.y += 10
        viewUnderBackButton.frame.size.height -= 20
        viewUnderBackButton.frame.size.width -= 20
        
        viewUnderBackButton.layer.shadowOpacity = 1.0
        viewUnderBackButton.layer.shadowColor = UIColor.white.cgColor
        viewUnderBackButton.layer.shadowRadius = shadowRadius-5
        viewUnderBackButton.layer.cornerRadius = 10
        startAnimateViewWithShadow()
    }
    
    func startAnimateViewWithShadow() {
        UIView.animate(withDuration: 2.5, animations: {
            self.viewUnderBackButton.frame.origin.x -= 10
            self.viewUnderBackButton.frame.origin.y -= 10
            self.viewUnderBackButton.frame.size.height += 20
            self.viewUnderBackButton.frame.size.width += 20
        }) { (_) in
            self.endAnimateViewWithShaodw()
        }
    }
    
    func endAnimateViewWithShaodw() {
        UIView.animate(withDuration: 2.5, animations: {
            self.viewUnderBackButton.frame.origin.x += 10
            self.viewUnderBackButton.frame.origin.y += 10
            self.viewUnderBackButton.frame.size.height -= 20
            self.viewUnderBackButton.frame.size.width -= 20
        }) { (_) in
            self.viewUnderBackButton.layer.shadowColor = self.chooseRandomColor()
            self.startAnimateViewWithShadow()
        }
    }
    
    func chooseRandomColor() -> CGColor {
        let color = Int.random(in: 0...colorArray.count-1)
        return colorArray[color]
    }
    
    func addDepthToBottomContainerView() {
        bottomContainerView.layer.shadowOpacity = 1.0
        bottomContainerView.layer.shadowColor = UIColor.black.cgColor
        bottomContainerView.layer.shadowRadius = 10
    }
    
}
