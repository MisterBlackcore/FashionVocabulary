import UIKit

class ShowWordVC: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var englishWordLabel: UILabel!
    @IBOutlet weak var belarusianWordLabel: UILabel!
    @IBOutlet weak var belarusianDefinitionLabel: UILabel!
    @IBOutlet weak var buttonAndLabelContainerView: UIView!
    
    var word:Word?
    var pulseRepeatsInTimer = Timer()
    var pulseCreated = false
    var wordIndex:Int?
    
    let space = " "
    
    //MARK: - Main Functions
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        customizeLabel()
        fillInLabels()
        if pulseCreated == false {
            repeatPulseIn(time: 3)
            pulseCreated = true
        }
    }
    
    //MARK: - IBActions
    
    @IBAction func backButtonIsPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editButtonIsPressed(_ sender: UIButton) {
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "CreateNewWordViewController") as? CreateNewWordViewController {
            controller.modalPresentationStyle = .fullScreen
            controller.word = self.word
            controller.editModeIsActivated = true
            controller.wordIndex = wordIndex
            self.present(controller,animated: true)
        }
    }
    
    
    @IBAction func showImageAndInfo() {
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "ImageDefinitionAdditionalVC") as? ImageDefinitionAdditionalVC {
            controller.word = self.word
            self.present(controller,animated: true)
        }
    }
    
    //MARK: - Flow Functions
    
    func fillInLabels() {
        if let englishWord = word?.englishWord {
            englishWordLabel.text = space + englishWord + space
        }
        belarusianWordLabel.text = word?.belarusianWord
        belarusianDefinitionLabel.text = word?.belarusianDefinition
    }
    
    func customizeLabel() {
        englishWordLabel.layer.cornerRadius = 5
        englishWordLabel.layer.borderWidth = 1
        englishWordLabel.layer.borderColor = UIColor.white.cgColor
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(showImageAndInfo))
        englishWordLabel.isUserInteractionEnabled = true
        englishWordLabel.addGestureRecognizer(tap)
    }
    
    func addPulsesUnderLabel() {
        let pulse = PulsingAnimation(numberOfPulses: 1, radius: 500, position: englishWordLabel.center)
        buttonAndLabelContainerView.layer.masksToBounds = true
        pulse.masksToBounds = true
        pulse.animationDuration = 3
        pulse.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        buttonAndLabelContainerView.layer.addSublayer(pulse)
    }
    
    func repeatPulseIn(time: Double) {
        pulseRepeatsInTimer = Timer.scheduledTimer(withTimeInterval: time, repeats: true, block: { (_) in
            self.addPulsesUnderLabel()
        })
    }
    
}
