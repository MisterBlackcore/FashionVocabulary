import UIKit

class CreateNewWordViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var englishWordTextField: UITextField!
    @IBOutlet weak var belarusianWordTextField: UITextField!
    @IBOutlet weak var englishDefinitionTextView: UITextView!
    @IBOutlet weak var belarusianDefinitionTextView: UITextView!
    @IBOutlet weak var addedImageView: UIImageView!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var bottomBelWordDefinitionTextViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var centerViewForActivityIndicator: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var loadingView = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var editModeIsActivated = false
    var word:Word?
    var wordIndex:Int?
    
    var scrollOffset : CGFloat = 0
    var distance : CGFloat = 0
    
    let imagePicker = UIImagePickerController()
    
    //MARK: - Main Functions
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if editModeIsActivated == true {
            editModeIsActive()
            addImageButton.setTitle("", for: .normal)
        }
        self.imagePicker.delegate = self
        centerViewForActivityIndicator.isHidden = true
        customizeTextFields()
        customizeAddedImageView()
        setUpKeyboardInteraction()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    

    
    //MARK: - IBActions
    
    @IBAction func backButtonIsPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonIsPressed(_ sender: UIButton) {
        keyboardDissapears()
        guard let englishWord = self.englishWordTextField.text,
            !englishWord.isEmpty,
            let wordImage = addedImageView.image,
            let belarusianWord = self.belarusianWordTextField.text,
            !belarusianWord.isEmpty,
            let englishDefinition = self.englishDefinitionTextView.text,
            !englishDefinition.isEmpty,
            let belarusianDefinition = self.belarusianDefinitionTextView.text,
            !belarusianDefinition.isEmpty else {
                createAndShowAlert()
                return
            }
        if editModeIsActivated == true {
            if let wordToDelete = word, let wordIndex = wordIndex {
                SingleTon.shared.deleteWordBeforeEditing(word: wordToDelete, indexPath: wordIndex)
            }
        }
        showActivityIndicator()
        DispatchQueue.global(qos: .default).async {
            SingleTon.shared.addNewWordToVocabulary(word: Word(englishWord: englishWord, belarusianWord: belarusianWord, englishDefinition: englishDefinition,belarusianDefinition: belarusianDefinition, wordImage: wordImage))
            DispatchQueue.main.async {
                self.createAndShowDoneProgressAlert()
            }
        }
    }
    
    @IBAction func addImageButtnIsPressed(_ sender: UIButton) {
        pick()
    }
    
    @IBAction func hideKeyboard() {
        keyboardDissapears()
    }
    
    //MARK: - Flow Functions
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            var safeArea = self.view.frame
            safeArea.size.height += scrollView.contentOffset.y
            safeArea.size.height -= keyboardSize.height + (UIScreen.main.bounds.height*0.04)
            
            let activeField: UIView? = [englishDefinitionTextView, belarusianDefinitionTextView].first { $0.isFirstResponder }
            if let activeField = activeField {
                if safeArea.contains(CGPoint(x: 0, y: activeField.frame.maxY)) {
                    print("No need to Scroll")
                    return
                } else {
                    distance = activeField.frame.maxY - safeArea.size.height
                    scrollOffset = scrollView.contentOffset.y
                    self.scrollView.setContentOffset(CGPoint(x: 0, y: scrollOffset + distance), animated: true)
                }
            }
            scrollView.isScrollEnabled = false
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if distance == 0 {
            return
        }
        self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        scrollOffset = 0
        distance = 0
        scrollView.isScrollEnabled = true
    }
    
    func pick() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            self.imagePicker.sourceType = .photoLibrary
            present(self.imagePicker, animated: true, completion: nil)
        }
    }
    
    func keyboardDissapears() {
        englishWordTextField.resignFirstResponder()
        belarusianWordTextField.resignFirstResponder()
        englishDefinitionTextView.resignFirstResponder()
        belarusianDefinitionTextView.resignFirstResponder()
    }
    
    func editModeIsActive() {
        addedImageView.image = word?.wordImage
        englishWordTextField.text = word?.englishWord
        belarusianWordTextField.text = word?.belarusianWord
        englishDefinitionTextView.text = word?.englishDefinition
        belarusianDefinitionTextView.text = word?.belarusianDefinition
    }
    
    func createAndShowAlert() {
        self.showAlertController(title: "WARNING", message: "Fill in all fields") { (_) in
            if self.englishWordTextField.text == "" {
                self.englishWordTextField.layer.borderColor = UIColor.red.cgColor
            } else {
                self.englishWordTextField.layer.borderColor = UIColor.black.cgColor
            }
            if self.belarusianWordTextField.text == "" {
                self.belarusianWordTextField.layer.borderColor = UIColor.red.cgColor
            } else {
                self.belarusianWordTextField.layer.borderColor = UIColor.black.cgColor
            }
            if self.englishDefinitionTextView.text == "" {
                self.englishDefinitionTextView.layer.borderColor = UIColor.red.cgColor
            } else {
                self.englishDefinitionTextView.layer.borderColor = UIColor.black.cgColor
            }
            if self.belarusianDefinitionTextView.text == "" {
                self.belarusianDefinitionTextView.layer.borderColor = UIColor.red.cgColor
            } else {
                self.belarusianDefinitionTextView.layer.borderColor = UIColor.black.cgColor
            }
            if self.addedImageView.image == nil {
                self.addedImageView.layer.borderColor = UIColor.red.cgColor
            } else {
                self.addedImageView.layer.borderColor = UIColor.black.cgColor
            }
        }
    }
    
    func createAndShowDoneProgressAlert() {
        stopActivityIndicator()
        let alertController = UIAlertController(title: "СПАСИБО", message: "Ваше слово добавлено в словарь", preferredStyle: .alert)
        let actionDone = UIAlertAction(title: "OK", style: .default) { (_) in
            self.englishWordTextField.layer.borderColor = UIColor.black.cgColor
            self.belarusianWordTextField.layer.borderColor = UIColor.black.cgColor
            self.englishDefinitionTextView.layer.borderColor = UIColor.black.cgColor
            self.belarusianDefinitionTextView.layer.borderColor = UIColor.black.cgColor
            self.englishWordTextField.text = ""
            self.belarusianWordTextField.text = ""
            self.englishDefinitionTextView.text = ""
            self.belarusianDefinitionTextView.text = ""
            self.addedImageView.image = nil
            if self.editModeIsActivated == true {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
                self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
            
        }
        alertController.addAction(actionDone)
        self.present(alertController,animated: true,completion: nil)
    }
    
    func customizeTextFields() {
        self.englishWordTextField.layer.borderColor = UIColor.black.cgColor
        self.englishWordTextField.layer.borderWidth = 1.0
        self.englishWordTextField.layer.cornerRadius = 10
        self.belarusianWordTextField.layer.borderColor = UIColor.black.cgColor
        self.belarusianWordTextField.layer.borderWidth = 1.0
        self.belarusianWordTextField.layer.cornerRadius = 10
        self.englishDefinitionTextView.layer.borderColor = UIColor.black.cgColor
        self.englishDefinitionTextView.layer.borderWidth = 1.0
        self.englishDefinitionTextView.layer.cornerRadius = 10
        self.belarusianDefinitionTextView.layer.borderColor = UIColor.black.cgColor
        self.belarusianDefinitionTextView.layer.borderWidth = 1.0
        self.belarusianDefinitionTextView.layer.cornerRadius = 10
    }
    
    func customizeAddedImageView() {
        addedImageView.backgroundColor = .black
        addedImageView.layer.cornerRadius = addedImageView.frame.size.width/2
        addedImageView.layer.borderWidth = 5.0
        addedImageView.layer.borderColor = UIColor.black.cgColor
    }
    
    func showActivityIndicator() {
        centerViewForActivityIndicator.backgroundColor = .black
        centerViewForActivityIndicator.alpha  = 0.7
        centerViewForActivityIndicator.layer.cornerRadius = 10
        centerViewForActivityIndicator.isHidden = false
        
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        activityIndicator.center = CGPoint(x: centerViewForActivityIndicator.frame.size.width/2, y: centerViewForActivityIndicator.frame.size.height/2)
        
        centerViewForActivityIndicator.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
        activityIndicator.removeFromSuperview()
        centerViewForActivityIndicator.isHidden = true
    }
    
    func setUpKeyboardInteraction() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
}

    //MARK: - Extensions

extension CreateNewWordViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            addedImageView.image = pickedImage
            addImageButton.setTitle("", for: .normal)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
