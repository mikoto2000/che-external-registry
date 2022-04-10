port module Main exposing (Model, Msg(..), Stack, default_che_base_url, init, main, openshift_base_url, to_table_column, update, view, sendDevfileContentToMonaco)

import Browser
import Browser.Navigation
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Http
import Json.Decode exposing (Decoder, field, list, map2, string)
import List
import String

import SHA512


-- MAIN


main =
    Browser.element { init = init, update = update, view = view, subscriptions = subscriptions }


-- PORT

port sendDevfileContentToMonaco: String -> Cmd msg
port sendDevfileContentToElmModel: (String -> msg) -> Sub msg


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
    { location_origin : String
    , che_base_url : String
    , filter_text : String
    , devfile_content : String
    , stacks : List Stack }


init : String -> ( Model, Cmd Msg )
init locationOrigin =
    ( Model locationOrigin default_che_base_url "" "" [], get_stacks )



-- UPDATE


type Msg
    = ChangeCheUrl String
    | ChangeFilterText String
    | GotStacks (Result Http.Error (List Stack))
    | EditDevfile String
    | ChangeDevfileContent String
    | GotDevfileContent (Result Http.Error String)
    | SendDevfile String String
    | OpenChe (Result Http.Error String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeCheUrl new_che_base_url ->
            ( { model | che_base_url = new_che_base_url }, Cmd.none )

        ChangeFilterText new_filter_text ->
            ( { model | filter_text = new_filter_text }, Cmd.none )

        EditDevfile devfile_url ->
            ( model, get_devfile_content devfile_url )

        ChangeDevfileContent new_devfile_content ->
            ( { model | devfile_content = new_devfile_content }, Cmd.none )

        SendDevfile devfile_content che_base_url ->
            ( model, send_devfile_content devfile_content che_base_url )

        OpenChe result ->
            case result of
                Ok sha256 ->
                    let
                        url = model.che_base_url ++ "/" ++ che_path ++ che_query_string_prefix ++ model.location_origin ++ "/tempfiles/" ++ sha256
                    in
                        ( model, Browser.Navigation.load url )

                Err _ ->
                    ( model, Cmd.none )

        GotDevfileContent result ->
            case result of
                Ok got_devfile_content ->
                    ( { model | devfile_content = got_devfile_content }, sendDevfileContentToMonaco got_devfile_content )

                Err _ ->
                    ( { model | devfile_content = "devfile 取得に失敗しました。" }, Cmd.none )

        GotStacks result ->
            case result of
                Ok got_stacks ->
                    ( { model | stacks = got_stacks }, Cmd.none )

                Err _ ->
                    ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    sendDevfileContentToElmModel ChangeDevfileContent



-- VIEW


view : Model -> Html Msg
view model =
    let
        filtered_stacks =
            List.filter (\s -> String.contains model.filter_text s.name) model.stacks
    in
    div [ id "main" ]
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
            [ table []
                [ tbody []
                    (List.map2 to_table_column (List.repeat (List.length filtered_stacks) model.che_base_url) filtered_stacks)
                ]
            ]
        , div [ id "devfile-area" ]
            [ div [ id "devfile" ] [ ] ]
        , div []
            [ button [ onClick (SendDevfile model.devfile_content model.che_base_url ) ] [ text "Workspace 作成" ] ]
        ]


to_table_column : String -> Stack -> Html Msg
to_table_column che_base_url stack =
    tr []
        [ td [] [ a [ href (che_base_url ++ "/" ++ che_path ++ che_query_string_prefix ++ stack.url), title (che_base_url ++ " で開く") ] [ text stack.name ] ]
        , td [] [ a [ href stack.url, title "devfile" ] [ text "⚙" ] ]
        , td [] [ a [ id "edit_button", title "devfile を編集", onClick (EditDevfile stack.url), style "cursor" "pointer"] [ text "📝" ] ]
        ]



-- HTTP

get_devfile_content : String -> Cmd Msg
get_devfile_content url =
    Http.get
        { url = url
        , expect = Http.expectString GotDevfileContent
        }

send_devfile_content : String -> String -> Cmd Msg
send_devfile_content devfile_content che_base_url =
    let
        sha512 =
            devfile_content
                |> SHA512.fromString
                |> SHA512.toHex
        url = "/tempfiles/" ++ sha512
        body = Http.stringBody "text/plain" devfile_content
    in
        Http.post
            { url = url
            , body = body
            , expect = Http.expectString OpenChe
            }

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
