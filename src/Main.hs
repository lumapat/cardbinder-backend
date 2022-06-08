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

graphql "ServiceDefinition" "schema.graphql"

-- GraphQL App

main :: IO ()
main = do
  putStrLn "starting GraphQL server on port 8080"
  runGraphQLAppQuery 8080 server (Proxy @"Query")

type ServiceMapping = '[]

server :: MonadServer m => ServerT ServiceMapping i ServiceDefinition m _
server = resolver ( object @"Query" ( method @"hello" $ pure "Hooooooray" ) )