//
//  ContentView.swift
//  Bubbly
//
//  Created by Devin Jay on 9/5/26.
//

import SwiftUI
import UserNotifications

struct ContentView: View
{
    let defaults = UserDefaults.standard
    
    @State private var interval:Int = 30
    @State private var selectedStartTime = Date()
    @State private var selectedEndTime = Date()
    @FocusState private var focusItem: Bool

    var body: some View
    {
        ZStack
        {
            Color(.blue)
                .ignoresSafeArea()
            VStack
            {
                VStack
                {
                    Text("Bubbly!")
                        .font(.custom("MarkerFelt-Thin", size: 90))
                        .foregroundStyle(Color(red: 0.4627, green: 0.8392, blue: 1.0))
                }
                Spacer()
                Button(action: {schedule(schedulingInterval: Double(interval))})
                {
                    ZStack
                    {
                        Image("Bubble")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                        Text("Schedule")
                            .font(.custom("MarkerFelt-Thin", size: 40))
                            .foregroundStyle(Color(red: 0.4627, green: 0.8392, blue: 1.0))
                    }
                }
                ZStack
                {
                    Image("BubbleWrap")
                        .resizable()
                        .scaledToFit()
                        .rotationEffect(.degrees(90))
                        .scaleEffect(x: 1, y: -1)
                        .overlay
                        {
                            HStack (spacing: 100)
                            {
                                ZStack
                                {
                                    Image("Bubble")
                                        .resizable()
                                        .frame(width: 110, height: 110)
                                    TextField("Interval?", value: $interval, format: .number)
                                        .keyboardType(.numberPad)
                                        .frame(width: 110, height: 110)
                                        .multilineTextAlignment(.center)
                                        .onSubmit
                                        {
                                            focusItem = false
                                        }
                                        .focused($focusItem)
                                        .onChange(of: interval) { _, newInterval in
                                                
                                                    let clampedValue = max(0, min(interval, 60))
                                                    if interval != clampedValue {
                                                        interval = clampedValue
                                                    }
                                                    defaults.set(clampedValue, forKey: "interval")
                                                
                                            }
                                    
                                }
                                VStack
                                {
                                    DatePicker("", selection: $selectedStartTime, displayedComponents: .hourAndMinute)
                                        .onChange(of: selectedStartTime)
                                        {
                                            _, newStart in defaults.set(newStart, forKey: "startTime")
                                        }
                                        .datePickerStyle(.compact)
                                        .labelsHidden()
                                        .overlay
                                        {
                                            Image("Bubble")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 110, height: 110)
                                                .allowsHitTesting(false)
                                        }
                                        .padding(.trailing, 50)
                                        .padding(.bottom, 100)
                                        DatePicker("", selection: $selectedEndTime, displayedComponents: .hourAndMinute)
                                            .onChange(of: selectedEndTime)
                                            {
                                                _, newEnd in
                                                
                                                // guarantee that end time is after start time
                                                if newEnd > selectedStartTime
                                                {
                                                    defaults.set(newEnd, forKey: "endTime")
                                                }
                                                // otherwise, clamp to start time (if not already)
                                                else if selectedEndTime != selectedStartTime
                                                {
                                                    selectedEndTime = selectedStartTime
                                                    defaults.set(selectedStartTime, forKey: "endTime")
                                                }
                                                
                                            }
                                            .datePickerStyle(.compact)
                                            .labelsHidden()
                                            .overlay
                                            {
                                                Image("Bubble")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 110, height: 110)
                                                    .allowsHitTesting(false)
                                            }
                                            .padding(.trailing, 50)
                                }
                            }
                            .padding(.leading, 45)
                        }
                }
            }
        }
        .onTapGesture
        {
            focusItem = false
        }
        .task
                {
                    if let pastStartTime = defaults.object(forKey: "startTime")
                    {
                        selectedStartTime = pastStartTime as! Date
                    }
                    
                    if let pastEndTime = defaults.object(forKey: "endTime")
                    {
                        selectedEndTime = pastEndTime as! Date
                    }
                    
                    
                    if let pastInterval = defaults.object(forKey: "interval") as? Int
                    {
                        interval = pastInterval
                    }
                    
                    await setUpNotifications()
                }
    }
    
    func setUpNotifications() async
    {
        do
        {
            try await notifCenter.requestAuthorization(options: [.alert, .sound, .badge])
        }
        catch
        {
        }
    }
}

#Preview
{
    ContentView()
}
