{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE UndecidableInstances #-}

{-# OPTIONS_GHC -fno-warn-orphans #-}

module Token
  ( Token, mkToken, genToken
  ) where

import Control.Applicative (Applicative(liftA2))
import Control.Monad.IO.Class (MonadIO(..))
import Crypto.Random (MonadRandom(..))
import Data.Char (isAlpha, isAsciiUpper)
import Data.Hashable (Hashable)
import Data.Text (Text)
import Servant (MimeRender, PlainText)
import qualified Data.ByteString as BS
import qualified Data.Text as Text
import qualified Data.Text.Encoding as Text

newtype Token = Token Text
  deriving newtype (Eq, Show, Ord, Hashable, MimeRender PlainText)

genToken :: MonadIO m => m Token
genToken = liftIO $ Token . Text.decodeUtf8 .  BS.map ((+ 65) . (`rem` 26)) <$> getRandomBytes 32

-- | Smart constructor - we need to check if the token is
-- * 32 characters long
-- * all upper case english letters
mkToken :: Text -> Maybe Token
mkToken str =
  if Text.length str == 32 && Text.all (liftA2 (&&) isAsciiUpper isAlpha) str
  then Just $ Token str
  else Nothing
