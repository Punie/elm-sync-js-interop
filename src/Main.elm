module Main exposing (..)

import Browser
import Html exposing (Html, text, div, h1, img)
import Html.Attributes exposing (src)
import Json.Decode as D


---- MODEL ----


type alias Model =
    {}

init : Fs -> ( Model, Cmd Msg )
init { read, write } =
  let
    fileReader = read
    fileWriter = write
    -- res = readFileAt fileReader "/test.txt"
    -- _ = Debug.log "res" res
    -- res2 = readFileAt fileReader "/test.tt"
    -- _ = Debug.log "res" res2
    res = writeFileAt fileWriter "/test.tt" "Look ma, written in elm"
    _ = Debug.log "res" res
    res2 = readFileAt fileReader "/test.tt"
    _ = Debug.log "res" res2
  in
    ( {}, Cmd.none )

readFileAt : D.Value -> String -> ReadResult
readFileAt fileReader path =
  let
    res = D.decodeValue (D.field path contentsOrError) fileReader
  in
    case res of
      Err ioerr -> Err <| Error path "EIO"
      Ok readResult -> readResult
      -- |> Result.withDefault (D.fail (Error path "EIO" >> Err))

writeFileAt fileWriter path content =
  let
    res = D.decodeValue (D.field path (D.field content D.bool)) fileWriter
  in
    res


contentsOrError =
  D.oneOf [
    D.map Ok D.string
  , D.map Err error
  ]

type alias ReadResult = Result Error Contents

type alias Error = { path : String, code : Code }
type alias Contents = String
type alias Code = String

error : D.Decoder Error
error = D.map2 Error
  (D.field "path" D.string)
  (D.field "code" D.string)
---- UPDATE ----


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ img [ src "/logo.svg" ] []
        , h1 [] [ text "Your Elm App is working!" ]
        ]


type alias Fs = {read : D.Value, write : D.Value}
type alias Flags = {fs : Fs}
---- PROGRAM ----


main : Program Flags Model Msg
main =
    Browser.element
        { view = view
        , init = .fs >> init
        , update = update
        , subscriptions = always Sub.none
        }
