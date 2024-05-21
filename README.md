# Native Push Notification Service

## Overview

`NativePushNotificationService` is a notification service extension for iOS, designed to handle and modify push notifications before they are delivered to the user. This extension allows for modifications such as adding images to notifications based on data included in the push payload.

## Features

- **Modifies Notification Content**: Customize notification content including title, body, and attachments.
- **Image Attachments**: Fetches and adds images to notifications based on URLs provided in the push payload.
- **Graceful Handling of Time Expiry**: Ensures best attempt content is delivered if the service extension is about to be terminated by the system.

## Installation

To use `NativePushNotificationService` in your project, follow these steps:

### Swift Package Manager

1. In Xcode, open your project and navigate to **File > Add Package Dependencies**.
2. Enter the URL of the `NativePushNotificationService` repository.
3. Choose the version rule and proceed to add the package to your project.

### Setting Up Notification Service Extension

1. Create a new Notification Service Extension target in your Xcode project.
2. Replace the content of `NotificationService.swift` with the provided `NotificationService` code.
3. Add `Background Modes` with `Remote Notification` the capabilites of your main app.

## Example Notification Service

Here is an example of how to use `NativePushNotificationService` in your notification service extension:

```swift
import NativePushNotificationService

final class NotificationService: NativePushNotificationService {}
```

## Related projects

- [Native Push](https://github.com/Native-Push/native_push): The main Flutter library
- [Native Push Client](https://github.com/Native-Push/native_push_client): The Flutter library to be used with `Native Push Server`
- [Native Push Server](https://github.com/Native-Push/native_push_server): The server which can be used as a microservices and a
  library which can be used for an own server.
- [Native Push Vapid](https://github.com/Native-Push/native_push_vapid): The library which should be used to generate Vapid Keys if
  web is a supported platform.

## Contributing

Contributions are welcome! Feel free to open issues or submit pull requests.

## License

This project is licensed under the BSD-3 License. See the [LICENSE](LICENSE) file for details.
