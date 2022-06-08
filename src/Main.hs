{-# language DataKinds             #-}
{-# language FlexibleContexts      #-}
{-# language OverloadedStrings     #-}
{-# language PartialTypeSignatures #-}
{-# language PolyKinds             #-}
{-# language ScopedTypeVariables   #-}
{-# language TemplateHaskell       #-}
{-# language TypeApplications      #-}
{-# language TypeFamilies          #-}
{-# language TypeOperators         #-}
{-# OPTIONS_GHC -fno-warn-partial-type-signatures #-}

module Main where

import           Data.Proxy

import           Mu.GraphQL.Quasi
import           Mu.GraphQL.Server
import           Mu.Server
import           Network.Wai.Handler.Warp (run)
import           Network.Wai.Middleware.Cors
import           Network.Wai.Middleware.RequestLogger (logStdoutDev)

graphql "ServiceDefinition" "schema.graphql"

-- GraphQL App

customCors = cors (const $ Just policy)
  where
    policy = simpleCorsResourcePolicy
      { corsRequestHeaders = ["Authorization", "Content-Type"]
      , corsMethods = simpleMethods ++ ["OPTIONS"]
      }

main :: IO ()
main = do
  putStrLn "Starting GraphQL server on port 8080"
  run 8080 $ customCors $ logStdoutDev $ graphQLAppQuery server (Proxy @"Query")

type ServiceMapping = '[]

server :: MonadServer m => ServerT ServiceMapping i ServiceDefinition m _
server = resolver ( object @"Query" ( method @"hello" $ pure "Hooooooray" ) )