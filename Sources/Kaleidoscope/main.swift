import Foundation
import LLVM

extension String: Error {}

typealias KSMainFunction = @convention(c) () -> Void

do {
    guard CommandLine.arguments.count > 1 else {
        throw "usage: kaleidoscope <file>"
    }

    let path = URL(fileURLWithPath: CommandLine.arguments[1])
    let input = try String(contentsOf: path)
    let toks = Lexer(input: input).lex()
    let file = try Parser(tokens: toks).parseFile()
    let irGen = IRGenerator(file: file)
    try irGen.emit()
    try irGen.module.verify()
    let llPath = path.deletingPathExtension().appendingPathExtension("ll")
    if FileManager.default.fileExists(atPath: llPath.path) {
        try FileManager.default.removeItem(at: llPath)
    }
    FileManager.default.createFile(atPath: llPath.path, contents: nil)
    try irGen.module.print(to: llPath.path)
    print("Successfully wrote LLVM IR to \(llPath.lastPathComponent)")


    let objPath = path.deletingPathExtension().appendingPathExtension("o")
    if FileManager.default.fileExists(atPath: objPath.path) {
        try FileManager.default.removeItem(at: objPath)
    }

    let targetMachine = try TargetMachine()
    try targetMachine.emitToFile(module: irGen.module,
                                 type: .object,
                                 path: objPath.path)
    print("Successfully wrote binary object file to \(objPath.lastPathComponent)")

} catch {
    print("error: \(error)")
    exit(-1)
}
