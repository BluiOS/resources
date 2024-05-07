// The Swift Programming Language
// https://docs.swift.org/swift-book

@attached(peer, names: arbitrary)
public macro Pluralizer(singular: StaticString) = #externalMacro(module: "PluralizerMacros", type: "PluralizerMacro")
