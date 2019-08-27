module Page.Button exposing (Context, Model, Msg(..), init, update, view)

{-| Button component
-}

import Element exposing (Color, Element, fill, height, width)
import Element.Background as Background
import Element.Font as Font
import Routes
import SharedState exposing (SharedState, SharedStateUpdate(..))
import UiFramework exposing (UiContextual, WithContext, fromElement, toElement)
import UiFramework.Button as Button
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
            { title = "Buttons"
            , description = "Click Click Click Click Click Click Click Click Click Click"
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
                    componentNavbar NavigateTo Routes.Button
                , Container.simple [ width <| Element.fillPortion 6 ] <| content sharedState
                ]
        ]
        |> UiFramework.toElement (toContext sharedState)


content : SharedState -> UiElement Msg
content sharedState =
    UiFramework.uiColumn
        [ width fill
        , Element.spacing 64
        ]
        [ basicButtons
        , buttonRoles
        , buttonRolesCode
        , Typography.h1 [] (Util.text "Module Code")
        , moduleCode
        ]


basicButtons : UiElement Msg
basicButtons =
    UiFramework.uiColumn
        [ width fill
        , Element.spacing 32
        ]
        [ Typography.h1 [] (Util.text "Basic Buttons")
        , UiFramework.uiParagraph []
            [ Util.text "Default options for the buttons are as follows:" ]
        , UiFramework.uiWrappedRow
            [ Element.spacing 4 ]
            [ Button.simple NoOp "Default" ]
        ]



-- showing the 6 predefined roles and such


buttonRoles : UiElement Msg
buttonRoles =
    UiFramework.uiColumn
        [ width fill
        , Element.spacing 32
        ]
        [ Typography.h1 [] (Util.text "Basic Buttons")
        , UiFramework.uiParagraph []
            [ Util.text "Bootstrap offers 6 roles for a button, as well as a \"light\" and \"dark\" role." ]
        , UiFramework.uiWrappedRow
            [ Element.spacing 4 ]
            (List.map
                (\( role, name ) ->
                    Button.default
                        |> Button.withLabel name
                        |> Button.withRole role
                        |> Button.view
                )
                rolesAndNames
            )
        ]


buttonRolesCode : UiElement Msg
buttonRolesCode =
    """
UiFramework.uiRow 
    [ Element.spacing 4 ] 
    (List.map
        (\\( role, name ) ->
            Button.default
                |> Button.withLabel name
                |> Button.withRole role
                |> Button.view
        )
        rolesAndNames
    )

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
    ]"""
        |> Util.uiHighlightCode "elm"


moduleCode : UiElement Msg
moduleCode =
    """
module Main exposing (main)

import Html exposing (..)
import Bootstrap.CDN as CDN
import Bootstrap.Grid as Grid


main =
    Grid.container []
        [ CDN.stylesheet -- creates an inline style node with the Bootstrap CSS
        , Grid.row []
            [ Grid.col []
                [ text "Some content for my view here..."]
            ]

        ]"""
        |> Util.uiHighlightCode "elm"


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
            ( model, Util.navigate sharedState.navKey route, NoUpdate )
