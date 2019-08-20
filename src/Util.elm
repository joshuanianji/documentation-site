module Util exposing (firacode, highlightCode, text)

{-| code from <https://github.com/rundis/elm-bootstrap.info/blob/master/src/Util.elm>
-}

import Element exposing (Attribute, Element)
import Element.Font as Font
import Html
import Html.Attributes as Attr
import Markdown
import UiFramework exposing (WithContext)


text : String -> WithContext context msg
text str =
    UiFramework.uiText (\_ -> str)


highlightCode : String -> String -> Element msg
highlightCode language code =
    Markdown.toHtml
        []
        ("```" ++ language ++ code ++ "```")
        |> List.singleton
        |> Html.div
            [ Attr.style "width" "100%"
            ]
        |> Element.html


firacode : Attribute msg
firacode =
    Font.family
        [ Font.typeface "Fira Code"
        , Font.serif
        ]
