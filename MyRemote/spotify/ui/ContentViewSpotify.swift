//
//  ContentViewSpotify.swift
//  MyRemote
//
//  Created by Alex DeMeo on 10/29/20.
//  Copyright © 2020 Alex DeMeo. All rights reserved.
//

import SwiftUI

struct ContentViewSpotify: View {
    let auth = SpotifyAuth.shared
    var header: [String: String]? {
        if let accessToken = auth.accessToken {
            return [
                "Accept": "application/json",
                "Content-Type": "application/json",
                "Authorization": "Bearer \(accessToken)",
            ]
        } else {
            return nil
        }
    }
    @State var isPlaying: Bool? = nil
    @State var albumImgURl: String? = nil
    @State var songName: String? = nil
    @State var artistName: String? = nil
    @State var albumName: String? = nil
    
    func refreshPlaybackState() {
        AppDelegate.instance.netAsync(url: "\(SPOTIFY_URL_API)/v1/me/player", method: "GET", header: header, body: nil, callback: {
            data, response, error in
            guard let data = data else {
//                if response?.statusCode == 204 {
//                    self.play()
//                }
                print("refreshPlaybackState() no data")
                return
            }
            do {
                let d = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                if let playing = d["is_playing"] as? Bool {
                    print("is_playing = \(playing)")
                    self.isPlaying = playing
                }
                if let song = d["item"] as? [String: Any] {
                    let songName = song["name"] as! String
                    self.songName = songName
                    guard let artists = song["artists"] as? [[String: Any]] else {
                        return
                    }
                    let artistName = artists[0]["name"] as! String
                    self.artistName = artistName
                    guard let album = song["album"] as? [String: Any] else {
                        return
                    }
                    guard let albumName = album["name"] as? String else {
                        return
                    }
                    self.albumName = albumName
                    guard let images = album["images"] as? [[String: Any]] else {
                        return
                    }
                    print("\(songName) by \(artistName) from \(albumName)")
                    guard let img = images.max(by: {
                        i, j in
                        (i["width"] as! Int) < (j["width"] as! Int)}) else {
                        return
                    }

                    if let url = img["url"] as? String {
                        print("imgUrl=\(url)")
                        self.albumImgURl = url
                    }
                }
            } catch {
                print("Error playPause()")
            }
            
        })
    }
    
    func play() {
        AppDelegate.instance.netAsync(url: "\(SPOTIFY_URL_API)/v1/me/player/play", method: "PUT", header: header, body: nil, callback: {
            data, response, error in
            self.refreshPlaybackState()
        })
    }
    
    func pause() {
        AppDelegate.instance.netAsync(url: "\(SPOTIFY_URL_API)/v1/me/player/pause", method: "PUT", header: header, body: nil, callback: {
            data, response, error in
            if response?.statusCode == 204 {
                self.isPlaying = false
            }
            self.refreshPlaybackState()
        })
    }
    
    func skip(backward: Bool = false) {
        let dir = backward ? "previous" : "next"
        AppDelegate.instance.netAsync(url: "\(SPOTIFY_URL_API)/v1/me/player/\(dir)", method: "POST", header: header, body: nil, callback: {
            data, response, error in
            self.refreshPlaybackState()
        })
    }
    
    var body: some View {
        // currently same error text if reply fails or reply has bad statusCode. Should probably separate these
        VStack(alignment: .center, spacing: Constants.SPACING_VERTICAL, content: {
            if let a = self.albumImgURl, let (data, _, _) = AppDelegate.instance.netSync(url: a, method: "GET") {
                AnyView(VStack {
                    Image(nsImage: NSImage(data: data!)!).resizable().aspectRatio(contentMode: .fit)
                    Text(self.songName!).multilineTextAlignment(.center)
                    Text(self.artistName!).fontWeight(.light).multilineTextAlignment(.center)
                    Text(self.albumName!).fontWeight(.ultraLight).multilineTextAlignment(.center)
                })
            }
            HStack(spacing: Constants.REMOTE_CENTER_GAP_WIDTH) {
                Button(action: {
                    self.skip(backward: true)
                }) { Text(Buttons.Spotify.REWIND.symbol) }
                if self.isPlaying == true {
                    Button(action: self.pause) { Text(Buttons.Spotify.PAUSE.symbol) }
                } else {
                    Button(action: self.play) { Text(Buttons.Spotify.PLAY.symbol) }
                }
                Button(action: {
                        self.skip()
                }) { Text(Buttons.Spotify.FORWARD.symbol) }
            }.padding(.bottom)
            Button(action: self.refreshPlaybackState) {
                Text("↻")
            }
        })
    }
}

struct ContentViewSpotify_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewSpotify()
            .buttonStyle(BorderlessButtonStyle())
            .frame(width: 200, height: 200, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
    }
}
