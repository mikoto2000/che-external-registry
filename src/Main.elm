module Main exposing (Model, Msg(..), Stack, default_che_base_url, init, main, openshift_base_url, stacks, to_anchor, update, view)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import Http
import Json.Decode exposing (Decoder, field, string)
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


stacks =
    [ { name = "ruby"
      , url = "https://gist.githubusercontent.com/mikoto2000/0a52ed7fdf9c5df25ce69c370350f7ed/raw/31b8a75c8c15db478c7ea8677ac2f5b9aab49f70/vscode-ruby-devfile.yaml"
      }
    , { name = "toppers-asp3"
      , url = "https://gist.githubusercontent.com/mikoto2000/9a23d15240571445ab96d025c0130479/raw/13d0b2d9cf4af80d58bf8db57995bf3c033e5f67/toppers-asp3-devfile.yaml"
      }
    , { name = "toppers-asp3-in-zig"
      , url = "https://gist.githubusercontent.com/mikoto2000/9a23d15240571445ab96d025c0130479/raw/13d0b2d9cf4af80d58bf8db57995bf3c033e5f67/toppers-asp3-in-zig-devfile.yaml"
      }
    , { name = "toppers-atk2-rh850f1x"
      , url = "https://gist.githubusercontent.com/mikoto2000/9a23d15240571445ab96d025c0130479/raw/eada0c71f0c58390897c76b1fc63ee35c59d369b/toppers-atk2-rh850f1x-devfile.yaml"
      }
    , { name = "toppers-atk2-zcu102"
      , url = "https://gist.githubusercontent.com/mikoto2000/9a23d15240571445ab96d025c0130479/raw/eada0c71f0c58390897c76b1fc63ee35c59d369b/toppers-atk2-zcu102-devfile.yaml"
      }
    , { name = "toppers-fmp3-zybo-z7"
      , url = "https://gist.githubusercontent.com/mikoto2000/9a23d15240571445ab96d025c0130479/raw/9f679079ce6338bf2c21fb8a7f9000540587929f/toppers-fmp3-zybo-z7-devfile.yaml"
      }
    , { name = "toppers-fmp3-zcu102"
      , url = "https://gist.githubusercontent.com/mikoto2000/9a23d15240571445ab96d025c0130479/raw/9f679079ce6338bf2c21fb8a7f9000540587929f/toppers-fmp3-zcu102-devfile.yaml"
      }
    , { name = "toppers-hrp3"
      , url = "https://gist.githubusercontent.com/mikoto2000/9a23d15240571445ab96d025c0130479/raw/aec298e2f32847dd078fa90612b66913feb11223/toppers-hrp3-devfile.yaml"
      }
    , { name = "toppers-hrmp3"
      , url = "https://gist.githubusercontent.com/mikoto2000/9a23d15240571445ab96d025c0130479/raw/aec298e2f32847dd078fa90612b66913feb11223/toppers-hrmp3-devfile.yaml"
      }
    , { name = "toppers-cfg"
      , url = "https://gist.githubusercontent.com/mikoto2000/9a23d15240571445ab96d025c0130479/raw/8ebfb35770ab9f5a79e988817ca641fb96e97725/toppers-cfg-devfile.yaml"
      }
    ]


type alias Model =
    { che_base_url : String, filter_text : String }


init : () -> (Model, Cmd Msg)
init _ =
    (Model default_che_base_url "", Cmd.none)



-- UPDATE


type Msg
    = ChangeCheUrl String
    | ChangeFilterText String


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        ChangeCheUrl new_che_base_url ->
            ({ model | che_base_url = new_che_base_url }, Cmd.none)
        ChangeFilterText new_filter_text ->
            ({ model | filter_text = new_filter_text }, Cmd.none)


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none


-- VIEW


view : Model -> Html Msg
view model =
    let
        filtered_stacks = List.filter (\s -> String.contains model.filter_text s.name) stacks
    in
        div []
            [ div []
                [ text "Che URL: "
                , input [ value model.che_base_url, onInput ChangeCheUrl, list "che_base_url" ] []
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

