//
//  RokuApp.swift
//  MyRemote
//
//  Created by Alex DeMeo on 7/8/20.
//  Copyright © 2020 Alex DeMeo. All rights reserved.
//

import SwiftUI

struct RokuApp {
    let id: String
    let type: String
    let version: String
    let name: String
    
    var view: some View {
        let imgData = RokuApp.net(url: "\(AppDelegate.settings().rokuBaseURL)/query/icon/\(self.id)", method: "GET")
        if let resp = imgData.1 {
            if resp.statusCode == 200 {
                return AnyView(Image(nsImage: NSImage(data: imgData.0!)!)
                    .renderingMode(.original)
                    .resizable()
                    .scaledToFit()
                    .frame(width: Constants.CELL_WIDTH, height: Constants.CELL_HEIGHT)
                    .scaleEffect(2))
            } else {
                return AnyView(Text(self.name))
            }
        }
        return AnyView(Text("ERROR"))
    }
    
    init(line: String) {
        let parts = line.replacingOccurrences(of: "\"", with: "").split(separator: " ")
        self.id = String(parts[1].split(separator: "=")[1])
        self.type = String(parts[2].split(separator: "=")[1])
        self.version = String(parts[3].split(separator: "=")[1].split(separator: ">")[0])
        var name = line
        name.removeSubrange(name.startIndex...name.firstIndex(of: ">")!)
        name.removeSubrange(name.firstIndex(of: "<")!..<name.endIndex)
        self.name = String(name)
    }
    
    private static func extractLines(info: String) -> [RokuApp] {
        return info.matches(for: "<app.*<\\/app>").map({
            RokuApp(line: $0)
        })
    }
    
    static func getApps() -> [RokuApp] {
        let ret = net(url: "\(AppDelegate.settings().rokuBaseURL)/query/apps", method: "GET")
        let str = String(data: ret.0!, encoding: .utf8)
        return RokuApp.extractLines(info: str!)
    }
    
    private static func net(url: String, method: String) -> (Data?, HTTPURLResponse?, Error?) {
        let s = DispatchSemaphore(value: 0)
        var req = URLRequest(url: URL(string: url)!)
        req.httpMethod = method
        var result: (Data?, HTTPURLResponse?, Error?) = (nil, nil, nil)
        let task = URLSession.shared.dataTask(with: req) { data, response, error in
            result = (data, response as? HTTPURLResponse, error)
            s.signal()
        }
        task.resume()
        s.wait()
        return result
    }
}

extension String {
    func matches(for regex: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: self, range: NSRange(self.startIndex..., in: self))
            return results.map {
                String(self[Range($0.range, in: self)!])
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
}


struct RokuApp_Previews: PreviewProvider {
    static var previews: some View {
        ComponentRokuDevices(buttons: RemoteButton.getRokuButtons())
//        HStack {
//            ForEach(RemoteButton.getRokuButtons()) { btn in
//                HStack {
//                    Button(action: btn.exec) {
//                        btn.associatedApp!.view
//                    }
//                }
//            }
//        }
    }
}
