module View.Component exposing (Header, componentNavbar, viewHeader)

-- I need to rename this!

import Element exposing (Color, Element, fill, height, width)
import Element.Background as Background
import Element.Events as Events
import Element.Font as Font
import Routes exposing (Route(..))
import UiFramework exposing (WithContext)
import UiFramework.ColorUtils as ColorUtils
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
        (\context ->
            Container.jumbotron
                |> Container.withFullWidth
                |> Container.withChild (Container.simple [] jumbotronContent)
                |> Container.withExtraAttributes [ Background.color context.purpleColor ]
                |> Container.view
        )


componentNavbar : (Route -> msg) -> Route -> WithContext c msg
componentNavbar navigateToMsg route =
    UiFramework.uiColumn
        [ Element.spacing 16 ]
    <|
        List.map
            (\( r, name ) ->
                if r == route then
                    Typography.textSmall [ Element.pointer ] (text name)

                else
                    Typography.textSmall
                        [ Font.color (ColorUtils.hexToColor "#99979c")
                        , Element.mouseOver [ Font.color (ColorUtils.hexToColor "#8e869d") ]
                        , Element.pointer
                        , Events.onClick (navigateToMsg r)
                        ]
                        (text name)
            )
            routeNameList


routeNameList : List ( Route, String )
routeNameList =
    [ ( Button, "Button" )
    , ( Alert, "Alert" )
    , ( Badge, "Badge" )
    , ( Container, "Container" )
    , ( Dropdown, "Dropdown" )
    , ( Icon, "Icon" )
    , ( Navbar, "Navbar" )
    , ( Pagination, "Pagination" )
    , ( Table, "Table" )
    , ( Toasty, "Toasty" )
    , ( Typography, "Typography" )
    ]
