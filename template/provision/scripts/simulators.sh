#!/usr/bin/env bash
set -e
set -o pipefail

IOS_TARGET=iOS$IOS_LATEST

echo Creating simulators
xcrun simctl create "iPhone 11" com.apple.CoreSimulator.SimDeviceType.iPhone-11 $IOS_TARGET
xcrun simctl create "iPhone 11 Pro" com.apple.CoreSimulator.SimDeviceType.iPhone-11-Pro $IOS_TARGET
xcrun simctl create "iPhone 11 Pro Max" com.apple.CoreSimulator.SimDeviceType.iPhone-11-Pro-Max $IOS_TARGET
xcrun simctl create "iPhone 12 mini" com.apple.CoreSimulator.SimDeviceType.iPhone-12-mini $IOS_TARGET
xcrun simctl create "iPhone 12" com.apple.CoreSimulator.SimDeviceType.iPhone-12 $IOS_TARGET
xcrun simctl create "iPhone 12 Pro" com.apple.CoreSimulator.SimDeviceType.iPhone-12-Pro $IOS_TARGET
xcrun simctl create "iPhone 12 Pro Max" com.apple.CoreSimulator.SimDeviceType.iPhone-12-Pro-Max $IOS_TARGET
xcrun simctl create "iPhone 13 Pro" com.apple.CoreSimulator.SimDeviceType.iPhone-13-Pro $IOS_TARGET
xcrun simctl create "iPhone 13 Pro Max" com.apple.CoreSimulator.SimDeviceType.iPhone-13-Pro-Max $IOS_TARGET
xcrun simctl create "iPhone 13 mini" com.apple.CoreSimulator.SimDeviceType.iPhone-13-mini $IOS_TARGET
xcrun simctl create "iPhone 13" com.apple.CoreSimulator.SimDeviceType.iPhone-13 $IOS_TARGET
