{-# LANGUAGE OverloadedStrings #-}

module Cookies
  ( Cookies
  ) where

import GHC.Generics (Generic)
import Servant (FromHttpApiData(..))
import Token (mkToken, Token)
import Web.Cookie (parseCookies)
import qualified Data.Text.Encoding as Text

data Cookies = Cookies
  { token :: Token }
  deriving stock (Eq, Show, Generic)

instance FromHttpApiData Cookies where
  parseUrlPiece _ = Left "Cookies should only be parsed from headers."
  parseQueryParam _ = Left "Cookies should only be parsed from headers."
  parseHeader bs =
    case parseCookies bs of
      [] -> Left "Invalid cookies provided."
      cookies ->
        case lookup "token" cookies of
          Nothing -> Left "The \"token\" cookies is required."
          Just bsToken ->
            case Text.decodeUtf8' bsToken of
              Left _ -> Left "Tokens should be valid utf8."
              Right decoded ->
                case mkToken decoded of
                  Nothing -> Left "Tokens should be 32 character upper-case english letters."
                  Just token -> Right $ Cookies token
