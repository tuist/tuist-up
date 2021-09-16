import Foundation
import TSCBasic
import ColorizeSwift

struct Command: Decodable {
    let name: String;
    let meet: [String];
    let isMet: [String];
}

func fail(message: CustomStringConvertible) {
    FileHandle.standardError.write("Error: \(message.description)".red().bold().data(using: .utf8)!)
}

func section(message: CustomStringConvertible) {
    print("\n\(message.description)\n=====".cyan().bold())
}

func subsection(message: CustomStringConvertible) {
    print(message.description.lightGreen())
}

let currentWorkingDirectory = AbsolutePath(FileManager.default.currentDirectoryPath);
let manifestPath = currentWorkingDirectory.appending(component: "up.json");

if !FileManager.default.fileExists(atPath: manifestPath.pathString) {
    fail(message: "Couldn't find the manifest file at path \(manifestPath.pathString).")
}

let data = try Data(contentsOf: manifestPath.asURL)
let jsonDecoder = JSONDecoder()
jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase;
let commands = try jsonDecoder.decode([Command].self, from: data)
var anyFailure: Bool = false

do {
    try commands.forEach { command in
        section(message: "\(command.name)")
        
        subsection(message: "Checking if it's met...")
        let isMetProcess = TSCBasic.Process.init(arguments: command.isMet)
        try isMetProcess.launch()
        let isMetResult = try isMetProcess.waitUntilExit()
        switch isMetResult.exitStatus {
        case let .terminated(code):
            if code == 0 {
                return;
            }
        default:
            return;
        }
                
        let result = try TSCBasic.Process.popen(arguments: command.meet)
        switch result.exitStatus {
        case let .terminated(code):
            if code != 0 {
                anyFailure = true
                let stdout = try result.utf8Output()
                let stderr = try result.utf8stderrOutput()
                if !stdout.isEmpty { fail(message: stdout) }
                if !stderr.isEmpty { fail(message: stderr) }
            } else {
                print("Meet successfully executed".lightGreen().bold())
            }
            return;
        default:
            return
        }
        
    }
} catch {
    fail(message: "\(error)")
    exit(1)
}

if anyFailure {
    exit(1)
}
