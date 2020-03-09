@inline(__always) func evenFibo(_ max: Int) -> Int {

    var n1 = 1, n2 = 1
    var sFib = 0, s = 0

    while n2 < max {
        sFib = n1 + n2
        n1 = n2
        n2 = sFib

        if (n2 % 2) == 0 {
            s += n2
        }
    }

    return s
}
func notInlineEvenFibo(_ max: Int = 3) -> Int {

    var n1 = 1, n2 = 1
    var sFib = 0, s = 0

    while n2 < max {
        sFib = n1 + n2
        n1 = n2
        n2 = sFib

        if (n2 % 2) == 0 {
            s += n2
        }
    }

    return s
}


@inline(never) func largestPrimeFactor(_ n: Int) -> [Int] {
    var num = n
    var out: [Int] = []

    // We're looking for 2 factors so that later on we can step by 2 in the next loop
    while (num % 2) == 0 {
        out.append(2)
        num /= 2
    }

    for i in stride(from: 3, to: Int(Double(num).squareRoot()) + 1, by: 2) {

        while ((num % i) == 0) {
            out.append(i)
            num /= i
        }
    }

    return out
}
