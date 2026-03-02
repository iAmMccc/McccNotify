// swift-tools-version: 5.5

import PackageDescription

let package = Package(
    name: "McccNotify",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "McccNotify",
            targets: ["McccNotify"]
        )
    ],
    targets: [
        .target(
            name: "McccNotify",
            path: "McccNotify",
            sources: [
                "Classes/Log",
                "Classes/Service",
                "Classes/Send"
            ]
        )
    ]
)
