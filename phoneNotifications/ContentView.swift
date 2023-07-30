import SwiftUI
import AVFoundation
import GameplayKit


struct ContentView: View {

    @State private var currentIndex = -1 //adds one before starting
    @State private var isShowingImage = false
    @State private var currentTime = Date()
    @State private var currentDate = Date()
    @State private var playSound = false
    
    //@State private var audioPlayer: AVAudioPlayer?
    var audioPlayer: AVAudioPlayer?
    
    @State var images = ["message1", "message2", "message3", "message4"] //the array can be edited based on the button selected
    
    @State var selectedCase = 5 //default case to display
    @State var showButtons = true //should buttons be displayed
    
    let timer = Timer.publish(every: 10, on: .main, in: .common).autoconnect()
    let timeDateTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            Image("lockscreen_background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)

            VStack {
                Text(currentDateFormatter.string(from: currentDate))
                    .foregroundColor(.white)
                    .font(.title)
                    //.position(x: 270, y: 50)
                    .padding(.top, 30)
                
                Text(currentTimeFormatter.string(from: currentTime))
                    .foregroundColor(.white)
                    .font(
                        .system(size: 100)
                        .weight(.heavy)
                    )
                    .bold()
                    //.position(x: 270, y: -130)
                
                Text(" ")
                    .position(x: 0, y: 0)
                
                
                ZStack{
                    Text("Notification center")
                        .foregroundColor(.white)
                        .font(.footnote)
                }
            
            }
            
            if showButtons { //arranges the buttons
                VStack{
                    Button("Demo", action: {
                        buttonTapped(10)
                    })
                    .padding()
                    .foregroundColor(.red)
                    .background(Color.black)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .controlSize(.large)
                    .padding()
                    
                    Button("Case 5", action: {
                        buttonTapped(5)
                    })
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.black)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .controlSize(.large)
                    .padding()
                    
                    Button("Case 6", action: {
                        buttonTapped(6)
                    })
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.black)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .controlSize(.large)
                    .padding()
                    
                    Button("Case 7", action: {
                        buttonTapped(7)
                    })
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.black)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .controlSize(.large)
                    .padding()
                    
                    Button("Case 8", action: {
                        buttonTapped(8)
                    })
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.black)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .controlSize(.large)
                    .padding()
                    
                }.padding(.top, 100)
            } else{
                Group{
                    if isShowingImage {
                        Image(images[currentIndex])
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 370, height: 70)
                            .position(x: 275, y: 300)
                            
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                                    self.hideImage()
                                }
                        }
                    }
                }
            }
            

        
    }
        .onAppear { //at the start of the program, wait seconds to display first notification
            DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
                self.showNextImage()
            }
        }
    }
    
    init() { //intializes the sound files
        if let soundURL = Bundle.main.url(forResource: "notification_sound", withExtension: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                audioPlayer?.prepareToPlay()
                //audioPlayer?.play()
            } catch {
                print("Error initializing AVAudioPlayer: \(error.localizedDescription)")
            }
        } else {
            print("Sound file not found.")
        }
    }

    func showNextImage() {
        isShowingImage = true
        
        if playSound{ //to ensure that the sound doesnt play before the break loop
            audioPlayer?.play() //play the sound everytime image is shown
        }
        
        currentIndex += 1

        if currentIndex < images.count{
            let randomNum = Double(arc4random_uniform(11)) + 30// Generates a random number between 0 and 10 and adds to 30 [range: 30-40 seconds]
            DispatchQueue.main.asyncAfter(deadline: .now() + randomNum) {
                self.showNextImage()
            }
        }else{
            currentIndex = 0
            isShowingImage = false
            playSound = false
        }
        
    }
    
    //keeps track of which button has been selected
    private func buttonTapped(_ buttonNumber: Int) {
        showButtons = false
        playSound = true //allow playing sound only when button is tapped
        
        switch buttonNumber{ //modifies the images array to have the right nottification based on the case button
            case 5:
                images = ["HDD 9", "HDD 10", "HDD 11", "HDD 12"]
            case 6:
                images = ["HDD 13", "HDD 14", "HDD 15", "HDD 16"]
            case 7:
                images = ["HUD 9", "HUD 10", "HUD 11", "HUD 12"]
            case 8:
                images = ["HUD 13", "HUD 14", "HUD 15", "HUD 16"]
            default:
                images = ["message2", "message2", "message2", "message2"]
               
        }
        
    }
    
    let currentTimeFormatter: DateFormatter = { //format time to current time
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm"
        return formatter
    }()
    
    let currentDateFormatter: DateFormatter = { //current date
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd"
        return formatter
    }()


    func hideImage() {
        isShowingImage = false
    }
    

}

struct ContentView_Previews: PreviewProvider { //used to preview content in xcode
    static var previews: some View {
        ContentView()
    }
}
