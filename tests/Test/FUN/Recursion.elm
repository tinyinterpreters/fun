module Test.FUN.Recursion exposing (suite)

import Expect
import FUN.Interpreter as I exposing (Value(..))
import Test exposing (Test, describe, test)


suite : Test
suite =
    describe "Recursion via self-application" <|
        [ test "makedouble" <|
            \_ ->
                I.run makedouble
                    |> Expect.equal (Ok <| VNumber <| double 100)
        , test "makemult" <|
            \_ ->
                I.run makemult
                    |> Expect.equal (Ok <| VNumber <| mult 3 7)
        , test "makefact" <|
            \_ ->
                I.run makefact
                    |> Expect.equal (Ok <| VNumber <| fact 5)
        , test "makefib" <|
            \_ ->
                I.run makefib
                    |> Expect.equal (Ok <| VNumber <| fib 10)
        ]



-- Recursion in Elm


double : Int -> Int
double n =
    if n == 0 then
        0

    else
        2 + double (n - 1)


mult : Int -> Int -> Int
mult a b =
    if b == 0 then
        0

    else
        a + mult a (b - 1)


fact : Int -> Int
fact n =
    if n == 0 then
        1

    else
        n * fact (n - 1)


fib : Int -> Int
fib n =
    if n == 0 then
        0

    else if n == 1 then
        1

    else
        fib (n - 1) + fib (n - 2)



-- Self-application in FUN


makedouble : String
makedouble =
    """
    let
        makedouble =
            fun (self)
                fun (n)
                    if zero?(n) then
                        0
                    else
                        -(2, -(0, ((self self) -(n, 1))))
    in
    let
        double = (makedouble makedouble)
    in
    (double 100)
    """


makemult : String
makemult =
    """
    let
        makemult =
            fun (self)
                fun (a)
                    fun (b)
                        if zero?(b) then
                            0
                        else
                            -(a, -(0, (((self self) a) -(b, 1))))
    in
    let
        mult = (makemult makemult)
    in
    ((mult 3) 7)
    """


makefact : String
makefact =
    """
    let
        makemult =
            fun (self)
                fun (a)
                    fun (b)
                        if zero?(b) then
                            0
                        else
                            -(a, -(0, (((self self) a) -(b, 1))))
    in
    let
        mult = (makemult makemult)
    in
    let
        makefact =
            fun (self)
                fun (n)
                    if zero?(n) then
                        1
                    else
                        ((mult n) ((self self) -(n, 1)))
    in
    let
        fact = (makefact makefact)
    in
    (fact 5)
    """


makefib : String
makefib =
    """
    let
        makefib =
            fun (self)
                fun (n)
                    if zero?(n) then
                        0
                    else if zero?(-(n, 1)) then
                        1
                    else
                        -(((self self) -(n, 1)), -(0, ((self self) -(n, 2))))
    in
    let
        fib = (makefib makefib)
    in
    (fib 10)
    """
