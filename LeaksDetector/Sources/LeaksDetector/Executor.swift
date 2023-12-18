//
//  Executor.swift
//
//
//  Created by Hoang Anh Tuan on 30/09/2023.
//

import Foundation
import ShellOut
import ArgumentParser

protocol Executor {
  func simulateUI() throws
  func generateMemgraph(for processName: String) throws
  func getMemgraphPath() -> String
}

class DefaultExecutor: Executor {
  let memgraphPath: String = "~/Desktop/Leaks.memgraph"

  fileprivate init() { }

  func simulateUI() throws {
    fatalError("Need to override this func")
  }

  func generateMemgraph(for processName: String) throws {
    try shellOut(to: "leaks \(processName) --outputGraph=\(memgraphPath)")
  }

  func getMemgraphPath() -> String {
    return memgraphPath
  }
}

final class MaestroExecutor: DefaultExecutor {

  /// Maestro needs a flow.yaml to start simulating UI
  private let flowPath: String

  init(flowPath: String) {
    self.flowPath = flowPath
    super.init()
  }

  override func simulateUI() throws {
    try shellOut(to: "maestro test \(flowPath)")
  }
}

final class FileExecutor: DefaultExecutor {

  let fm = FileManager.default
  let memgraphsFolderPath: String = "/Diagnostics/"
  var memgraphs: [String] = []
  var memgraphCount = 0

  override init() {
    super.init()
    let pathToRoot = #file.split(separator: "/").map({String($0)}).dropLast(4).reduce("", { $0 + "/" + $1 })
    let pathToDiagnostics = pathToRoot + memgraphsFolderPath
    let items = try! fm.contentsOfDirectory(atPath: pathToDiagnostics)

    for item in items {
      print("Found \(item)")
      guard item.contains(".memgraph") else { continue }
      memgraphs.append(pathToDiagnostics + item)
    }
  }

  func nextMemgraph() {
    memgraphCount += 1
    if memgraphs.count <= memgraphCount {
      memgraphCount = 0
    }
  }

  override func getMemgraphPath() -> String {
    return memgraphs[memgraphCount]
  }
}
