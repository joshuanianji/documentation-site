module View.Component exposing (Header, componentNavbar, viewHeader)

import Element exposing (Color, Element, fill, height, width)
import Element.Background as Background
import Element.Font as Font
import Routes exposing (Route)
import UiFramework exposing (WithContext)
import UiFramework.Container as Container
import UiFramework.Typography as Typography
import Util exposing (text)


type alias Header =
    { title : String
    , description : String
    }


viewHeader : Header -> WithContext { c | purpleColor : Color } msg
viewHeader pageContent =
    let
        jumbotronContent =
            UiFramework.uiColumn
                [ height fill
                , width fill
                , Element.spacing 16
                , Font.color (Element.rgb 1 1 1)
                ]
                [ Typography.display4 [] <|
                    UiFramework.uiParagraph [] [ text pageContent.title ]
                , UiFramework.uiParagraph []
                    [ Typography.textLead [] <| text pageContent.description ]
                ]
    in
    UiFramework.flatMap
        (\c ->
            Container.jumbotron
                |> Container.withFullWidth
                |> Container.withChild (Container.simple [] jumbotronContent)
                |> Container.withExtraAttributes [ Background.color c.purpleColor ]
                |> Container.view
        )


componentNavbar : Route -> WithContext c msg
componentNavbar route =
    UiFramework.uiColumn
        [ width fill, height fill ]
        [ text "button lol" ]
