//
//  ViewModel.swift
//  TOM
//
//  Created by Tomasz Kubicki on 05/10/2023.
//

import Foundation
import RegexBuilder

class ViewModel: ObservableObject {
    @Published var registers = [String: Int]()
    @Published var stack = [Int]()
    @Published var zx = 0
    
    @Published var log = ""
    private var jump = false
    
    private var lineNumber = 0
    
    /// - Note: Resets all registers to default value
    func reset() {
        registers = [
            "EAX": 0,
            "EBX": 0,
            "ECX": 0,
            "EDX": 0,
            "ESI": 0,
            "EDI": 0,
            "EBP": 0,
            "EIP": 75654 * 32 - 32 * lineNumber,
            "ESP": 0
        ]
        
        zx = 0
        
        log = "--- Resetting all registers to their defaults… ---"
        lineNumber = 0
        stack.removeAll()
    }
    
    /// - Parameter code: Assembly code line as String
    /// - Parameter limit: Number of lines to be executed
    func run(code: String, limit: Int) {
        reset()
        
        guard code.isEmpty == false else { return }
        let mainRegex = Regex { "MAIN:"}
        let movRegex = Regex { matchPrefix(); "MOV"; matchSpace(); matchRegister(); ", "; matchRegister() }
        let movDRegex = Regex { matchPrefix(); "MOV"; matchSpace(); matchDigits(); ", "; matchRegister() }
        let addRegex = Regex { matchPrefix(); "ADD"; matchSpace(); matchRegister(); ", "; matchRegister() }
        let addDRegex = Regex { matchPrefix(); "ADD"; matchSpace(); matchDigits(); ", "; matchRegister() }
        let subRegex = Regex { matchPrefix(); "SUB"; matchSpace(); matchRegister(); ", "; matchRegister() }
        let subDRegex = Regex { matchPrefix(); "SUB"; matchSpace(); matchDigits(); ", "; matchRegister() }
        let copyRegex = Regex { matchPrefix(); "COPY"; matchSpace(); matchRegister(); ", "; matchRegister() }
        let andRegex = Regex { matchPrefix(); "AND"; matchSpace(); matchRegister(); ", "; matchRegister() }
        let orRegex = Regex { matchPrefix(); "OR"; matchSpace(); matchRegister(); ", "; matchRegister() }
        let cmpRegex = Regex { matchPrefix(); "CMP"; matchSpace(); matchRegister(); ", "; matchRegister() }
        let cmpDRegex = Regex { matchPrefix(); "CMP"; matchSpace(); matchDigits(); ", "; matchRegister() }
        let jeqRegex = Regex { matchPrefix(); "JEQ"; matchSpace(); matchDigits() }
        let jneqRegex = Regex { matchPrefix(); "JNEQ"; matchSpace(); matchDigits() }
        let jmpRegex = Regex { matchPrefix(); "JMP"; matchSpace(); matchDigits() }
        let incRegex = Regex { matchPrefix(); "INC"; matchSpace(); matchRegister() }
        let decRegex = Regex { matchPrefix(); "DEC"; matchSpace(); matchRegister() }
        let mulRegex = Regex { matchPrefix(); "MUL"; matchSpace(); matchRegister(); ", "; matchRegister() }
        let pushRegex = Regex { matchPrefix(); "PUSH"; matchSpace(); matchRegister() }
        let popRegex = Regex { matchPrefix(); "POP"; matchSpace(); matchRegister() }
        let retRegex = Regex { matchPrefix(); "RET" }
        
        let lines = code.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)
        var commandsUsed = 0
        
