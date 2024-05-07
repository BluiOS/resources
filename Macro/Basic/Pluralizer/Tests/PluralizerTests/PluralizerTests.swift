import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(PluralizerMacros)
import PluralizerMacros

let testMacros: [String: Macro.Type] = [
    "Pluralizer": PluralizerMacro.self
]
#endif

final class PluralizerTests: XCTestCase {
    
    func testMacroWithIntegerVariable() throws {
        #if canImport(PluralizerMacros)
        assertMacroExpansion(
            #"""
            struct Sample {
                
                @Pluralizer(singular: "slide")
                var slides: Int = 0
            }
            """#,
            expandedSource: #"""
            struct Sample {
                
                var slides: Int = 0

                var slidesStr: String {
                    return slides.pluralize(input: "slide")
                }
            }
            """#,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func testMacroWithArrayVariable() throws {
        #if canImport(PluralizerMacros)
        assertMacroExpansion(
            #"""
            struct Sample {
                @Pluralizer(singular: "hessam")
                var hessamList: [String] = [""]
            }
            """#,
            expandedSource: #"""
            struct Sample {
                var hessamList: [String] = [""]

                var hessamListStr: String {
                    return hessamList.count.pluralize(input: "hessam")
                }
            }
            """#,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func testMacroWithArrayVariableWithOtherFace() throws {
        #if canImport(PluralizerMacros)
        assertMacroExpansion(
            #"""
            struct Sample {
                @Pluralizer(singular: "hessam")
                var hessamList: Array<String> = [""]
            }
            """#,
            expandedSource: #"""
            struct Sample {
                var hessamList: Array<String> = [""]

                var hessamListStr: String {
                    return hessamList.count.pluralize(input: "hessam")
                }
            }
            """#,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
}
