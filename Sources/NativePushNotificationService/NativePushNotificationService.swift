//
//  NativePushNotificationService.swift
//  NativePushNotificationService
//
//  Created by Sven Op de Hipt on 06.05.24.
//

import UserNotifications

/// A notification service extension to handle modifications to push notifications before they are delivered to the user.
open class NativePushNotificationService: UNNotificationServiceExtension {
    private var contentHandler: ((UNNotificationContent) -> Void)?
    private var bestAttemptContent: UNMutableNotificationContent?

    /// Called when a notification is received. This method can be used to modify the notification content.
    /// - Parameters:
    ///   - request: The notification request.
    ///   - contentHandler: The content handler to execute with the modified notification content.
    open override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        let bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent) ?? UNMutableNotificationContent()
        self.bestAttemptContent = bestAttemptContent
        
        bestAttemptContent.title = request.content.title
        bestAttemptContent.body = request.content.body
        guard let urlString = bestAttemptContent.userInfo["native_push_image"] as? String else {
            contentHandler(bestAttemptContent)
            return
        }
        guard let imageUrl = URL(string: urlString) else {
            contentHandler(bestAttemptContent)
            return
        }
        guard let imageData = NSData(contentsOf: imageUrl) else {
            contentHandler(bestAttemptContent)
            return
        }
        
        guard let attachment = UNNotificationAttachment.saveImageToDisk(fileIdentifier: "notification_\(request.identifier).jpg", data: imageData) else {
            contentHandler(bestAttemptContent)
            return
        }
        bestAttemptContent.attachments = [attachment]
        contentHandler(bestAttemptContent)
    }
    
    /// Called just before the service extension is terminated by the system.
    /// This method is used to deliver the best attempt at modified content if the extension's time has expired.
    open override func serviceExtensionTimeWillExpire() {
        if let contentHandler = contentHandler, let bestAttemptContent = bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
}

private extension UNNotificationAttachment {
    /// Saves an image to disk and returns a notification attachment.
    /// - Parameters:
    ///   - fileIdentifier: A unique identifier for the file.
    ///   - data: The image data to be saved.
    ///   - options: Options for the attachment.
    /// - Returns: A UNNotificationAttachment if the file is successfully saved, otherwise nil.
    static func saveImageToDisk(fileIdentifier: String, data: NSData, options: [NSObject : AnyObject]? = nil) -> UNNotificationAttachment? {
        let fileManager = FileManager.default
        let folderName = ProcessInfo.processInfo.globallyUniqueString
        guard let folderURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(folderName, isDirectory: true) else {
            return nil
        }
        
        do {
            try fileManager.createDirectory(at: folderURL, withIntermediateDirectories: true)
            let fileURL = folderURL.appendingPathComponent(fileIdentifier)
            try data.write(to: fileURL, options: [])
            return try UNNotificationAttachment(identifier: fileIdentifier, url: fileURL, options: options)
        } catch {
            return nil
        }
    }
}
