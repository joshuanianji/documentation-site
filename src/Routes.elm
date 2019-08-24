module Routes exposing (Route(..), fromUrl, toUrlString, urlParser)

import Url
import Url.Parser as Url


type Route
    = Home
    | GettingStarted
    | NotFound
    | Button
    | Alert
    | Badge
    | Container
    | Dropdown
    | Icon
    | Navbar
    | Pagination
    | Table
    | Toasty
    | Typography



-- converts a route to a URL string


toUrlString : Route -> String
toUrlString route =
    let
        pieces =
            case route of
                Home ->
                    []

                GettingStarted ->
                    [ "getting-started" ]

                Button ->
                    [ "button" ]

                Alert ->
                    [ "alert" ]

                Badge ->
                    [ "Badge" ]

                Container ->
                    [ "Container" ]

                Dropdown ->
                    [ "Dropdown" ]

                Icon ->
                    [ "Icon" ]

                Navbar ->
                    [ "Navbar" ]

                Pagination ->
                    [ "Pagination" ]

                Table ->
                    [ "Table" ]

                Toasty ->
                    [ "Toasty" ]

                Typography ->
                    [ "Typography" ]

                NotFound ->
                    [ "oops" ]
    in
    "#/" ++ String.join "/" pieces



-- converts a URL to a route


fromUrl : Url.Url -> Route
fromUrl url =
    { url | path = Maybe.withDefault "" url.fragment, fragment = Nothing }
        |> Url.parse urlParser
        |> Maybe.withDefault NotFound



-- parser to turn a URL into a route


urlParser : Url.Parser (Route -> a) a
urlParser =
    Url.oneOf
        [ Url.map Home Url.top
        , Url.map GettingStarted (Url.s "getting-started")
        , Url.map Button (Url.s "button")
        , Url.map Badge (Url.s "Badge")
        , Url.map Container (Url.s "Container")
        , Url.map Dropdown (Url.s "Dropdown")
        , Url.map Icon (Url.s "Icon")
        , Url.map Navbar (Url.s "Navbar")
        , Url.map Pagination (Url.s "Pagination")
        , Url.map Table (Url.s "Table")
        , Url.map Toasty (Url.s "Toasty")
        , Url.map Typography (Url.s "Typography")
        , Url.map Alert (Url.s "alert")
        ]
