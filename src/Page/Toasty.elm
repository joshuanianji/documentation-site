module Page.Toasty exposing (Context, Model, Msg(..), init, update, view)

{-| Alert component
-}

import Element exposing (Color, Element, fill, height, spacing, width)
import Routes
import SharedState exposing (SharedState, SharedStateUpdate(..))
import UiFramework exposing (UiContextual, WithContext, toElement)
import UiFramework.Container as Container
import UiFramework.Toasty as Toasty
import UiFramework.Types exposing (Role(..))
import UiFramework.Typography as Typography
import Util
import View.Component as Component exposing (componentNavbar, viewHeader)



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
            { title = "Toasty"
            , description = "Used to be called Bready!"
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
                    componentNavbar NavigateTo Routes.Toasty
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
        [ gettingStarted
        , basicExample
        ]


gettingStarted : UiElement Msg
gettingStarted =
    UiFramework.uiColumn
        [ width fill
        , Element.spacing 32
        ]
        [ Component.title "Getting Started"
        , Component.wrappedText "We use the module pablen/toasty to use toasties."
        , installToastyCode
        ]


basicExample : UiElement Msg
basicExample =
    UiFramework.uiColumn
        [ width fill
        , Element.spacing 32
        ]
        [ Component.title "Basic Example"
        , Component.wrappedText "Toasties require a fair bit of setup, and they need a css file to work (https://github.com/pablen/toasty/blob/master/src/Toasty/Defaults.css), so here's a simple but fully functional bit of code that shows a toasty when a button is clicked. "
        , toastyElmCode
        , Component.wrappedText "Include the Toasty css file in your project and include the path in the Html file."
        , toastyHtmlCode
        , Component.wrappedText "When finished, run this command in the root repository!"
        , elmLiveCode
        ]


installToastyCode : UiElement Msg
installToastyCode =
    """
elm install pablen/toasty"""
        |> Util.uiHighlightCode "bash"


toastyElmCode : UiElement Msg
toastyElmCode =
    """
module Main exposing (main)

import Browser
import Browser.Events
import Element exposing (Device)
import Html exposing (Html)
import UiFramework
import UiFramework.Configuration exposing (ThemeConfig, defaultThemeConfig)
import UiFramework.ResponsiveUtils exposing (classifyDevice)
import UiFramework.Toasty
import Toasty.Defaults
import UiFramework.Button as Button
import Toasty


main : Program Flags Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


-- We can model our toasties however we want, but we're going to use a simple string.
-- we have to wrap our toasties in a Stack


type alias Model =
    { toasties : Toasty.Stack Toasty.Defaults.Toast
    , device : Device
    , theme : ThemeConfig
    }



type alias Flags =
    WindowSize


type alias WindowSize =
    { width : Int
    , height : Int
    }

-- initialize out toasty states

init : Flags -> (Model, Cmd Msg)
init flags =
    ( { toasties = Toasty.initialState
      , device = classifyDevice flags
      , theme = defaultThemeConfig
      }
    , Cmd.none)



-- toggle is when the navbar collapses the menu


type Msg 
    = WindowSizeChange WindowSize
    | ToastyMsg (Toasty.Msg Toasty.Defaults.Toast)
    | ShowToasty Toasty.Defaults.Toast
    | NoOp



-- toasty configuration


myToastyConfig : Toasty.Config msg
myToastyConfig =
    Toasty.config
        |> Toasty.transitionOutDuration 100
        |> Toasty.delay 2000



update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of 
        WindowSizeChange windowSize ->
            ( { model | device = classifyDevice windowSize}
            , Cmd.none 
            )
        
        ToastyMsg subMsg ->
            Toasty.update myToastyConfig ToastyMsg subMsg model
        
        ShowToasty toasty ->
            ( model, Cmd.none )
                |> Toasty.addToast myToastyConfig ToastyMsg toasty
        
        NoOp ->
            ( model, Cmd.none )


view : Model -> Html Msg 
view model =
    let
        context =
            { device = model.device
            , parentRole = Nothing
            , themeConfig = model.theme
            }
    in
    Button.simple (ShowToasty <| Toasty.Defaults.Success "Success!" "Aww yeah!") "Show Toasty" 
        |> UiFramework.toElement context
        -- show our toasties using "infront" so as not to disturb the layout
        |> Element.layout 
            [ Element.inFront <| UiFramework.Toasty.view ToastyMsg model.toasties ]



-- subscribe to window changes


subscriptions : Model -> Sub Msg
subscriptions _ =
    Browser.Events.onResize
        (\\x y ->
            WindowSizeChange (WindowSize x y)
        )"""
        |> Util.uiHighlightCode "elm"


toastyHtmlCode : UiElement Msg
toastyHtmlCode =
    """
<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <title>Toasty Example</title>
    <link rel="stylesheet" href="path/to/toasty-default.css">
</head>

<body>
    <div id="elm"></div>
    <script src="elm.js"></script>
    <script>
        var app = Elm.Main.init({
            node: document.getElementById('elm'),
            flags: {
                height: window.innerHeight,
                width: window.innerWidth
            }
        })
    </script>
</body>

</html>"""
        |> Util.uiHighlightCode "html"


elmLiveCode : UiElement Msg
elmLiveCode =
    """
elm-live [PATH/TO/Main.elm] -- --output=elm.js"""
        |> Util.uiHighlightCode "bash"



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
            ( model, Util.navigate sharedState.navKey route, NoUpdate )
