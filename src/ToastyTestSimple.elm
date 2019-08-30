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
        (\x y ->
            WindowSizeChange (WindowSize x y)
        )