//
//  Space.swift
//  Reset
//
//  Created by Prasanjit Panda on 10/12/24.
//

import Foundation

struct Space {
    let title: String
    let host: String
    let description: String
    let listenersCount: Int
    let liveDuration: String
}

var mockSpaces: [Space] = [
        Space(
            title: "Celebrating Milestones: Big and Small",
            host: "SoberWarrior42",
            description: "Open mic for sharing recovery victories",
            listenersCount: 83,
            liveDuration: "Live for 45 mins"
        ),
        Space(
            title: "Morning Motivation: Staying on Track",
            host: "RiseAndShine23",
            description: "A space for morning affirmations and encouragement.",
            listenersCount: 120,
            liveDuration: "Live for 1 hour"
        ),
        Space(
            title: "Ask Me Anything: Recovery Q&A",
            host: "HealingJourney",
            description: "Get answers to your recovery-related questions.",
            listenersCount: 45,
            liveDuration: "Live for 30 mins"
        ),
        Space(
            title: "Breaking Chains Together",
            host: "FreedomFighter",
            description: "Stories of breaking free from addiction and support for each other.",
            listenersCount: 67,
            liveDuration: "Live for 20 mins"
        ),
        Space(
            title: "Late Night Reflections: One Day at a Time",
            host: "NightOwlRecovery",
            description: "Reflecting on the day's victories and challenges.",
            listenersCount: 34,
            liveDuration: "Live for 2 hours"
        )
    ]
