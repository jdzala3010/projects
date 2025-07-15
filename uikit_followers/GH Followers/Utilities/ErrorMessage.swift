//
//  ErrorMessage.swift
//  GH Followers
//
//  Created by Jaydeep Zala on 06/05/25.
//

import Foundation

enum GFError: String, Error {
    case invalidUsername = "This username created an invalid request."
    case invalidResponse = "Invalid response from the server. Please try again later."
    case invalidData = "The data recieved from server was invalid. Please try again later."
    case unableToComplete = "Unable to complete your request."
    case unableFavoriting = "Unable to foverite this user. Try again."
    case alreadyFavourated = "Already exist amongst your favorites."
    case errorRemoving = "Couldn't remove the user."
}
