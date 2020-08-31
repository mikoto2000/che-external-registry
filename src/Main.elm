module Main exposing (Model, Msg(..), Stack, default_che_base_url, init, main, openshift_base_url, to_anchor, update, view)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import Http
import Json.Decode exposing (Decoder, field, list, map2, string)
import List
import String



-- MAIN


main =
    Browser.element { init = init, update = update, view = view, subscriptions = subscriptions }



-- MODEL


openshift_base_url =
    "https://che.openshift.io"


default_che_base_url =
    openshift_base_url


che_path =
    "f"


che_query_string_prefix =
    "?url="


type alias Stack =
    { name : String
    , url : String
    }



-- サポートスタックのリスト


type alias Model =
    { che_base_url : String, filter_text : String, stacks : List Stack }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model default_che_base_url "" [], get_stacks )



-- UPDATE


type Msg
    = ChangeCheUrl String
    | ChangeFilterText String
    | GotStacks (Result Http.Error (List Stack))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeCheUrl new_che_base_url ->
            ( { model | che_base_url = new_che_base_url }, Cmd.none )

        ChangeFilterText new_filter_text ->
            ( { model | filter_text = new_filter_text }, Cmd.none )

        GotStacks result ->
            case result of
                Ok got_stacks ->
                    ( { model | stacks = got_stacks }, Cmd.none )

                Err _ ->
                    ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    let
        filtered_stacks =
            List.filter (\s -> String.contains model.filter_text s.name) model.stacks
    in
    div []
        [ div []
            [ text "Che URL: "
            , input [ value model.che_base_url, onInput ChangeCheUrl, Html.Attributes.list "che_base_url" ] []
            , datalist [ id "che_base_url" ] [ option [ value openshift_base_url ] [] ]
            ]
        , div []
            [ text "Filter: "
            , input [ onInput ChangeFilterText ] []
            , datalist [ id "che_base_url" ] [ option [ value openshift_base_url ] [] ]
            ]
        , div []
            [ ul []
                (List.map2 to_anchor (List.repeat (List.length filtered_stacks) model.che_base_url) filtered_stacks)
            ]
        ]


to_anchor : String -> Stack -> Html Msg
to_anchor che_base_url stack =
    li []
        [ a [ href (che_base_url ++ "/" ++ che_path ++ che_query_string_prefix ++ stack.url) ] [ text stack.name ] ]



-- HTTP


get_stacks : Cmd Msg
get_stacks =
    Http.get
        { url = "./stacks.json"
        , expect = Http.expectJson GotStacks stackListDecoder
        }


stackListDecoder : Decoder (List Stack)
stackListDecoder =
    Json.Decode.list stackDecoder


stackDecoder : Decoder Stack
stackDecoder =
    map2 Stack
        (field "name" string)
        (field "url" string)
