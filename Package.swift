// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SocialAuthTrial",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "SocialAuthTrial",
            targets: ["SocialAuthFw"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/facebook/facebook-ios-sdk.git", from: "16.2.1"),
        .package(url: "https://github.com/google/GoogleSignIn-iOS.git", from: "7.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .binaryTarget(
            name: "SocialAuthFw",
            path: "SocialAuthFw.xcframework"
        )
//        .target(
//            name: "SocialAuth",
//            dependencies: [
//                .product(name: "FacebookLogin", package: "facebook-ios-sdk"),
//                .product(name: "GoogleSignIn", package: "GoogleSignIn-iOS"),
//                .target(name: "SocialAuthFw")
//            ], path: "")
    ]
)
