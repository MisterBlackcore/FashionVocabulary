import Foundation

class FilesManager: NSObject {
    static let shared = FilesManager()
    private override init() {}
    
    func saveData(data: Data, completion: (()->())?) {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/words.dat"
        
        if !FileManager.default.fileExists(atPath: documentsPath) {
            FileManager.default.createFile(atPath: documentsPath,
                                           contents: nil,
                                           attributes: nil)
        } else {
            do {
                try FileManager.default.removeItem(atPath: documentsPath)
                FileManager.default.createFile(atPath: documentsPath,
                                               contents: nil,
                                               attributes: nil)
            } catch let error as NSError {
                print("File replacing failed: \(error)")
            }
        }
        
        let file: FileHandle? = FileHandle(forWritingAtPath: documentsPath)
        if file != nil {
            file?.write(data)
            file?.closeFile()
            print("Data saved to file")
            if let completion = completion {
                completion()
            }
        } else {
            print("Ooops! Something went wrong!")
        }
    }
    
    func loadData() -> Data? {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/words.dat"
        
        let file: FileHandle? = FileHandle(forReadingAtPath: documentsPath)
        if file != nil {
            let data = file?.readDataToEndOfFile()
            file?.closeFile()
            print("Data loaded from file")
            return data
        }
        else {
            print("Ooops! Something went wrong!")
            return nil
        }
    }
}
