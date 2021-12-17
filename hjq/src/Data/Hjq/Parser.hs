{-# LANGUAGE OverloadedStrings #-}

module Data.Hjq.Parser where

import Control.Applicative
import Data.Attoparsec.Text
import Data.Text

data JqFilter
  = JqField Text JqFilter
  | JqIndex Int JqFilter
  | JqNil -- フィールド名とインデックスが存在しない場合にも使う
  deriving (Show, Read, Eq)

-- ユーザの入力をパースする
parseJqFilter :: Text -> Either Text JqFilter
parseJqFilter s =
  showParseResult $
    parse (jqFilterParser <* endOfInput) s `feed` ""

schar :: Char -> Parser Char
schar c = skipSpace *> char c <* skipSpace

-- attoparsecを使ってフィルタの文字列をJqFilter型にパース
-- attoparsecについては7章を参照
jqFilterParser :: Parser JqFilter
jqFilterParser = schar '.' >> (jqField <|> jqIndex <|> pure JqNil)
  where
    jqFilter :: Parser JqFilter
    jqFilter =
      (schar '.' >> jqField) <|> jqIndex <|> pure JqNil
    jqField :: Parser JqFilter
    jqField = JqField <$> (word <* skipSpace) <*> jqFilter

    jqIndex :: Parser JqFilter
    jqIndex = JqIndex <$> (schar '[' *> decimal <* schar ']') <*> jqFilter

-- パース結果の表示
showParseResult :: Show a => Result a -> Either Text a
showParseResult (Done _ r) = Right r
showParseResult r = Left . pack $ show r

-- フィールド名などの識別子をパースするパーサ
word :: Parser Text
word = fmap pack $ many1 (letter <|> char '-' <|> char '_' <|> digit)
