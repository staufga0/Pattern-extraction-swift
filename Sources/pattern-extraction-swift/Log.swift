import Foundation

func generateCurrentTimeStamp () -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm:ss"
    return (formatter.string(from: Date()) as NSString) as String
}

struct Log: TextOutputStream {

    func write(_ string: String) {
        let string2 = ("[" + generateCurrentTimeStamp() + "] ") + string
        let log = URL(fileURLWithPath: "./log.txt")
        if let handle = try? FileHandle(forWritingTo: log) {
            handle.seekToEndOfFile()
            handle.write(string2.data(using: .utf8)!)
            handle.closeFile()
        } else {
            try? string.data(using: .utf8)?.write(to: log)
        }
    }
}



var logger = Log()
