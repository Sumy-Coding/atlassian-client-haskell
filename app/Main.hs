
module Main where

{-# LANGUAGE OverloadedStrings #-}

import           Data.Aeson            (Value)
import qualified Data.ByteString.Char8 as S8
import qualified Data.ByteString.Lazy.Char8 as L8
import qualified Data.Yaml             as Yaml
import           Network.HTTP.Client


main :: IO ()
main = do
    let url = "http://localhost:9600/rest/api/2/issue/AAA-2"

    manager <- newManager defaultManagerSettings

    let reqIni = parseRequest_ url
    let req = applyBasicAuth (S8.pack "admin") (S8.pack "admin") reqIni

    response <- httpLbs req manager    

    putStrLn $ "The status code was: " ++
               show (responseStatus response)
    
    let headers = responseHeaders response

    L8.putStrLn $ responseBody response

    responseClose response
