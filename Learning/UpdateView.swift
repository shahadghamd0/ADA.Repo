import SwiftUI
import Combine

extension Color {
    init(hex: String) {
        var rgb: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&rgb)
        
        let red = Double((rgb >> 16) & 0xFF) / 255.0
        let green = Double((rgb >> 8) & 0xFF) / 255.0
        let blue = Double(rgb & 0xFF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
}

struct UpdateView: View {
    @ObservedObject var userData: UserData // Accept UserData

    @Environment(\.presentationMode) var presentationMode // Access the environment's presentation mode

    var body: some View {
        VStack(alignment: .leading) {
            Text("I want to learn")
                .padding(.horizontal)
            
            // Directly bind to userData.textInput
            TextField("Swift", text: $userData.textInput)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 360.0, height: 45.0)
                .padding(.horizontal)
                .accentColor(.orange)

            Text("I want to learn it in a")
                .padding(.horizontal)

            HStack(spacing: 10) {
                ForEach(["Weak", "Month", "Year"], id: \.self) { option in
                    Button(action: {
                        userData.selectedOption = option // Sync with userData
                    }) {
                        Text(option)
                            .frame(width: 80, height: 40)
                            .background(userData.selectedOption == option ? Color(hex: "FF9F0A") : Color(hex: "2C2C2E"))
                            .foregroundColor(userData.selectedOption == option ? Color(.black) : Color(hex: "FF9F0A"))
                            .cornerRadius(10)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading) // Align HStack to the left
            .padding(.horizontal)
        }
        .frame(maxHeight: .infinity, alignment: .top) // Align VStack contents to the top
        .padding()
        .navigationBarTitle("Learning goal", displayMode: .inline)
        .navigationBarItems(trailing:
            Button(action: {
               // saveData()
                userData.resetStreakDays()
                presentationMode.wrappedValue.dismiss() // Dismiss the view
            }) {
                Text("Update")
            }
            .foregroundColor(Color(hex: "FF9F0A"))
        )
    }

    // Save the text input and selected option to UserDefaults
    func saveData() {
        
        UserDefaults.standard.set(userData.textInput, forKey: "savedTextInput")
        UserDefaults.standard.set(userData.selectedOption, forKey: "savedSelectedOption")
        
    }

    // Load saved data from UserDefaults
    func loadSavedData() {
        userData.textInput = UserDefaults.standard.string(forKey: "savedTextInput") ?? ""
        userData.selectedOption = UserDefaults.standard.string(forKey: "savedSelectedOption")
    }
}

#Preview {
    UpdateView(userData: UserData())
        .preferredColorScheme(.dark)
}