        while lineNumber < limit {
            
            var line = lines[lineNumber]
            
            if line.starts(with: "#") {
                lineNumber += 1
                continue
            } else {
                line = line.uppercased()
            }
            if let _ = line.wholeMatch(of: mainRegex) {
                main()
            } else if let match = line.wholeMatch(of: movRegex) {
                mov(source: match.output.3, destination: match.output.4)
            } else if let match = line.wholeMatch(of: movDRegex) {
                movD(value: match.output.3, destination: match.output.4)
            } else if let match = line.wholeMatch(of: addRegex) {
                add(source: match.output.3, destination: match.output.4)
            } else if let match = line.wholeMatch(of: addDRegex) {
                addD(source: match.output.3, destination: match.output.4)
            } else if let match = line.wholeMatch(of: subRegex) {
                sub(source: match.output.3, destination: match.output.4)
            } else if let match = line.wholeMatch(of: subDRegex) {
                subD(source: match.output.3, destination: match.output.4)
            } else if let match = line.wholeMatch(of: copyRegex) {
                copy(source: match.output.3, destination: match.output.4)
            } else if let match = line.wholeMatch(of: andRegex) {
                and(source: match.output.3, destination: match.output.4)
            } else if let match = line.wholeMatch(of: orRegex) {
                or(source: match.output.3, destination: match.output.4)
            } else if let match = line.wholeMatch(of: cmpRegex) {
                cmp(source: match.output.3, destination: match.output.4)
            } else if let match = line.wholeMatch(of: cmpDRegex) {
                cmpD(source: match.output.3, destination: match.output.4)
            } else if let match = line.wholeMatch(of: jeqRegex) {
                jeq(to: match.output.3)
            } else if let match = line.wholeMatch(of: jneqRegex) {
                jneq(to: match.output.3)
            } else if let match = line.wholeMatch(of: jmpRegex) {
                jmp(to: match.output.3)
            } else if let match = line.wholeMatch(of: incRegex) {
                inc(destination: match.output.3)
            } else if let match = line.wholeMatch(of: decRegex) {
                dec(destination: match.output.3)
            } else if let match = line.wholeMatch(of: mulRegex) {
                mul(source: match.output.3, destination: match.output.4)
            } else if let match = line.wholeMatch(of: pushRegex) {
                push(source: match.output.3)
            } else if let match = line.wholeMatch(of: popRegex) {
                pop(destination: match.output.3)
            } else if let _ = line.wholeMatch(of: retRegex) {
                ret()
            } else {
                addToLog("*** ERROR: Unknown command. Remember: minimum 1 space is required betwwen command and variable, comma with space required between variables ***")
                return
            }
            
            registers["EIP"] = 75654 * 32 - 32 * lineNumber
            
            commandsUsed += 1
            self.lineNumber += 1
            
            guard commandsUsed < 50_000 else {
                reset()
                addToLog("*** ERROR: Too many commands (check your code); exiting. ***")
                return
            }
        }
    }
    
    private func matchPrefix() -> TryCapture<(Substring, String)> {
        TryCapture {
            ZeroOrMore(.whitespace)
        } transform: { ch in
            String(" ")
        }
    }
    
    private func matchSpace() -> TryCapture<(Substring, String)> {
        TryCapture {
            OneOrMore(.whitespace)
        } transform: { ch in
            String(" ")
        }
    }
    
    private func matchDigits() -> TryCapture<(Substring, Int)> {
        TryCapture {
            OneOrMore(.digit)
        } transform: { number in
            Int(number)
        }
    }

    private func matchRegister() -> Capture<(Substring, String)> {
        Capture {
            "E"
            "A"..."S"
            "I"..."X"
        } transform: { match in
            String(match)
        }
    }

    private func addToLog(_ message: String) {
        log += "\nLine \(lineNumber + 1): \(message)"
    }

    private func clamp(register: String) {
        if registers[register, default: 0] < 0 {
            addToLog("*** WARNING: Line \(lineNumber + 1) has set \(register) to a value below 0. It has been clamped to 0")
            registers[register] = 0
        } else if registers[register, default: 0] > UInt32.max {
            addToLog("*** WARNING: Line \(lineNumber + 1) has set \(register) to a value above \(UInt32.max). It has been clamped to \(UInt32.max).")
            registers[register] = Int(UInt32.max)
        }
    }
    
    private func main() {
        registers["EBP"] = lineNumber
        addToLog("Setting EBP to a value \(lineNumber)")
    }
    
    private func mov(source: String, destination: String) {
        registers[destination, default: 0] = registers[source, default: 0]
        clamp(register: destination)
        addToLog("Moving value of \(source) into \(destination)")
    }
    
    private func movD(value: Int, destination: String) {
        registers[destination] = value
        clamp(register: destination)
        addToLog("Moving \(value) into \(destination)")
    }

    private func add(source: String, destination: String) {
        registers[destination, default: 0] += registers[source, default: 0]
        clamp(register: destination)
        addToLog("Adding \(source) to \(destination)")
    }
    
    private func addD(source: Int, destination: String) {
        registers[destination, default: 0] += source
        clamp(register: destination)
        addToLog("Adding \(source) to \(destination)")
    }

    private func sub(source: String, destination: String) {
        registers[destination, default: 0] -= registers[source, default: 0]
        clamp(register: destination)
        addToLog("Subtracting \(source) from \(destination)")
    }
    
    private func subD(source: Int, destination: String) {
        registers[destination, default: 0] -= source
        clamp(register: destination)
        addToLog("Subtracting \(source) from \(destination)")
    }

    private func copy(source: String, destination: String) {
        registers[destination, default: 0] = registers[source, default: 0]
        clamp(register: destination)
        addToLog("Copying \(source) to \(destination)")
    }

    private func and(source: String, destination: String) {
        registers[destination, default: 0] &= registers[source, default: 0]
        clamp(register: destination)
        addToLog("ANDing \(source) with \(destination)")
    }

    private func or(source: String, destination: String) {
        registers[destination, default: 0] |= registers[source, default: 0]
        clamp(register: destination)
        addToLog("ORing \(source) with \(destination)")
    }

    private func cmp(source: String, destination: String) {
        zx = registers[destination, default: 0] == registers[source, default: 0] ? 1 : 0
        clamp(register: destination)
        addToLog("Comparing \(source) to \(destination)")
    }
    
    private func cmpD(source: Int, destination: String) {
        zx = registers[destination, default: 0] == source ? 1 : 0
        clamp(register: destination)
        addToLog("Comparing \(source) to \(destination)")
    }

    private func jeq(to line: Int) {
        if zx == 1 {
            if line - 1 < 0 {
                addToLog("*** WARNING: execute JEQ command at line \(lineNumber)")
            } else {
                addToLog("ZX is 1 so jumping to line \(line)")
                lineNumber = line - 1
            }
        } else {
            addToLog("ZX is 0 so skipping jump to line \(line)")
        }
    }

    private func jneq(to line: Int) {
        if zx == 0 {
            if line - 1 < 0 {
                addToLog("*** WARNING: Couldn't execute JNEQ command at line \(lineNumber)")
            } else {
                addToLog("ZX is 0 so jumping to line \(line)")
                lineNumber = line - 1
            }
        } else {
            addToLog("ZX is 1 so skipping jump to line \(line)")
        }
    }

    private func jmp(to line: Int) {
        if line - 1 < 0 {
            addToLog("*** WARNING: Couldn't execute JMP command at line \(lineNumber)")
        } else {
            addToLog("Jumping to line \(line)")
            lineNumber = line - 1
        }
    }
    
    private func inc(destination: String) {
        registers[destination, default: 0] += 1
        clamp(register: destination)
        addToLog("Adding '1' to \(destination)")
    }
    
    private func dec(destination: String) {
        registers[destination, default: 0] -= 1
        clamp(register: destination)
        addToLog("Substracting '1' from \(destination)")
    }
    
    private func mul(source: String, destination: String) {
        registers[destination, default: 0] *= registers[source, default: 0]
        clamp(register: destination)
        addToLog("Multiplying \(destination) by \(source)")
    }
    
    private func push(source: String) {
        stack.append(registers[source, default: 0])
        addToLog("Pushing value of \(registers[source, default: 0]) from \(source) to the stack")
    }
    
    private func pop(destination: String) {
        if stack.count > 0 {
            registers[destination, default: 0] = stack.popLast() ?? 0
            addToLog("Popping \(registers[destination, default: 0]) from the stack to \(destination)")
        } else {
            addToLog("*** ERROR: Anauthorized attempt of memory access ***")
        }
    }
    
    func ebp() {
        addToLog("*** ERROR: Your stack has reached EIP pointer - this may result in unattended behaviour like overriding next instruction pointer and finally unwanted code execution - this happens when user's input isn't sanitized. This type of approach is often used by hackers to achieve their goal - It's just an example - to avoid such Error for now, readjust your stack size by moing Memory size slider at the left.")
    }
    
    func ret() {
        addToLog("Returnig value of EAX: \(registers["EAX"] ?? 0)")
    }
}
