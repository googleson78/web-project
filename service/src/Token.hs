{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE UndecidableInstances #-}

{-# OPTIONS_GHC -fno-warn-orphans #-}

module Token
  ( Token, genToken
  ) where

import Control.Monad.IO.Class (MonadIO(..))
import Crypto.Random (MonadRandom(..))
import Data.Hashable (Hashable)
import Data.Text (Text)
import qualified Data.ByteString as BS
import qualified Data.Text.Encoding as Text
import Servant (MimeRender, PlainText)

newtype Token = Token Text
  deriving newtype (Eq, Ord, Hashable, MimeRender PlainText)

genToken :: MonadIO m => m Token
genToken = liftIO $ Token . Text.decodeUtf8 .  BS.map ((+ 65) . (`rem` 26)) <$> getRandomBytes 32
