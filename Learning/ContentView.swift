//
//  ContentView.swift
//  Learning
//
//  Created by Shahad on 14/04/1446 AH.
//

import SwiftUI
import Foundation
import Combine

class UserData: ObservableObject {
    @Published var textInput: String = ""
    @Published var selectedOption: String? = "Month"
    //@Published var StreakDays: Int = 0
    @Published var startDate: Date? = nil // Track when the learning started
    @Published var StreakDays: Int = UserDefaults.standard.integer(forKey: "StreakDays")

    func resetStreakDays() {
        StreakDays = 0 // Reset the streak days
        UserDefaults.standard.set(StreakDays, forKey: "StreakDays") // Save the new streak value
    }
}

struct ContentView: View {
    @StateObject var userData = UserData() // Instantiate UserData

    @State private var textInput: String = ""
    @State private var selectedOption: String? = nil // Track the selected option

    var body: some View {
        NavigationView {
            VStack{
                ZStack{
                    Circle()
                        .fill(Color(hex: "2C2C2E")) // Background color of the circle
                        .frame(width: 120, height: 120) // Size of the circle
                    
                    Text("🔥") // Your chosen emoji
                        .font(.system(size: 60)) // Size of the emoji
                }
                .padding()
             //   Spacer()
                HStack{
                    VStack(alignment: .leading) {
                        Text("Hello Learner!")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Text("This app will help you learn everyday").font(.title3).foregroundColor( Color(hex: "48484A"))
                        Text("I want to learn")
                            .fontWeight(.bold)                            .padding(.top)
                        //.padding(.horizontal)
                        TextField("Swift", text: $userData.textInput) // This correctly binds to UserData

                            .frame(width: 360.0, height: 45.0)
                            .textFieldStyle(RoundedBorderTextFieldStyle()) // Adds border style
                       
                            .accentColor(.orange)
                        Text("I want to learn it in a")
                            .fontWeight(.bold)
                        // .padding()
                    }
                }.padding()
                
                
                 HStack(spacing: 10) {
                                       Button(action: {
                                           userData.selectedOption = "Weak" // Update directly in userData
                                       }) {
                                           Text("Weak")
                                               .frame(width: 80, height: 40)
                                               .background(userData.selectedOption == "Weak" ? Color(hex: "FF9F0A") : Color(hex: "2C2C2E"))
                                               .foregroundColor(userData.selectedOption == "Weak" ? Color(.black) : Color(hex: "FF9F0A"))
                                               .cornerRadius(10)
                                       }

                                       Button(action: {
                                           userData.selectedOption = "Month" // Update directly in userData
                                       }) {
                                           Text("Month")
                                               .frame(width: 80, height: 40)
                                               .background(userData.selectedOption == "Month" ? Color(hex: "FF9F0A") : Color(hex: "2C2C2E"))
                                               .foregroundColor(userData.selectedOption == "Month" ? Color(.black) : Color(hex: "FF9F0A"))
                                               .cornerRadius(10)
                                       }

                                       Button(action: {
                                           userData.selectedOption = "Year" // Update directly in userData
                                       }) {
                                           Text("Year")
                                               .frame(width: 80, height: 40)
                                               .background(userData.selectedOption == "Year" ? Color(hex: "FF9F0A") : Color(hex: "2C2C2E"))
                                               .foregroundColor(userData.selectedOption == "Year" ? Color(.black) : Color(hex: "FF9F0A"))
                                               .cornerRadius(10)
                                       }
                                   }
                .frame(maxWidth: .infinity, alignment: .leading) // Align HStack to the left
                .padding([.leading, .bottom, .trailing])
                
                NavigationLink(destination: DaysView(userData: userData)) { // Pass userData to DaysView
                    
                    HStack {
                        
                        Text("Start")
                            .font(.headline)
                        
                        Image(systemName: "arrow.right")
                            .font(.headline) // Adjust the font size of the icon
                       

                    }.frame(width: 150, height: 50)
                        .background( Color(hex: "FF9F0A"))
                        .foregroundColor( Color.black)
                        .cornerRadius(10).padding(17.0)
                    
                }
                Spacer()
            }
   }
        .padding()
        }
    
}



#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
