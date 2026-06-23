# fk_user_agent

[![Pub](https://img.shields.io/pub/v/fk_user_agent.svg)](https://pub.dartlang.org/packages/fk_user_agent)
[![Awesome Flutter](https://img.shields.io/badge/Awesome-Flutter-blue.svg?longCache=true&style=flat-square)]()
[![Awesome Flutter](https://img.shields.io/badge/Platform-Android_iOS_OHOS-blue.svg?longCache=true&style=flat-square)]()
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](/LICENSE)

Retrieve Android/iOS/OHOS device user agents in Flutter.

### Example user-agents:

| System | User-Agent | WebView User-Agent |
| ------ | ---------- | ------------------ |
| iOS    | CFNetwork/897.15 Darwin/17.5.0 (iPhone/6s iOS/11.3) | Mozilla/5.0 (iPhone; CPU iPhone OS 11_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E217 |
| Android | Dalvik/2.1.0 (Linux; U; Android 5.1.1; Android SDK built for x86 Build/LMY48X) | Mozilla/5.0 (Linux; Android 5.1.1; Android SDK built for x86 Build/LMY48X) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/39.0.0.0 Mobile Safari/537.36 |
| OHOS    | HarmonyOS/6.0.0 (phone; HUAWEI BLK-AL80; OpenHarmony-6.0.2.130) | Mozilla/5.0 (Phone; OpenHarmony 6.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36  ArkWeb/6.0.0.130 Mobile |

### Additionally:

Every version returns some additional constants that might be useful for custom user-agent building.

iOS version returns:
- isEmulator
- systemName
- systemVersion
- applicationName
- applicationVersion
- buildNumber
- darwinVersion
- cfnetworkVersion
- deviceName
- packageUserAgent

Android version returns:
- systemName
- systemVersion
- packageName
- shortPackageName
- applicationName
- applicationVersion
- applicationBuildNumber
- packageUserAgent

OHOS (HarmonyOS) version returns:
- systemName
- systemVersion
- packageName
- shortPackageName
- applicationName
- applicationVersion
- applicationBuildNumber
- packageUserAgent
- userAgent
- webViewUserAgent

### Credits 👍

Based of https://github.com/j0j00/flutter_user_agent