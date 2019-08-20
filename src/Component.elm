module Component exposing (ComponentContextual, PageContent)

{-| Data structure for a Component page
-}

import Element exposing (Color, Element, fill, height, width)
import Element.Background as Background
import Element.Font as Font
import UiFramework exposing (UiContextual, WithContext)
import UiFramework.Container as Container
import UiFramework.Typography as Typography


{-| Stores data about page. I might delte this
-}
type alias PageContent msg =
    { title : String
    , description : String
    , child : Element msg
    }



-- i just need a purple color so I made this extendable record to make sure of that


type alias ComponentContextual c =
    { c | purpleColor : Color }
