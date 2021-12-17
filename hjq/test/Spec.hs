{-# LANGUAGE OverloadedStrings #-}

module Main where

import Data.Hjq.Parser
import Data.Hjq.Query
import Test.HUnit

main :: IO ()
main = do
  runTestTT $
    TestList
      [ jqFilterParserTest
      -- テストケースが増えたらここに追加していく
      ]
  return ()

-- これから実装するparseJqFilterの動作を決めるため、はじめにテストを書く
jqFilterParserTest :: Test
jqFilterParserTest =
  TestList
    [ "jqFilterParser test 1"
        ~: parseJqFilter "." ~?= Right JqNil, -- .が来たらJqNil
      "jqFilterParser test 2"
        ~: parseJqFilter ".[0]" ~?= Right (JqIndex 0 JqNil), -- .[0]が来たらJqIndex 0 JqNil
      "jqFilterParser test 3"
        ~: parseJqFilter ".fieldName" ~?= Right (JqField "fieldName" JqNil),
      "jqFilterParser test 4"
        ~: parseJqFilter ".[0].fieldName" ~?= Right (JqIndex 0 (JqField "fieldName" JqNil)),
      "jqFilterParser test 5"
        ~: parseJqFilter ".fieldName[0]" ~?= Right (JqField "fieldName" (JqIndex 0 JqNil))
    ]