import Pluralizer

struct MainPluralizer {
    
    @Pluralizer(singular: "hessam")
    var numberOfHessam: Int = 0
    
    @Pluralizer(singular: "hessam")
    var hessamList: [String] = [""]
    
    @Pluralizer(singular: "hessam")
    var hessamList2: Array<String> = [""]
}
