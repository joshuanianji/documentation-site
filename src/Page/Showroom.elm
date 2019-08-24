module Page.Showroom exposing (Model, Msg(..), init, update, view)

import Browser.Navigation as Navigation
import Element exposing (DeviceClass(..), Element)
import Element.Font as Font
import Routes exposing (Route)
import SharedState exposing (SharedState, SharedStateUpdate(..), Theme(..))
import UiFramework exposing (UiContextual, WithContext)
import UiFramework.Alert as Alert
import UiFramework.Badge as Badge
import UiFramework.Button as Button
import UiFramework.Container as Container
import UiFramework.Navbar as Navbar exposing (NavbarState)
import UiFramework.Pagination as Pagination exposing (Item(..), PaginationState)
import UiFramework.Table as Table
import UiFramework.Types exposing (Role(..))
import UiFramework.Typography as Typography



-- UIFRAMEWORK TYPE


type alias UiElement msg =
    WithContext Context msg



-- MODEL


type alias Model =
    { paginationState : PaginationState
    , primaryNavState : NavState
    , darkNavState : NavState
    , lightNavState : NavState
    }


type alias NavState =
    NavbarState DropdownState


type DropdownState
    = LmaoIDontHaveDropdowns


init : ( Model, Cmd Msg )
init =
    ( { paginationState = initPaginationState
      , primaryNavState = initNavState
      , darkNavState = initNavState
      , lightNavState = initNavState
      }
    , Cmd.none
    )


initPaginationState =
    { currentSliceNumber = 0 -- starts from 0
    , numberOfSlices = 10
    }


initNavState =
    { toggleMenuState = False
    , dropdownState = LmaoIDontHaveDropdowns
    }



-- Context


type alias Context =
    {}


toContext : SharedState -> UiContextual Context
toContext sharedState =
    { device = sharedState.device
    , parentRole = Nothing
    , themeConfig = SharedState.getThemeConfig sharedState.theme
    }



-- VIEW


text : String -> UiElement Msg
text str =
    UiFramework.uiText (\_ -> str)


view : SharedState -> Model -> Element Msg
view sharedState model =
    Container.default
        |> Container.withChild
            (UiFramework.uiColumn
                [ Element.paddingXY 0 64
                , Element.width Element.fill
                , Element.spacing 64
                ]
                [ text "bruh" ]
            )
        |> Container.view
        |> UiFramework.toElement (toContext sharedState)



-- UPDATE


type Msg
    = NoOp


update : SharedState -> Msg -> Model -> ( Model, Cmd Msg, SharedStateUpdate )
update sharedState msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none, NoUpdate )
