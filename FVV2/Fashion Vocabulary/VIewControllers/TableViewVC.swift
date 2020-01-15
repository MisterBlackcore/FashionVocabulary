                                                                                      import UIKit
import AVFoundation

class TableViewVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addWordButton: UIButton!
    @IBOutlet weak var centerViewForActivityIndicator: UIView!
    
    var array: [[Word]]?
    
    var activityIndicator = UIActivityIndicatorView()
    
    private var backgroundMusicPlayer: AVAudioPlayer?
    
    //MARK: - Main Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SingleTon.shared.loadVocabulary()
        centerViewForActivityIndicator.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
        playBackgroundMusic()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    //MARK: - IBActions
    
    @IBAction func addWordButtonIsPressed(_ sender: UIButton) {
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "CreateNewWordViewController") as? CreateNewWordViewController {
            controller.modalPresentationStyle = .fullScreen
            self.present(controller,animated: true)
        }
    }
    
    //MARK: - Flow functions
    
    func playBackgroundMusic() {
        let backgroundMusic = URL(fileURLWithPath: Bundle.main.path(forResource: "MainOST", ofType: "mp3")!) //????????!
        
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
        try! AVAudioSession.sharedInstance().setActive(true)
        
        try! backgroundMusicPlayer = AVAudioPlayer(contentsOf: backgroundMusic)
        backgroundMusicPlayer!.play()
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
    
    @objc func loadList(notification: NSNotification){
        self.tableView.reloadData()
    }
    
}

    //MARK: - Extensions

extension TableViewVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SingleTon.shared.sectionName.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if SingleTon.shared.wordsArrayInAlphabeticalOrder[section].count != 0 {
            return SingleTon.shared.sectionName[section]
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Remove") { (action, view, completion) in
            DispatchQueue.main.async {
                self.showActivityIndicator()
            }
            DispatchQueue.global(qos: .default).async {
                SingleTon.shared.deleteWordFromVocabulary(word: SingleTon.shared.getWords()[indexPath.section][indexPath.row], indexPath: indexPath.row)
                
                DispatchQueue.main.async {
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                    self.stopActivityIndicator()
                }
            }
        }
        
        action.backgroundColor = .red
        return action
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SingleTon.shared.getWordsCounted(index: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WordTableViewCell", for: indexPath) as? WordTableViewCell else {
            return UITableViewCell()
        }
        cell.configureCell(word: SingleTon.shared.getWords()[indexPath.section][indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "ShowWordVC") as? ShowWordVC {
            controller.word = SingleTon.shared.wordsArrayInAlphabeticalOrder[indexPath.section][indexPath.row]
            controller.wordIndex = indexPath.row
            self.present(controller, animated: true)
        }
    }
}

