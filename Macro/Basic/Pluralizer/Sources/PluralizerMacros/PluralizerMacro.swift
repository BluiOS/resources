import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct PluralizerMacro: PeerMacro {
    
    public static func expansion(of node: SwiftSyntax.AttributeSyntax, providingPeersOf declaration: some SwiftSyntax.DeclSyntaxProtocol, in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> [SwiftSyntax.DeclSyntax] {
        guard let variableDeclSyntax = declaration.as(VariableDeclSyntax.self) else {
            return []
        }
        
        let attributesSyntax = variableDeclSyntax.attributes.compactMap { $0.as(AttributeSyntax.self) }
        guard let attributeSyntax = attributesSyntax.first else {
            return []
        }
        
        guard let labeledExprListSyntax = attributeSyntax.arguments?.as(LabeledExprListSyntax.self) else {
            return []
        }
        
        let labelSyntax = labeledExprListSyntax.compactMap { $0.as(LabeledExprSyntax.self) }.first
        guard let labelSyntax else { return [] }
        
        guard let stringLiteralExprSyntax = labelSyntax.expression.as(StringLiteralExprSyntax.self) else {
            return []
        }
        
        let segment = stringLiteralExprSyntax
            .segments
            .compactMap { $0.as(StringSegmentSyntax.self) }
            .first
        guard let segment else { return [] }
        let inputParameter = segment.content.text
        
        let bindings = variableDeclSyntax.bindings.compactMap { $0.as(PatternBindingSyntax.self) }
        guard let pattern = bindings.first?.pattern.as(IdentifierPatternSyntax.self) else {
            return []
        }
        
        let variableName = pattern.identifier.text
        
        guard let typeAnnotation = bindings.first?.typeAnnotation else {
            return []
        }
        
        if typeAnnotation.type.is(ArrayTypeSyntax.self) { // [T]
            let pluralizeVariablesDecl =
                                """
                                var \(variableName)Str: String {
                                    return \(variableName).count.pluralize(input: "\(inputParameter)")
                                }
                                """
            
            return [.init(stringLiteral: pluralizeVariablesDecl)]
            
        } else if let typeSyntax = typeAnnotation.type.as(IdentifierTypeSyntax.self) { // Array<T> or Int
            
            let prefixVariableName = if typeSyntax.name.text == "Int" {
                "\(variableName)"
                
            } else if typeSyntax.name.text == "Array" {
                "\(variableName).count"
                
            } else {
                throw PluralizerMacroError.shouldApplyOnIntOrArray
            }
            
            let pluralizeVariablesDecl =
                                """
                                var \(variableName)Str: String {
                                    return \(prefixVariableName).pluralize(input: "\(inputParameter)")
                                }
                                """
            
            return [.init(stringLiteral: pluralizeVariablesDecl)]
            
        } else {
            // TODO: - handler other type such as Dictionary, Set and etc.
            return []
        }
    }
}

public enum PluralizerMacroError: Error, CustomStringConvertible {
    case shouldApplyOnIntOrArray
    
    public var description: String {
        switch self {
        case .shouldApplyOnIntOrArray:
            return "Macro can apply on Int or Array"
        }
    }
}

@main
struct PluralizerPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        PluralizerMacro.self
    ]
}
