{-# LANGUAGE OverloadedStrings #-}

module Data.Hjq where

import Data.Attoparsec.Text
import Data.Hjq.Parser
import Data.Hjq.Query
import Data.Text

-- パースを実行する関数
-- テストからフィルタ文字列のパーサが書けるので本格的に実装
parseJqFilter :: Text -> Either Text JqFilter
parseJqFilter s =
  showParseResult $
    parse (jqFilterParser <* endOfInput) s `feed` ""