module UrlJoin exposing
    ( urlJoin
    , urlJoinNoSlash
    )


ensureEndsWith : String -> String -> String
ensureEndsWith x xs =
    if
        String.endsWith x xs
    then
        xs
    else
        xs ++ x

ensureDoesntEndWith : String -> String -> String
ensureDoesntEndWith x xs =
    if
        String.endsWith x xs
    then
        ensureDoesntEndWith x <|
            String.dropRight (String.length x) xs
    else
        xs


ensureDoesntStartWith : String -> String -> String
ensureDoesntStartWith x xs =
    if
        String.startsWith x xs
    then
        ensureDoesntStartWith x <|
            String.dropLeft (String.length x) xs
    else
        xs


{-| Join two urls, making sure that the resulting
url ends with a slash.
-}
urlJoin : String -> String -> String
urlJoin left right =
    let
        left_ = ensureEndsWith "/" left
        right_ = ensureDoesntStartWith "/" right
    in
        ensureEndsWith "/" <| left_ ++ right_

{-| Join two urls, but make sure the resulting Url
never ends in a slash.
-}
urlJoinNoSlash : String -> String -> String
urlJoinNoSlash left right =
    let
        left_ = ensureEndsWith "/" left
        right_ = ensureDoesntStartWith "/" right
    in
        ensureDoesntEndWith "/" <| left_ ++ right_
