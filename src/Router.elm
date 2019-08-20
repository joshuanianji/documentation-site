module Router exposing (DropdownMenuState(..), Model, Msg(..), Page(..), init, initWith, navigateTo, update, updateWith, viewApplication)

import Browser exposing (UrlRequest(..))
import Browser.Navigation as Nav
import Element exposing (Element)
import Element.Background as Background
import Element.Events as Events
import Element.Font as Font
import FontAwesome.Styles
import Html exposing (Html)
import Page.Button as Button
import Page.GettingStarted as GettingStarted
import Page.Home as Home
import Page.NotFound as NotFound
import Routes exposing (Route(..))
import SharedState exposing (SharedState, SharedStateUpdate, Theme(..))
import Task
import Themes.Darkly exposing (darklyThemeConfig)
import Themes.Materia exposing (materiaThemeConfig)
import UiFramework exposing (WithContext, toElement)
import UiFramework.Configuration exposing (defaultThemeConfig)
import UiFramework.Navbar as Navbar
import UiFramework.Types exposing (Role(..))
import Url



-- UiFramework Type


type alias UiElement msg =
    WithContext Context msg


type alias Context =
    {}



-- MODEL


type alias Model =
    { route : Routes.Route
    , currentPage : Page
    , navKey : Nav.Key
    , dropdownMenuState : DropdownMenuState
    , toggleMenuState : Bool
    }


type Page
    = HomePage Home.Model
    | GettingStartedPage GettingStarted.Model
    | ButtonPage Button.Model
    | NotFoundPage NotFound.Model


type DropdownMenuState
    = AllClosed
    | ThemeSelectOpen



-- init with the NotFoundPage, but send a command where we look at the Url and change the page


init : Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init url key =
    let
        currentRoute =
            Routes.fromUrl url
    in
    ( { route = currentRoute
      , currentPage = NotFoundPage {}
      , navKey = key
      , dropdownMenuState = AllClosed
      , toggleMenuState = False
      }
    , (Task.perform identity << Task.succeed) <| UrlChanged url
    )



-- VIEW


viewApplication : (Msg -> msg) -> Model -> SharedState -> Browser.Document msg
viewApplication toMsg model sharedState =
    { title = tabBarTitle model
    , body =
        [ FontAwesome.Styles.css
        , view toMsg model sharedState
        ]
    }



-- title of our app (shows in tab bar)


tabBarTitle : Model -> String
tabBarTitle model =
    case model.currentPage of
        HomePage _ ->
            "Home"

        GettingStartedPage _ ->
            "Getting Started"

        ButtonPage _ ->
            "Button"

        NotFoundPage _ ->
            "Not Found"


view : (Msg -> msg) -> Model -> SharedState -> Html msg
view toMsg model sharedState =
    let
        themeConfig =
            SharedState.getThemeConfig sharedState.theme
    in
    Element.el
        [ Element.width Element.fill
        , Element.height Element.fill
        , Background.color themeConfig.bodyBackground
        , Font.color <| themeConfig.fontColor themeConfig.bodyBackground
        , Element.paddingXY 0 50
        , Font.family themeConfig.fontConfig.fontFamily
        ]
        (content model sharedState)
        |> Element.layout
            [ Element.inFront <| navbar model sharedState
            , Font.family themeConfig.fontConfig.fontFamily
            ]
        |> Html.map toMsg


navbar : Model -> SharedState -> Element Msg
navbar model sharedState =
    let
        navbarState =
            { toggleMenuState = model.toggleMenuState
            , dropdownState = model.dropdownMenuState
            }

        context =
            { device = sharedState.device
            , themeConfig = SharedState.getThemeConfig sharedState.theme
            , parentRole = Nothing
            }

        brand =
            Element.row
                [ Events.onClick (NavigateTo Home)
                , Element.pointer
                ]
                [ Element.text "Elm Ui Bootstrap" ]

        homeItem =
            Navbar.linkItem (NavigateTo GettingStarted)
                |> Navbar.withMenuTitle "Getting Started"

        buttonsItem =
            Navbar.linkItem (NavigateTo Button)
                |> Navbar.withMenuTitle "Modules"

        examplesItem =
            Navbar.linkItem NoOp
                |> Navbar.withMenuTitle "Examples"
    in
    Navbar.default ToggleMenu
        |> Navbar.withBrand brand
        |> Navbar.withBackground Light
        |> Navbar.withMenuItems
            [ homeItem
            , buttonsItem
            , examplesItem
            ]
        |> Navbar.withExtraAttrs []
        |> Navbar.view navbarState
        |> UiFramework.toElement context


