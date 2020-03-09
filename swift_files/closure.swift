
let names = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]

reversedNames = names.sorted(by: { (s1: String, s2: String) -> Bool in
    return s1 > s2
})
