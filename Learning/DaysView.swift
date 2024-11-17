import SwiftUI
import Combine // Import Combine to use Timer

struct DaysView: View {
    
    @ObservedObject var userData: UserData // Accept UserData

    @State private var selectedDateColors: [Date: String] = [:] // Dictionary to store colors for each date
    @State private var currentText = "Log today as Learned" // State variable to track the current text
    @State private var isDisabled: Bool = false // Track if the Freeze day button is disabled
    @State private var currentDate = Date() // Current date
    let calendar = Calendar.current
    @State private var selectedDate: Date? // Track the selected date
    
    @State private var freezeDaysUsed: Int = 0 // Track freeze days used
      // private let maxFreezeDays: Int = 2 // Maximum freeze days allowed

    // Computed property to dynamically determine max freeze days based on selectedOption
     private var maxFreezeDays: Int {
         if userData.selectedOption == "Weak" {
             return 2
         } else if userData.selectedOption == "Month"{
             return 6
         } else {
             return 60
         }
     }
    
    @State private var lastActionDate: Date? // Track last action time
        @State private var timer: AnyCancellable?
    private let thirtyHours: TimeInterval = 30 * 60 * 60 // 30 hours in seconds

    var body: some View {
        NavigationView {
            VStack{
                HStack {
                    VStack(alignment: .leading) {
                        Text(formattedDate(date: currentDate))
                            .foregroundColor(Color(hex: "48484A"))
                        Text("Learning \(userData.textInput)")
                            .font(.largeTitle)
                    }
                    Spacer() // Push the content to the right
                    
                    NavigationLink(destination: UpdateView(userData: userData)) {

                        ZStack{
                            Circle()
                                .fill(Color(hex: "2C2C2E")) // Background color of the circle
                                .frame(width: 45, height: 45) // Size of the circle
            
                            Text("🔥") // Your chosen emoji
                                .font(.system(size: 25)) // Size of the emoji
                        }
                    }
                }
                .padding([.top, .leading, .trailing]) // Add some spacing between the navigation link and button
                
                VStack {
                    // Rounded Calendar and Additional Info Section
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.clear) // Background color (customize this)
                            .shadow(radius: 5) // Add shadow for better effect
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke((Color(hex: "48484A")), lineWidth: 1) // Optional border around the entire section
                            )
                            .padding([.leading, .bottom, .trailing]) // Add padding around the entire section
                        
          VStack {
                    // Month and Year header
                    HStack {
                        
                        Text("\(monthAndYear(date: currentDate))")
                            .font(.title3)
                            .fontWeight(.bold)
                        Button(action: {
                            // Go to the next week
                            currentDate = calendar.date(byAdding: .weekOfMonth, value: 1, to: currentDate) ?? currentDate
                        }) {
                            Image(systemName: "chevron.right")
                                .foregroundColor(.orange)
                        }
                        Spacer()
                        Button(action: {
                            // Go to the previous week
                            currentDate = calendar.date(byAdding: .weekOfMonth, value: -1, to: currentDate) ?? currentDate
                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.orange)
                        }
                        
                        Button(action: {
                            // Go to the next week
                            currentDate = calendar.date(byAdding: .weekOfMonth, value: 1, to: currentDate) ?? currentDate
                        }) {
                            Image(systemName: "chevron.right")
                                .foregroundColor(.orange)
                        }
                    }
                    .padding([.leading, .bottom, .trailing])
                    
               // Days of the week row (Sun to Sat)
                            HStack {
                                
                                ForEach(["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"], id: \.self) { day in
                                    Text(day)
                                        .frame(maxWidth: .infinity)
                                        .font(.headline)
                                        .foregroundColor(.gray)
                                }
                            }
   
                            // Dates of the current week
                            let daysInWeek = daysInCurrentWeek(for: currentDate)
                            HStack {
                                ForEach(daysInWeek, id: \.self) { date in
                                    if let date = date, let day = calendar.dateComponents([.day], from: date).day {
                                        Text("\(day)")
                                            .frame(maxWidth: .infinity, minHeight: 40)
                                            .foregroundColor(
                                                // Check for the specific date in the selectedDateColors dictionary
                                                (calendar.isDateInToday(date)) ?
                                                Color(hex: "FF9F0A") :
                                                {
                                                    switch selectedDateColors[calendar.startOfDay(for: date)] {
                                                        case "Log today as Learned":
                                                            return Color.white
                                                        case "Learned Today":
                                                            return Color(hex: "FF9F0A")
                                                        case "Freeze day":
                                                            return Color(hex: "0A84FF")
                                                        default:
                                                            return Color.white
                                                        }
                                                    }()
                                                )

                                            .background(
                                                        {
                                                            switch selectedDateColors[calendar.startOfDay(for: date)] {
//                                                            case "Log today as Learned":
//                                                                return Color(hex: "FF9F0A")
                                                            case "Learned Today":
                                                                return Color(hex: "422800")
                                                            case "Freeze day":
                                                                return Color(hex: "021F3D")
                                                            default:
                                                                return Color.clear
                                                            }
                                                        }()
                                            ).cornerRadius(20)
                
                                    } else {
                                        Text("")
                                            .frame(maxWidth: .infinity, minHeight: 40)
                                    }
                                }
                            }
                            .padding(.horizontal)
                            
                            Divider()
                                .frame(width: 345, height: 1)  // Set the thickness of the horizontal divider
                                .background(Color(hex: "48484A"))  // Use background to set the color, not foregroundColor

                            HStack{
                                VStack{
                                    Text("\(userData.StreakDays)🔥")
                                        .font(.title)
                                        .frame(width: 50.0, height: 30.0)
                                    Text("Day streak").foregroundColor(Color(hex: "48484A"))
                                    
                                }
                                .padding()

                                Divider()
                                    .frame(width: 1, height: 80)  // Set the thickness for vertical dividers
                                    .background(Color(hex: "48484A"))  // Set color for the divider
                                    .padding(.horizontal)

                                VStack{
                                    Text("\(freezeDaysUsed)🧊").font(.title).frame(width: 50.0, height: 30.0)
                                    Text("Day freezed").foregroundColor(Color(hex: "48484A"))
                                } .padding()

                            }

                        }
                        .padding()
                    }
                
                  //  Spacer()
                    // Action buttons for learning
                    Button(action: {
                        logTodayAsLearned()
                        }) {
                        Circle()
                            .fill(
                                {
                                switch currentText {
                                case "Log today as Learned" :
                                return Color(hex: "FF9F0A")
                                case "Learned Today" :
                                return Color(hex: "422800")
                                case "Freeze day" :
                                return Color(hex: "021F3D")
                                default:
                                    return Color.gray
                            }
                            }()
                            ) // Change the color of the circle
                            .frame(width: 320, height: .infinity) // Set the size of the circle
                            .overlay(
                                Text(currentText)
                                    .font(.largeTitle)
                                    .foregroundColor({
                                        switch currentText {
                                        case "Log today as Learned" :
                                            return Color.black
                                        case "Learned Today" :
                                            return Color(hex: "FF9F0A")
                                        case "Freeze day" :
                                        return Color(hex: "0A84FF")
                                        default:
                                            return Color.gray
                                        } }() ) // Text color
                                    .fontWeight(.bold)
                            ) // Display the current text on top of the circle
                        }.onTapGesture {
                            currentDate = Date()
                        }
                    .buttonStyle(PlainButtonStyle()) // To ensure the button doesn’t have any default button styling
                    .padding(.bottom, 20) // Add some spacing
                    
                    // Freeze day button
                    Button(action: {
                        if freezeDaysUsed < maxFreezeDays {
                            currentText = "Freeze day" // Set the text to "Freeze day"

                            freezeDaysUsed += 1
                            isDisabled = true // Disable the button after press

                        } else if freezeDaysUsed >= maxFreezeDays {
                            currentText = "Log today as Learned"
                            isDisabled = true // Disable the button after press
                        }
                        
                        
                        // Set color for the current selected date to "Freeze day"
                        selectedDateColors[calendar.startOfDay(for: Date())] = "Freeze day" // Only change color for today
                        //currentDate = Date()
                    }) {
                        Text("Freeze day")
                            .frame(width: 160, height: 50)
                            .background(isDisabled ? Color(hex: "2C2C2E") : Color(hex: "C1DDFF"))
                            .foregroundColor(isDisabled ? Color(hex: "8E8E93") : Color(hex: "0A84FF"))
                            .cornerRadius(10)
                    }
                    .disabled(isDisabled)// Disable button if limit is reached
                    Text("\(freezeDaysUsed) out of \(maxFreezeDays)  freezes used").foregroundColor(Color(hex: "48484A"))
                }
                Spacer()
            }    .onAppear {
            
                startTimer() // Start the timer when the view appears
            }
            .onDisappear {
                timer?.cancel() // Stop the timer when the view disappears
            }
   
        }.navigationBarBackButtonHidden(true)
        .accentColor(.orange) // Set the back button color
    }
    
    // Helper function to get the month and year string
    func monthAndYear(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
    
    // Helper function to get the dates for the current week
    func daysInCurrentWeek(for date: Date) -> [Date?] {
        let weekRange = calendar.range(of: .weekday, in: .weekOfMonth, for: date)!
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date))!
        
        var days: [Date?] = []
        for dayOffset in 0..<weekRange.count {
            let dayDate = calendar.date(byAdding: .day, value: dayOffset, to: startOfWeek)
            days.append(dayDate)
        }
        return days
    }
    
    // Helper function to format the date to "Saturday, 19 OCT"
     func formattedDate(date: Date) -> String {
         let formatter = DateFormatter()
         formatter.dateFormat = "EEEE, dd MMM" // "Saturday, 19 OCT"
         return formatter.string(from: date)
     }
     
    // Helper function to check if a date is today
    func isToday(date: Date) -> Bool {
        return calendar.isDateInToday(date)
    }
    
    // Method to log today as learned
    private func logTodayAsLearned() {
        // Ensure only today's date is marked without affecting other dates
        if currentText == "Log today as Learned" {
            currentText = "Learned Today"
            isDisabled = true
            userData.StreakDays += 1
            lastActionDate = Date() // Update last action time
            selectedDateColors[calendar.startOfDay(for: Date())] = "Learned Today" // Mark only today's date as learned
        }
           else if freezeDaysUsed >= maxFreezeDays && (currentText == "Learned Today" || currentText == "Freeze day"){
            currentText = "Log today as Learned"
            isDisabled = true
            selectedDateColors[calendar.startOfDay(for: Date())] = "Log today as Learned" // Revert color change for today only
           } else {
               currentText = "Log today as Learned"
               isDisabled = false
               selectedDateColors[calendar.startOfDay(for: Date())] = "Log today as Learned" // Revert color change for today only
           }
    }

       // Start a timer to check for inactivity
       private func startTimer() {
           timer = Timer.publish(every: 60, on: .main, in: .common)
               .autoconnect()
               .sink { _ in
                   checkInactivity()
               }
       }

       // Check if user has been inactive for more than 30 hour
       private func checkInactivity() {
           guard let lastAction = lastActionDate else { return }
           if Date().timeIntervalSince(lastAction) > thirtyHours {
               // Reset the streak if more than 30 hours have passed since the last action
               userData.StreakDays = 0
               lastActionDate = nil // Reset last action date
           }
       }
       
       // Other methods...
       
       func startLearningPlan() {
           userData.startDate = Date()
           userData.StreakDays = 0 // Call this only when starting a new plan
       }
}

#Preview {
    DaysView(userData: UserData())
        .preferredColorScheme(.dark)
}

