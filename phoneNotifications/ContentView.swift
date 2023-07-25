import SwiftUI
import AVFoundation


struct ContentView: View {

    @State private var currentIndex = -1 //adds one before starting
    @State private var isShowingImage = false
    @State private var currentTime = Date()
    @State private var currentDate = Date()

    @State private var audioPlayer: AVAudioPlayer?
    let notificationSound = "notification_sound" // Name of the sound file
    
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
                    .position(x: 290, y: 50)
                
                Text(currentTimeFormatter.string(from: currentTime))
                    .foregroundColor(.white)
                    .font(
                        .system(size: 100)
                        .weight(.heavy)
                    )
                    .bold()
                    .position(x: 295, y: -130)
                
                Text(" ")
                    .position(x: 0, y: 0)
                
                
                ZStack{
                    Text("Notification center")
                        .foregroundColor(.white)
                        .font(.footnote)
                }
            
            }
            
            if showButtons {
                VStack{
                    Button("Case 5", action: {
                        buttonTapped(5)
                    })
                    .padding()
                    .background(Color.black)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .controlSize(.large)
                    .padding()
                    
                    Button("Case 6", action: {
                        buttonTapped(6)
                    })
                    .padding()
                    .background(Color.black)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .controlSize(.large)
                    .padding()
                    
                    Button("Case 7", action: {
                        buttonTapped(7)
                    })
                    .padding()
                    .background(Color.black)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .controlSize(.large)
                    .padding()
                    
                    Button("Case 8", action: {
                        buttonTapped(8)
                    })
                    .padding()
                    .background(Color.black)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .controlSize(.large)
                    .padding()
                }
            } else{
                Group{
                    if isShowingImage {
                        Image(images[currentIndex])
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 370, height: 70)
                            .position(x: 290, y: 300)
                            
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
            audioPlayer?.play()
            DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
                self.showNextImage()
            }
        }
    }
    
    init() {
            // Load the sound file
            if let soundURL = Bundle.main.url(forResource: "notification_sound", withExtension: "mp3") {
                do {
                    audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                    audioPlayer?.prepareToPlay()
                    print("load worked!")
                } catch {
                    print("Error loading sound file: \(error.localizedDescription)")
            }
        }
    }

    func showNextImage() {
        isShowingImage = true
        audioPlayer?.play() //play the sound everytime image is shown
        currentIndex += 1

        if currentIndex >= images.count {
            currentIndex = 0
            isShowingImage = false //end program after showing all the images in the current array
            showButtons = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 30) {
            self.showNextImage()
        }
    }
    
    //keeps track of which button has been selected
    private func buttonTapped(_ buttonNumber: Int) {
        showButtons = false
        selectedCase = buttonNumber
        
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
                images = ["message4", "message4", "message4", "message4"]
               
        }
        
    }
    
    let currentTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm"
        return formatter
    }()
    
    let currentDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd"
        return formatter
    }()


    func hideImage() {
        isShowingImage = false
    }
    

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
