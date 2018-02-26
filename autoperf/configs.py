"""
Copyright 2018 Mejbah ul Alam mejbah.alam@gmail.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

"""


#number of perf counter/columns
NUMBER_OF_COUNTERS= 37 #16 #30#32 #6 #12 #16 #19 #33
NUMBER_OF_HIDDEN_LAYER_TO_SEARCH=3
#SCALE_UP_FACTOR=1000000
#SCALE_UP_FACTOR=1000
SCALE_UP_FACTOR=1
TRAINING_EPOCHS=100
TRAINING_BATCH_SIZE=100
MAX_COUNTERS=33
#PERCENT_SAMPLE_FOR_ANOMALY=0.01 # 1% of tatal sample counts
PERCENT_SAMPLE_FOR_ANOMALY= 0.002  #0.003 # 1% of tatal sample counts

NETWORK_CONFIGS = {

  "exp1" : [ 12, (9,'relu'), (8, 'relu'),('tied',9), ('tied',12)],
}


MODEL_SAVED_FILE_NAME = "trained_network"

def generateHiddenLayerConfigs( inputLen, activation ):
  max = inputLen - 1
  min = inputLen/2
  listOfHiddenNetworks = []
  for hiddenNode in range(min, max+1):
    nextTuple = (hiddenNode,activation)
    listOfHiddenNetworks.append(nextTuple)

  return listOfHiddenNetworks


def getNextKeyID():
  return len(NETWORK_CONFIGS) + 1

def setNetworkConfigs( networkPrefix, networkSuffix, inputLen, startID=None ): #startID can be set using  getNextKeyID() 
  if startID==None:
    NETWORK_CONFIGS.clear() ##clear the exisitng dict
    startID = 1
  newLayers = generateHiddenLayerConfigs( inputLen, 'relu' )
  currID = startID
  for layer in newLayers:
    key = 'exp' + str(currID)
    currID += 1
    newNetwork = []
    newNetwork.extend(networkPrefix)
    newNetwork.append(layer)
    newNetwork.extend(networkSuffix)
    NETWORK_CONFIGS[key] = newNetwork



def getEncodeLen(prefix):
    return prefix[-1][0] #first element of last tuple of prefix  

def getNetworkPrefix( networkConfig, numberofLayer ):
  return networkConfig[:numberofLayer]

def getNetworkSuffix( networkConfig, numberOfLayer ):
  suffix = networkConfig[(0-numberOfLayer):]
  middleNodeNumber = suffix[0][0]
  modifiedTuple = ('tied', middleNodeNumber )
  suffix[0] = modifiedTuple
  return suffix

if __name__ == "__main__" :
   inputLen = 16
   networkPrefix = [ inputLen ]
   networkSuffix = [ ('tied', inputLen) ]

   setNetworkConfigs( networkPrefix, networkSuffix, inputLen, 1 )
  
   for key in NETWORK_CONFIGS:
    print key
    print NETWORK_CONFIGS[key]
    print getNetworkSuffix(NETWORK_CONFIGS[key],2)



  
