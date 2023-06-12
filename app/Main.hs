
module Main where

{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

import           Data.Aeson            (Value)
import qualified Data.ByteString.Char8 as S8
import qualified Data.ByteString.Lazy.Char8 as L8
import qualified Data.Yaml             as Yaml
import           Network.HTTP.Client
import GHC.Generics


data Project = Project {
        pSelf :: String
      , pId :: Int
      , pKey :: String
      , pName :: String 
      , projectTypeKey :: String } deriving (Generic, Show)

data Fields = Fields {
        fTimespent :: Maybe String
      , fProject :: Project
      , fAssignee :: Maybe String } deriving (Generic, Show)

data Issue = Issue {
        iId :: String
      , issSelf :: String
      , iKey :: String
      , iFields :: Fields  } deriving (Generic, Show)

instance Yaml.FromJSON Issue
instance Yaml.ToJSON Issue

instance Yaml.FromJSON Fields
instance Yaml.ToJSON Fields

instance Yaml.FromJSON Project
instance Yaml.ToJSON Project

main :: IO ()
main = do
    let jiraUrl = "http://localhost:9600"
    let restUrl = "/rest/api/2/issue/"

    manager <- newManager defaultManagerSettings

    let reqIni = parseRequest_ (jiraUrl ++ restUrl ++ "AAA-2")
    let req = applyBasicAuth (S8.pack "admin") (S8.pack "admin") reqIni

    response <- httpLbs req manager    

    putStrLn $ "The status code was: " ++
               show (responseStatus response)
    
    let headers = responseHeaders response
    let respBody = responseBody response
    
    S8.putStrLn $ Yaml.decode (respBody)

    responseClose response

    


