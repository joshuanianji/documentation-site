module Routes exposing (Route(..), fromUrl, toUrlString, urlParser)

import Url
import Url.Parser as Url


type Route
    = Home
    | GettingStarted
    | NotFound
    | Button



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
        ]
