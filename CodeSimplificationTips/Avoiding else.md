## Avoidng else

"Why else is 'else' not good in programming?"

1. Reduced Readability:

**Complexity**: When else is used in complex conditional structures, it can make the code harder to read and understand. Especially in long if-else chains, it can be difficult to follow the logic.

**Ambiguity**: An else block can sometimes make it less clear under what conditions the code will execute. Readers may have to mentally calculate the negation of the if condition to understand the logic.

```swift
// example with else
func determineDiscount(for age: Int, isStudent: Bool) -> Double {
    if age < 18 {
        return 0.50  // 50% discount for minors
    } else if age >= 18 && age < 65 {
        if isStudent {
            return 0.20  // 20% discount for students
        } else {
            return 0.10  // 10% discount for adults
        }
    } else {
        return 0.30  // 30% discount for seniors
    }
}
```

```swift
// correct Code without else
func determineDiscountWithOutElse(for age: Int, isStudent: Bool) -> Double {
    if age < 18 {
        return 0.50  // 50% discount for minors
    }
    
    if age >= 65 {
        return 0.30  // 30% discount for seniors
    }
    
    if isStudent {
        return 0.20  // 20% discount for students
    }

    return 0.10  // 10% discount for adults
}
```


2. Error-Prone Logic:

**Implicit Assumptions**: Using else can imply that you have considered all possible conditions, which might not always be true. If you miss a possible condition, the else block could execute unexpectedly.

**Silent Failures**: If else is used without careful consideration, errors might go unnoticed because the program may silently do the wrong thing rather than raising an error.

```swift
// example with else
func determineMembershipLevel(points: Int) -> String {
    if points >= 1000 {
        return "Gold"
    } else if points >= 500 {
        return "Silver"
    } else {
        return "Bronze"
    }
}
```

```swift
// correct Code without else
func determineMembershipLevelWithOutElse(points: Int) -> String {
    guard points >= 0 else {
        return "Invalid points"
    }

    if points >= 1000 {
        return "Gold"
    }

    if points >= 500 {
        return "Silver"
    }

    return "Bronze"
}
```

3. Increased Maintenance Difficulty:

**Refactoring Issues**: During code refactoring, if the conditions in the if statement change, you might also need to update the else logic to ensure correctness. This adds to the maintenance burden.

**Adding Conditions**: When new conditions are added to the logic, it might become difficult to correctly insert them into existing if-else chains without introducing bugs.

```swift
// example with else
func determineShippingCost(weight: Double, isExpress: Bool) -> Double {
    if weight <= 1.0 {
        return isExpress ? 10.0 : 5.0
    } else if weight <= 5.0 {
        return isExpress ? 20.0 : 15.0
    } else {
        return isExpress ? 50.0 : 30.0
    }
}
```

```swift
// correct Code without else
func determineShippingCost(weight: Double, isExpress: Bool, isInternational: Bool = false) -> Double {
    guard weight > 0 else {
        return 0.0 // Invalid weight
    }
    
    if isInternational {
        return calculateInternationalShippingCost(weight: weight, isExpress: isExpress)
    }

    if weight <= 1.0 {
        return isExpress ? 10.0 : 5.0
    }

    if weight <= 5.0 {
        return isExpress ? 20.0 : 15.0
    }

    return isExpress ? 50.0 : 30.0
}

func calculateInternationalShippingCost(weight: Double, isExpress: Bool) -> Double {
    if weight <= 1.0 {
        return isExpress ? 30.0 : 20.0
    }
    
    if weight <= 5.0 {
        return isExpress ? 60.0 : 45.0
    }
    
    return isExpress ? 120.0 : 90.0
}
```

4. Encourages Overuse of Conditional Logic:

**Leads to Complex Conditionals**: Over-reliance on else can encourage the use of lengthy if-else chains, which can often be replaced with more elegant solutions like polymorphism, strategy patterns, or lookup tables.

**Hinders Code Refactoring**: It can make the code less modular and harder to refactor, as opposed to using methods that eliminate or reduce the need for multiple conditionals.

