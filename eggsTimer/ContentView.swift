//
//  ContentView.swift
//  eggsTimer
//
//  Created by Richard Urunuela on 05/05/2020.
//  Copyright © 2020 Richard Urunuela. All rights reserved.
//

import SwiftUI
class EggsTimer: ObservableObject{
    var toRun = false
     @Published var cpt:Int = 210
    var timer:Timer?
    init() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil,  repeats: true)
        timer?.tolerance = 0.05
    }
    var datePred:Double = 0
    var jig = -1
    @objc func fireTimer(timer: Timer) {
        
        guard toRun else {
           
            return
        }
        guard cpt > 0 else {
            return
        }
        //jig = jig < 0 ? 0:0
        let deltaTime = NSDate().timeIntervalSince1970 - datePred
        jig  += (10 - Int(deltaTime * 10.0 ))
            print(" delta Time \(deltaTime) \(jig)")
            print(" compteur :  \(cpt)")
            cpt -= 1
        self.datePred = NSDate().timeIntervalSince1970
        
    }
   func start() {
    print("start \(toRun) \(timer?.isValid)")
        guard !toRun else { return  }
        toRun  = true
        timer?.fire()
        self.datePred = NSDate().timeIntervalSince1970
    }
    func pause() {
        print("pause \(toRun) \(timer?.isValid)")
        guard toRun else {return  }
        toRun  = false
        
    }
    func reset(){
        self.pause()
        //self.timer!.invalidate()
      
        self.cpt = 210
         
    }
    
}


struct ContentView: View {
    @ObservedObject var eggsTimer = EggsTimer()
    var greyColor = Color(.displayP3, red: 0.99, green:  0.99, blue: 0.99,opacity: 1)
    
    var body: some View {
        NavigationView {
            VStack(){
                Spacer()
                Text("\(eggsTimer.cpt)").font(.system(size: 60))
                Spacer()
                HStack(){
                    Button(action: {
                        self.eggsTimer.cpt -= 10
                    }) {
                        Text ("-10")
                    }.padding(8)
                    Spacer()
                    Button(action: {
                       
                        self.eggsTimer.reset()
                    }) {
                        Text ("Reset")
                    }.padding(8)
                    Spacer()
                    Button(action: {
                        self.eggsTimer.cpt += 10
                    }) {
                        Text ("+10")
                    }.padding(8)
                }.frame( height: 80).background(greyColor)
                
                
            }
            .navigationBarTitle(Text("Eggs Timer"),displayMode: .inline).edgesIgnoringSafeArea(.bottom)
            .navigationBarItems(leading:
                Button(action: {
                    self.eggsTimer.pause()
                }) {
                    Image(systemName: "pause.fill").scaleEffect(2)
                }
                , trailing: Button(action: {
                    self.eggsTimer.start()
                }) {
                    Image(systemName: "play.fill").scaleEffect(2)
            } )
            
            
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