content : Model -> SharedState -> Element Msg
content model sharedState =
    case model.currentPage of
        HomePage pageModel ->
            Home.view sharedState pageModel
                |> Element.map HomeMsg

        GettingStartedPage pageModel ->
            GettingStarted.view sharedState pageModel
                |> Element.map GettingStartedMsg

        ButtonPage pageModel ->
            Button.view sharedState pageModel
                |> Element.map ButtonMsg

        NotFoundPage pageModel ->
            NotFound.view sharedState pageModel
                |> Element.map NotFoundMsg



-- UPDATE


type Msg
    = UrlChanged Url.Url
    | NavigateTo Route
    | HomeMsg Home.Msg
    | GettingStartedMsg GettingStarted.Msg
    | ButtonMsg Button.Msg
    | NotFoundMsg NotFound.Msg
    | SelectTheme Theme
    | ToggleDropdown
    | ToggleMenu
    | NoOp


update : SharedState -> Msg -> Model -> ( Model, Cmd Msg, SharedStateUpdate )
update sharedState msg model =
    case ( msg, model.currentPage ) of
        ( UrlChanged url, _ ) ->
            let
                route =
                    Routes.fromUrl url

                ( newModel, newCmd, newSharedStateUpdate ) =
                    navigateTo route sharedState model
            in
            ( { newModel | route = route }
            , newCmd
            , newSharedStateUpdate
            )

        ( NavigateTo route, _ ) ->
            -- changes url
            ( model
            , Nav.pushUrl model.navKey
                (Routes.toUrlString route)
            , SharedState.NoUpdate
            )

        ( HomeMsg subMsg, HomePage subModel ) ->
            Home.update sharedState subMsg subModel
                |> updateWith HomePage HomeMsg model

        ( GettingStartedMsg subMsg, GettingStartedPage subModel ) ->
            GettingStarted.update sharedState subMsg subModel
                |> updateWith GettingStartedPage GettingStartedMsg model

        ( ButtonMsg subMsg, ButtonPage subModel ) ->
            Button.update sharedState subMsg subModel
                |> updateWith ButtonPage ButtonMsg model

        ( NotFoundMsg subMsg, NotFoundPage subModel ) ->
            NotFound.update sharedState subMsg subModel
                |> updateWith NotFoundPage NotFoundMsg model

        ( SelectTheme theme, _ ) ->
            ( { model | dropdownMenuState = AllClosed }
            , Cmd.none
            , SharedState.UpdateTheme theme
            )

        ( ToggleDropdown, _ ) ->
            let
                dropdownMenuState =
                    if model.dropdownMenuState == ThemeSelectOpen then
                        AllClosed

                    else
                        ThemeSelectOpen
            in
            ( { model | dropdownMenuState = dropdownMenuState }
            , Cmd.none
            , SharedState.NoUpdate
            )

        ( ToggleMenu, _ ) ->
            ( { model | toggleMenuState = not model.toggleMenuState }
            , Cmd.none
            , SharedState.NoUpdate
            )

        ( _, _ ) ->
            -- message arrived for the wrong page. Ignore.
            ( model, Cmd.none, SharedState.NoUpdate )


updateWith :
    (subModel -> Page)
    -> (subMsg -> Msg)
    -> Model
    -> ( subModel, Cmd subMsg, SharedStateUpdate )
    -> ( Model, Cmd Msg, SharedStateUpdate )
updateWith toPage toMsg model ( subModel, subCmd, subSharedStateUpdate ) =
    ( { model | currentPage = toPage subModel }
    , Cmd.map toMsg subCmd
    , subSharedStateUpdate
    )


navigateTo : Route -> SharedState -> Model -> ( Model, Cmd Msg, SharedStateUpdate )
navigateTo route sharedState model =
    case route of
        Home ->
            Home.init |> initWith HomePage HomeMsg model SharedState.NoUpdate

        GettingStarted ->
            GettingStarted.init |> initWith GettingStartedPage GettingStartedMsg model SharedState.NoUpdate

        Button ->
            Button.init |> initWith ButtonPage ButtonMsg model SharedState.NoUpdate

        NotFound ->
            NotFound.init |> initWith NotFoundPage NotFoundMsg model SharedState.NoUpdate


initWith : (subModel -> Page) -> (subMsg -> Msg) -> Model -> SharedStateUpdate -> ( subModel, Cmd subMsg ) -> ( Model, Cmd Msg, SharedStateUpdate )
initWith toPage toMsg model sharedStateUpdate ( subModel, subCmd ) =
    ( { model | currentPage = toPage subModel }
    , Cmd.map toMsg subCmd
    , sharedStateUpdate
    )
