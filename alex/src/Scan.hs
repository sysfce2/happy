{-# OPTIONS -cpp #-}
module Scan(lexer, Posn(..), Token(..), Tkn(..), tokPosn) where

import Data.Char
import Debug.Trace
#if __GLASGOW_HASKELL__ >= 503
import Data.Array
#else
import Array
#endif
alex_base :: Array Int Int
alex_base = listArray (0,72) [-8,110,139,115,-2,153,-4,6,2,7,-32,-31,11,0,247,140,0,-19,-16,0,77,-26,123,365,479,370,128,144,-25,218,336,554,577,124,445,0,0,648,762,603,820,905,989,1050,1164,1278,1392,1389,1474,1558,1619,0,78,510,170,395,-24,0,396,679,397,398,-23,0,-100,0,0,0,0,1703,1787,0,0]

alex_table :: Array Int Int
alex_table = listArray (0,2042) [0,4,4,4,4,4,-1,4,4,4,4,4,-1,6,6,16,64,64,16,19,26,54,60,-1,4,-1,17,13,40,47,4,0,13,13,13,13,13,11,13,13,36,36,36,36,36,36,36,36,36,36,0,13,67,0,0,13,7,23,23,23,23,23,23,23,23,23,23,23,23,23,23,23,23,23,23,23,23,23,23,23,23,23,23,13,14,13,13,-1,-1,23,23,23,23,23,23,23,23,23,23,23,23,23,23,23,23,23,23,23,23,23,23,23,23,23,23,15,13,13,13,5,5,5,5,5,4,4,4,4,4,8,8,8,8,-1,-1,22,-1,0,-1,52,0,0,5,0,0,0,0,4,4,4,4,4,4,0,-1,12,0,0,0,0,10,0,5,5,5,5,5,0,20,0,0,4,33,33,33,33,33,33,33,33,-1,22,0,71,10,5,22,68,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,0,0,0,72,22,0,69,69,69,69,69,69,69,69,69,69,69,69,69,69,69,69,69,69,69,69,69,69,69,69,69,69,0,52,0,65,0,66,69,69,69,69,69,69,69,69,69,69,69,69,69,69,69,69,69,69,69,69,69,69,69,69,69,69,0,0,0,-1,29,29,29,29,29,29,29,29,29,29,-1,0,-1,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,30,30,30,30,30,30,30,30,30,30,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,34,35,35,35,35,35,35,35,35,32,35,35,35,35,35,35,25,25,25,25,25,25,25,25,25,25,29,29,29,29,29,29,29,29,29,29,0,0,0,25,0,0,0,0,25,0,24,-1,-1,-1,-1,0,28,0,0,24,24,24,24,24,24,24,24,24,24,21,0,0,0,0,21,0,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,52,58,58,58,24,0,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,25,25,25,25,25,33,33,33,33,33,33,33,33,0,0,0,0,0,0,0,0,0,0,25,0,0,0,0,0,0,24,53,53,53,53,53,28,0,0,24,24,24,24,24,24,24,24,24,24,21,0,0,0,0,53,0,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,0,51,0,0,24,0,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,31,31,31,31,31,31,31,31,31,31,53,53,53,53,53,0,0,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,53,0,0,0,0,0,0,31,31,31,31,31,31,56,0,0,31,31,31,31,31,31,53,53,53,53,53,0,0,51,0,0,0,0,0,0,0,0,0,31,31,31,31,31,31,53,0,0,0,0,0,0,38,59,59,59,59,59,56,0,0,38,38,38,38,38,38,38,38,38,38,0,0,0,51,0,59,0,38,38,38,38,38,38,38,38,38,38,38,38,38,38,38,38,38,38,38,38,38,38,38,38,38,38,0,57,0,0,38,0,38,38,38,38,38,38,38,38,38,38,38,38,38,38,38,38,38,38,38,38,38,38,38,38,38,38,53,53,53,53,53,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,53,0,0,0,0,0,0,38,0,0,0,0,0,56,0,0,38,38,38,38,38,38,38,38,38,38,0,0,0,51,0,0,0,38,38,38,38,38,38,38,38,38,38,38,38,38,38,38,38,38,38,38,38,38,38,38,38,38,38,0,0,0,0,38,0,38,38,38,38,38,38,38,38,38,38,38,38,38,38,38,38,38,38,38,38,38,38,38,38,38,38,37,37,37,37,37,37,37,37,37,37,37,37,37,37,37,37,37,37,37,37,37,37,37,37,37,37,0,0,0,0,0,0,37,37,37,37,37,37,37,37,37,37,37,37,37,37,37,37,37,37,37,37,37,37,37,37,37,37,43,42,0,0,0,0,0,0,0,0,42,42,42,42,42,42,42,42,42,42,0,0,0,0,0,0,0,42,42,42,42,42,42,42,42,42,42,42,42,42,42,42,42,42,42,42,42,42,42,42,42,42,42,0,0,0,0,42,0,42,42,42,42,42,42,42,42,42,42,42,42,42,42,42,42,42,42,42,42,42,42,42,42,42,42,42,0,39,0,0,0,0,0,0,42,42,42,42,42,42,42,42,42,42,0,0,0,0,0,0,0,42,42,42,42,42,42,42,42,42,42,42,42,42,42,42,42,42,42,42,42,42,42,42,42,42,42,0,0,0,0,42,0,42,42,42,42,42,42,42,42,42,42,42,42,42,42,42,42,42,42,42,42,42,42,42,42,42,42,0,0,39,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,0,0,0,0,0,0,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,59,59,59,59,59,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,59,0,0,0,0,0,0,45,0,0,0,0,0,62,0,0,45,45,45,45,45,45,45,45,45,45,0,0,0,57,0,0,0,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,0,0,0,0,45,0,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,59,59,59,59,59,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,59,0,0,0,0,0,0,45,0,0,0,0,0,62,0,0,45,45,45,45,45,45,45,45,45,45,0,0,0,57,0,0,0,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,0,0,0,0,45,0,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,59,59,59,59,59,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,59,0,0,0,0,0,0,0,0,0,0,0,0,62,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,57,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,0,0,0,0,0,0,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,50,49,0,0,0,0,0,0,0,0,49,49,49,49,49,49,49,49,49,49,0,0,0,0,0,0,0,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,0,0,0,0,49,0,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,0,46,0,0,0,0,0,0,49,49,49,49,49,49,49,49,49,49,0,0,0,0,0,0,0,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,0,0,0,0,49,0,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,0,0,46,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,0,0,0,0,0,0,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,70,0,0,0,0,0,0,0,0,70,70,70,70,70,70,70,70,70,70,0,0,0,0,0,0,0,70,70,70,70,70,70,70,70,70,70,70,70,70,70,70,70,70,70,70,70,70,70,70,70,70,70,0,0,0,0,70,0,70,70,70,70,70,70,70,70,70,70,70,70,70,70,70,70,70,70,70,70,70,70,70,70,70,70,70,0,0,0,0,0,0,0,0,70,70,70,70,70,70,70,70,70,70,0,0,0,0,0,0,0,70,70,70,70,70,70,70,70,70,70,70,70,70,70,70,70,70,70,70,70,70,70,70,70,70,70,0,0,0,0,70,0,70,70,70,70,70,70,70,70,70,70,70,70,70,70,70,70,70,70,70,70,70,70,70,70,70,70,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]

alex_check :: Array Int Int
alex_check = listArray (0,2042) [-1,9,10,11,12,13,10,9,10,11,12,13,10,45,45,34,10,10,34,45,45,45,45,123,32,125,34,35,36,37,32,-1,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,-1,59,60,-1,-1,63,45,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,10,10,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,9,10,11,12,13,9,10,11,12,13,123,123,125,125,10,123,58,125,-1,10,61,-1,-1,32,-1,-1,-1,-1,32,9,10,11,12,13,-1,10,45,-1,-1,-1,-1,45,-1,9,10,11,12,13,-1,45,-1,-1,32,48,49,50,51,52,53,54,55,10,58,-1,44,45,32,58,48,48,49,50,51,52,53,54,55,56,57,-1,-1,-1,62,58,-1,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,-1,61,-1,123,-1,125,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,-1,-1,-1,125,48,49,50,51,52,53,54,55,56,57,123,-1,125,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,9,10,11,12,13,9,10,11,12,13,48,49,50,51,52,53,54,55,56,57,-1,-1,-1,32,-1,-1,-1,-1,32,-1,39,10,10,10,10,-1,45,-1,-1,48,49,50,51,52,53,54,55,56,57,58,-1,-1,-1,-1,58,-1,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,61,61,61,61,95,-1,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,9,10,11,12,13,48,49,50,51,52,53,54,55,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,32,-1,-1,-1,-1,-1,-1,39,9,10,11,12,13,45,-1,-1,48,49,50,51,52,53,54,55,56,57,58,-1,-1,-1,-1,32,-1,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,-1,61,-1,-1,95,-1,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,48,49,50,51,52,53,54,55,56,57,9,10,11,12,13,-1,-1,65,66,67,68,69,70,48,49,50,51,52,53,54,55,56,57,32,-1,-1,-1,-1,-1,-1,65,66,67,68,69,70,45,-1,-1,97,98,99,100,101,102,9,10,11,12,13,-1,-1,61,-1,-1,-1,-1,-1,-1,-1,-1,-1,97,98,99,100,101,102,32,-1,-1,-1,-1,-1,-1,39,9,10,11,12,13,45,-1,-1,48,49,50,51,52,53,54,55,56,57,-1,-1,-1,61,-1,32,-1,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,-1,61,-1,-1,95,-1,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,9,10,11,12,13,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,32,-1,-1,-1,-1,-1,-1,39,-1,-1,-1,-1,-1,45,-1,-1,48,49,50,51,52,53,54,55,56,57,-1,-1,-1,61,-1,-1,-1,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,-1,-1,-1,-1,95,-1,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,-1,-1,-1,-1,-1,-1,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,39,-1,-1,-1,-1,-1,-1,-1,-1,48,49,50,51,52,53,54,55,56,57,-1,-1,-1,-1,-1,-1,-1,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,-1,-1,-1,-1,95,-1,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,39,-1,125,-1,-1,-1,-1,-1,-1,48,49,50,51,52,53,54,55,56,57,-1,-1,-1,-1,-1,-1,-1,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,-1,-1,-1,-1,95,-1,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,-1,-1,125,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,-1,-1,-1,-1,-1,-1,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,9,10,11,12,13,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,32,-1,-1,-1,-1,-1,-1,39,-1,-1,-1,-1,-1,45,-1,-1,48,49,50,51,52,53,54,55,56,57,-1,-1,-1,61,-1,-1,-1,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,-1,-1,-1,-1,95,-1,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,9,10,11,12,13,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,32,-1,-1,-1,-1,-1,-1,39,-1,-1,-1,-1,-1,45,-1,-1,48,49,50,51,52,53,54,55,56,57,-1,-1,-1,61,-1,-1,-1,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,-1,-1,-1,-1,95,-1,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,9,10,11,12,13,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,32,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,45,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,61,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,-1,-1,-1,-1,-1,-1,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,39,-1,-1,-1,-1,-1,-1,-1,-1,48,49,50,51,52,53,54,55,56,57,-1,-1,-1,-1,-1,-1,-1,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,-1,-1,-1,-1,95,-1,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,39,-1,125,-1,-1,-1,-1,-1,-1,48,49,50,51,52,53,54,55,56,57,-1,-1,-1,-1,-1,-1,-1,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,-1,-1,-1,-1,95,-1,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,-1,-1,125,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,-1,-1,-1,-1,-1,-1,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,39,-1,-1,-1,-1,-1,-1,-1,-1,48,49,50,51,52,53,54,55,56,57,-1,-1,-1,-1,-1,-1,-1,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,-1,-1,-1,-1,95,-1,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,39,-1,-1,-1,-1,-1,-1,-1,-1,48,49,50,51,52,53,54,55,56,57,-1,-1,-1,-1,-1,-1,-1,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,-1,-1,-1,-1,95,-1,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1]

alex_deflt :: Array Int Int
alex_deflt = listArray (0,72) [-1,64,-1,-1,-1,64,8,9,8,9,-1,-1,64,-1,-1,63,-1,18,18,-1,27,-1,27,-1,-1,-1,27,27,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,55,-1,55,55,-1,-1,61,-1,61,61,-1,-1,64,-1,-1,-1,-1,-1,-1,-1,-1]

alex_accept = listArray (0::Int,72) [[],[],[],[],[(Acc 0 (skip ) Nothing Nothing)],[(Acc 0 (skip ) Nothing Nothing)],[(Acc 0 (skip ) Nothing Nothing)],[(Acc 0 (skip ) Nothing Nothing)],[(Acc 0 (skip ) Nothing Nothing)],[(Acc 0 (skip ) Nothing Nothing)],[],[(Acc 1 (special ) Nothing Nothing)],[(Acc 15 (code ) Nothing Nothing)],[(Acc 1 (special ) Nothing Nothing)],[(Acc 1 (special ) Nothing Nothing)],[(Acc 2 (brace ) Nothing Nothing)],[(Acc 3 (string ) Nothing Nothing)],[],[],[(Acc 4 (bind ) Nothing Nothing)],[(Acc 4 (bind ) Nothing Nothing)],[],[],[(Acc 9 (char ) Nothing Nothing)],[],[],[],[],[],[(Acc 5 (decch ) Nothing Nothing)],[(Acc 5 (decch ) Nothing Nothing)],[(Acc 6 (hexch ) Nothing Nothing)],[(Acc 8 (escape ) Nothing Nothing)],[(Acc 7 (octch ) Nothing Nothing)],[(Acc 8 (escape ) Nothing Nothing)],[(Acc 8 (escape ) Nothing Nothing)],[(Acc 9 (char ) Nothing Nothing)],[(Acc 10 (smac ) Nothing Nothing)],[(Acc 10 (smac ) Nothing Nothing)],[(Acc 10 (smac ) Nothing Nothing)],[],[],[],[],[(Acc 11 (rmac ) Nothing Nothing)],[(Acc 11 (rmac ) Nothing Nothing)],[(Acc 11 (rmac ) Nothing Nothing)],[],[],[],[],[(Acc 12 (smacdef ) Nothing Nothing)],[(Acc 12 (smacdef ) Nothing Nothing)],[],[],[],[],[(Acc 13 (rmacdef ) Nothing Nothing)],[(Acc 13 (rmacdef ) Nothing Nothing)],[],[],[],[],[(Acc 14 (begin incode nest_code ) Nothing Nothing)],[(Acc 15 (code ) Nothing Nothing)],[(Acc 16 (nest_code ) Nothing Nothing)],[(Acc 17 (unnest_code ) Nothing Nothing)],[(Acc 18 (begin startcodes special ) Nothing Nothing)],[(Acc 19 (zero ) Nothing Nothing)],[(Acc 20 (startcode ) Nothing Nothing)],[(Acc 20 (startcode ) Nothing Nothing)],[(Acc 21 (special ) Nothing Nothing)],[(Acc 22 (begin 0 special ) Nothing Nothing)]]
-- -----------------------------------------------------------------------------
-- Token type

data Token = T Posn Tkn
  deriving Show

tokPosn (T p _) = p

data Tkn
 = SpecialT Char
 | CodeT String
 | ZeroT
 | IdT String
 | StringT String
 | BindT String
 | CharT Char
 | SMacT String
 | RMacT String  
 | SMacDefT String
 | RMacDefT String  
 | NumT Int	
 deriving Show

-- -----------------------------------------------------------------------------
-- Token functions

special = mk_act (\p ln str -> T p (SpecialT  (head str)))
brace   = mk_act (\p ln str -> T p (SpecialT  '\123'))
zero    = mk_act (\p ln str -> T p ZeroT)
string  = mk_act (\p ln str -> T p (StringT (extract ln str)))
bind    = mk_act (\p ln str -> T p (BindT (takeWhile isIdChar str)))
escape  = mk_act (\p ln str -> T p (CharT (esc str)))
decch   = mk_act (\p ln str -> T p (CharT (do_ech 10 ln str)))
hexch   = mk_act (\p ln str -> T p (CharT (do_ech 16 ln str)))
octch   = mk_act (\p ln str -> T p (CharT (do_ech 8  ln str)))
char    = mk_act (\p ln str -> T p (CharT (head str)))
smac    = mk_act (\p ln str -> T p (SMacT (mac ln str)))
rmac    = mk_act (\p ln str -> T p (RMacT (mac ln str)))
smacdef = mk_act (\p ln str -> T p (SMacDefT (macdef ln str)))
rmacdef = mk_act (\p ln str -> T p (RMacDefT (macdef ln str)))
startcode = mk_act (\p ln str -> T p (IdT (take ln str)))

isIdChar c = isAlphaNum c || c `elem` "_'"

skip p c input len cont scs = 
  -- trace ("skip: " ++ take len input) $
  cont scs

-- begin a new startcode
begin startcode tok p c input len cont (_,s) = 
  tok p c input len cont (startcode,s)

-- the state is the level of brace nesting in code
nest_code p c input len cont (sc,(0,_)) =
  cont (sc,(1,""))
nest_code p c input len cont (sc,(state,so_far)) =
  -- trace ("incode " ++ show state) $
  cont (sc,(state+1,'\123':so_far))  -- TODO \123 = open brace

code p c inp len cont (sc,(n,so_far)) = 
  -- trace "code" $
  cont (sc,(n, reverse (take len inp) ++ so_far))

unnest_code p c input len cont (sc,(1,so_far)) =
  T p (CodeT (reverse so_far)) : cont (0,(0,""))
unnest_code p c input len cont (sc,(n,so_far)) =
  cont (incode,(n-1,'\125':so_far))  -- TODO \125 = close brace

stop p c "" scs   = []
stop p c rest scs = error "lexical error" -- TODO

mk_act ac = \p _ str len cont st -> ac p len str:cont st

extract ln str = take (ln-2) (tail str)
		
do_ech radix ln str = chr (parseInt radix (take (ln-1) (tail str)))

mac ln (_ : str) = take (ln-1) str

macdef ln (_ : str) = takeWhile (not.isSpace) str

esc (_ : x : _)  =
 case x of
   'a' -> '\a'
   'b' -> '\b'
   'f' -> '\f'
   'n' -> '\n'
   'r' -> '\r'
   't' -> '\t'
   'v' -> '\v'
   c   ->  c

parseInt :: Int -> String -> Int
parseInt radix ds = foldl1 (\n d -> n * radix + d) (map digitToInt ds)

lexer :: String -> [Token]
lexer = gscan stop (0::Int,"")

incode,startcodes :: Int
incode = 1
startcodes = 2
{-# LINE 1 "GenericTemplate.hs" #-}
{-# LINE 13 "GenericTemplate.hs" #-}























{-# LINE 56 "GenericTemplate.hs" #-}

indexShortOffAddr arr off = arr ! off


-- -----------------------------------------------------------------------------
-- Token positions

-- `Posn' records the location of a token in the input text.  It has three
-- fields: the address (number of chacaters preceding the token), line number
-- and column of a token within the file. `start_pos' gives the position of the
-- start of the file and `eof_pos' a standard encoding for the end of file.
-- `move_pos' calculates the new position after traversing a given character,
-- assuming the usual eight character tab stops.

data Posn = Pn !Int !Int !Int
	deriving (Eq,Show)

start_pos:: Posn
start_pos = Pn 0 1 1

eof_pos:: Posn
eof_pos = Pn (-1) (-1) (-1)

move_pos:: Posn -> Char -> Posn
move_pos (Pn a l c) '\t' = Pn (a+1)  l     (((c+7) `div` 8)*8+1)
move_pos (Pn a l c) '\n' = Pn (a+1) (l+1)   1
move_pos (Pn a l c) _    = Pn (a+1)  l     (c+1)


type GStopAction s r = Posn -> Char -> String -> (StartCode,s) -> r

--gscan :: GStopAction s r -> s -> String -> r
--gscan':: GStopAction s r -> Posn -> Char -> String -> (StartCode,s) -> r

gscan stop s inp = gscan' stop start_pos '\n' inp (0,s)

gscan' stop p c inp sc_s =
	case scan_token sc_s p c inp of
	  Nothing -> stop p c inp sc_s
	  Just (p',c',inp',len,Acc _ t_a _ _) ->
		t_a p c inp len (gscan' stop p' c' inp') sc_s

{------------------------------------------------------------------------------
				  scan_token
------------------------------------------------------------------------------}

-- `scan_token' picks out the next token from the input.  It takes the DFA and
-- the usual parameters and returns the `Accept' structure associated with the
-- highest priority token matching the longest input sequence, nothing if no
-- token matches.  Associated with `Accept' in `Sv' is the length of the token
-- as well as the position, previous character and remaining input at the end
-- of accepted token (i.e., the start of the next token).

type Sv t = (Posn,Char,String,Int,Accept t)

--scan_token:: (StartCode,s) -> Posn -> Char -> String -> Maybe (Sv f)
scan_token ((startcode),_) p c inp
 = scan_tkn p c inp (0) startcode Nothing
		-- the startcode is the initial state

-- This function performs most of the work of `scan_token'.  It pushes
-- the input through the DFA, remembering the most recent accepting
-- states it encountered.

--scan_tkn:: Posn -> Char -> String -> Int -> SNum -> Maybe (Sv f) -> Maybe (Sv f)
scan_tkn p c inp len ((-1)) stk = 





	stk  	-- error or finished

scan_tkn p c inp len s stk =
  case inp of
    [] -> 



	stk'	-- end of input

    (c':inp') -> 



	stk' `seq` scan_tkn p' c' inp' (len + (1)) s' stk'
      	where
		p' = move_pos p c'

		base   = indexShortOffAddr alex_base s
		(ord_c) = ord c'
		offset = (base + ord_c)
		check  = indexShortOffAddr alex_check offset
	
		s' = 
		     if (offset >= (0)) && (check == ord_c)
			then indexShortOffAddr alex_table offset
			else indexShortOffAddr alex_deflt s
   where
	svs  =	[ (p,c,inp,(len),acc)
		| acc <- alex_accept!(s),
		  check_ctx acc ]

	stk' = case svs of
		[]     -> stk
		(x:xs) -> Just x

	check_ctx (Acc _ _ lctx rctx) = chk_lctx lctx && chk_rctx rctx
		where
		chk_lctx Nothing   = True
		chk_lctx (Just st) = st!c

		chk_rctx Nothing   = True
		chk_rctx (Just ((sn))) = 
			case scan_tkn p c inp (0) sn Nothing of
				Nothing -> False
				Just _  -> True
			-- TODO: there's no need to find the longest
			-- match when checking the right context, just
			-- the first match will do.

type SNum = Int

data Accept a = Acc Int a (Maybe (Array Char Bool)) (Maybe SNum)

type StartCode = Int
