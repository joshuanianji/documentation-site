module Page.Alert exposing (Context, Model, Msg(..), init, update, view)

{-| Alert component
-}

import Browser.Navigation as Navigation
import Element exposing (Color, Element, fill, height, spacing, width)
import Routes
import SharedState exposing (SharedState, SharedStateUpdate(..))
import UiFramework exposing (UiContextual, WithContext, toElement)
import UiFramework.Alert as Alert
import UiFramework.Container as Container
import UiFramework.Types exposing (Role(..))
import UiFramework.Typography as Typography
import Util
import View.Component exposing (componentNavbar, viewHeader)



-- UIFRAMEWORK TYPE


type alias UiElement msg =
    WithContext Context msg



-- MODEL


type alias Model =
    {}


init : ( Model, Cmd Msg )
init =
    ( {}, Cmd.none )



-- Context


type alias Context =
    { purpleColor : Color }


toContext : SharedState -> UiContextual Context
toContext sharedState =
    { device = sharedState.device
    , parentRole = Nothing
    , themeConfig = SharedState.getThemeConfig sharedState.theme
    , purpleColor = sharedState.purpleColor
    }



-- VIEW


view : SharedState -> Model -> Element Msg
view sharedState model =
    UiFramework.uiColumn
        [ width fill, height fill ]
        [ viewHeader
            { title = "Alert"
            , description = "Fancy info"
            }
        , Container.simple
            [ Element.paddingXY 0 64 ]
          <|
            UiFramework.uiRow [ width fill ]
                [ Container.simple
                    [ width <| Element.fillPortion 1
                    , height fill
                    ]
                  <|
                    componentNavbar NavigateTo Routes.Alert
                , Container.simple [ width <| Element.fillPortion 6 ] <| content
                ]
        ]
        |> UiFramework.toElement (toContext sharedState)


content : UiElement Msg
content =
    UiFramework.uiColumn
        [ width fill
        , spacing 64
        ]
        [ basicExample
        , configuration
        ]


basicExample : UiElement Msg
basicExample =
    UiFramework.uiColumn
        [ spacing 16
        , width fill
        ]
        [ Typography.h1 [] (Util.text "Basic Example")
        , UiFramework.uiParagraph []
            [ Util.text "Alerts are available in 8 different roles and are available for any length of text" ]
        , UiFramework.uiColumn
            [ Element.spacing 8
            , width fill
            ]
          <|
            List.map
                (\( role, name ) ->
                    Alert.simple role (Util.text name)
                )
                rolesAndNames
        , basicExampleCode
        ]


basicExampleCode : UiElement Msg
basicExampleCode =
    """
import Element
import UiFramework
import UiFramework.Alert as Alert

text : String -> WithContext context msg
text str =
    UiFramework.uiText (\\_ -> str)

UiFramework.uiColumn 
    [ Element.spacing 8
    , Element.width Element.fill
    ] 
    [ Alert.simple Primary (text "Primary role!")
    , Alert.simple Secondary (text "Secondary role!")
    , Alert.simple Success (text "Success role!")
    , Alert.simple Info (text "Info role!")
    , Alert.simple Warning (text "Warning role!")
    , Alert.simple Danger (text "Danger role!")
    , Alert.simple Light (text "Light role!")
    , Alert.simple Dark (text "Dark role!")
    ]"""
        |> Util.highlightCode "elm"
        |> (\elem -> \_ -> elem)
        |> UiFramework.fromElement


configuration : UiElement Msg
configuration =
    UiFramework.uiColumn
        [ spacing 48
        , width fill
        ]
        [ UiFramework.uiColumn
            [ spacing 16 ]
            [ Typography.h1 [] (Util.text "Configurations")
            , UiFramework.uiParagraph []
                [ Util.text "Alerts come with a range of configurations." ]
            ]
        , sizeConfigs
        ]


sizeConfigs : UiElement Msg
sizeConfigs =
    UiFramework.uiColumn
        [ spacing 16
        , width fill
        ]
        [ Typography.h1 [] (Util.text "Sizing")
        , UiFramework.uiParagraph []
            [ Util.text "There are three sizes available to alerts." ]
        , UiFramework.uiColumn
            [ Element.spacing 8
            , width fill
            ]
            [ Alert.default
                |> Alert.withLarge
                |> Alert.withChild (Util.text "Large alert!")
                |> Alert.view
            , Alert.simple Primary (Util.text "Default alert!")
            , Alert.default
                |> Alert.withSmall
                |> Alert.withChild (Util.text "Small alert!")
                |> Alert.view
            ]
        , sizingCode
        ]


sizingCode : UiElement Msg
sizingCode =
    """
text : String -> WithContext context msg
text str =
    UiFramework.uiText (\\_ -> str)


-- when configuring, we'll build upon `Alert.default`, which creates an `Alert` type with default options
-- To convert the `Alert` type to a `UiElement msg` type, we need to use `Alert.view`.

content : UiElement Msg 
content = 
    UiFramework.uiColumn 
        [ Element.spacing 8
        , Element.width Element.fill ] 
        [ Alert.default 
            |> Alert.withLarge
            |> Alert.withChild (text "Large alert!")
            |> Alert.view
        , Alert.simple Primary (text "Default alert!")
        , Alert.default 
            |> Alert.withSmall
            |> Alert.withChild (text "Small alert!")
            |> Alert.view
        ]"""
        |> Util.highlightCode "elm"
        |> (\elem -> \_ -> elem)
        |> UiFramework.fromElement


rolesAndNames : List ( Role, String )
rolesAndNames =
    [ ( Primary, "Primary" )
    , ( Secondary, "Secondary" )
    , ( Success, "Success" )
    , ( Info, "Info" )
    , ( Warning, "Warning" )
    , ( Danger, "Danger" )
    , ( Light, "Light" )
    , ( Dark, "Dark" )
    ]



-- UPDATE


type Msg
    = NoOp
    | NavigateTo Routes.Route


update : SharedState -> Msg -> Model -> ( Model, Cmd Msg, SharedStateUpdate )
update sharedState msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none, NoUpdate )

        NavigateTo route ->
            ( model, Navigation.pushUrl sharedState.navKey (Routes.toUrlString route), NoUpdate )