```swift
// example with else
func calculateBonus(employeeType: String, sales: Double) -> Double {
    if employeeType == "Manager" {
        if sales > 10000 {
            return sales * 0.10
        } else {
            return sales * 0.05
        }
    } else if employeeType == "Salesperson" {
        if sales > 10000 {
            return sales * 0.07
        } else {
            return sales * 0.03
        }
    } else if employeeType == "Intern" {
        return sales * 0.01
    } else {
        return 0.0
    }
}
```

```swift
// correct Code without else
protocol Employee {
    func calculateBonus(sales: Double) -> Double
}

class Manager: Employee {
    func calculateBonus(sales: Double) -> Double {
        return sales > 10000 ? sales * 0.10 : sales * 0.05
    }
}

class Salesperson: Employee {
    func calculateBonus(sales: Double) -> Double {
        return sales > 10000 ? sales * 0.07 : sales * 0.03
    }
}

class Intern: Employee {
    func calculateBonus(sales: Double) -> Double {
        return sales * 0.01
    }
}

// Usage
func calculateBonus(for employee: Employee, sales: Double) -> Double {
    return employee.calculateBonus(sales: sales)
}
```

5. Risk of Missing Edge Cases:

**Unintended Behavior**: If all possible cases are not explicitly handled, the else might catch edge cases or unexpected conditions, leading to unintended or undefined behavior.

```swift
// example with else
func determineUserRole(accessLevel: Int) -> String {
    if accessLevel == 1 {
        return "Admin"
    } else if accessLevel == 2 {
        return "Editor"
    } else {
        return "Viewer"
    }
}
```

```swift
// correct Code without else
func determineUserRoleWithOutElse(accessLevel: Int) -> String {
    switch accessLevel {
    case 1:
        return "Admin"
    case 2:
        return "Editor"
    case 3:
        return "Viewer"
    default:
        return "Unknown Role"
    }
}
```

6. Implicit Coupling:

**Tight Coupling**: The use of else can tightly couple the conditions in the if statement with the else logic, making the code less flexible and harder to change independently.

```swift
// example with else
func calculateShippingCost(weight: Double, destination: String) -> Double {
    if destination == "Domestic" {
        if weight <= 1.0 {
            return 5.0
        } else if weight <= 5.0 {
            return 10.0
        } else {
            return 15.0
        }
    } else {  // International
        if weight <= 1.0 {
            return 20.0
        } else if weight <= 5.0 {
            return 40.0
        } else {
            return 60.0
        }
    }
}
```

```swift
// correct Code without else
func calculateDomesticShippingCost(weight: Double) -> Double {
    if weight <= 1.0 {
        return 5.0
    }
    
    if weight <= 5.0 {
        return 10.0
    }
    
    return 15.0
}

func calculateInternationalShippingCost(weight: Double) -> Double {
    if weight <= 1.0 {
        return 20.0
    }
    
    if weight <= 5.0 {
        return 40.0
    }
    
    return 60.0
}

func calculateShippingCostWithOutElse(weight: Double, destination: String) -> Double {
    if destination == "Domestic" {
        return calculateDomesticShippingCost(weight: weight)
    }
    
    return calculateInternationalShippingCost(weight: weight)
}
```

7. Logical Inversion Issues:

**Negative Logic**: Sometimes, to understand what the else block does, you have to mentally invert the if condition, which can lead to cognitive overload and potential errors.

```swift
// example with else
func processOrder(orderAmount: Double) -> String {
    if orderAmount >= 100 {
        return "Order qualifies for free shipping."
    } else {
        return "Order does not qualify for free shipping."
    }
}
```

```swift
// correct Code without else
func processOrderWithOutElse(orderAmount: Double) -> String {
    if orderAmount < 100 {
        return "Order does not qualify for free shipping."
    }
    
    return "Order qualifies for free shipping."
}
```


Alternatives to else:

<br/>

**Early Return (Guard Clauses)**: By handling the specific cases early and returning or breaking out of the function, you can avoid an else altogether, making the code more straightforward.

**Switch/Case Statements**: In some languages, using a switch or case statement can make the intent clearer when dealing with multiple discrete conditions.

**Ternary Operators**: For simple cases, a ternary operator can be a concise and readable alternative.

**Polymorphism**: In object-oriented design, using polymorphism can eliminate the need for conditional logic altogether.

In summary, while else is not inherently bad, its misuse or overuse can lead to less readable, harder-to-maintain, and error-prone code
