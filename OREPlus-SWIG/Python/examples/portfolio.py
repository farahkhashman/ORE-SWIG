
# Copyright (C) 2018 Quaternion Risk Manaement Ltd
# All rights reserved.

from OREPlus import *
import xml.etree.ElementTree as ET

print ("Loading parameters...")
params = Parameters()
print ("   params is of type", type(params))
params.fromFile("Input/ore.xml")
print ("   setup/asofdate = " + params.get("setup","asofDate"))

print ("Building ORE App...")
ore = ORE(params)
print ("   ore is of type", type(ore))

print ("Running ORE process...");
# Run it all 
# ore.run()
# Run bootstraps only (conventions, curve configuration, construction)
ore.buildMarket()

print ("Retrieve market object from ORE...");
market = ore.getMarket()
print ("   retrieved market is of type", type(market))
asof = market.asofDate();
print ("   retrieved market's asof date is", asof)


pfolio = Portfolio()
pfolioFile = "C:\Apps\Dev\ExodusPoint\oreswig\OREPlus-SWIG\Python\examples\Input\portfolio.xml"
pfolioXml = ET.parse(pfolioFile).getroot()
pfolioXmlStr = ET.tostring(pfolioXml,encoding="unicode")
pfolio.loadFromXMLString(pfolioXmlStr)
print("loaded pfolio from xml string (not built yet)")
engineFact = ore.buildEngineFactoryFromXMLString(market, "")
pfolio.build(engineFact)
print("build portfolio using engine factory")

print("   full portfolio is of type", type(pfolio))
pfolioSize = pfolio.size()
print("...pfolio.size() is of type", type(pfolioSize))
print("... pfolio size = ", str(pfolioSize))
tradesVec = pfolio.trades()
print("trade vec is of type ", type(tradesVec))
for trn in tradesVec:
    print(trn)
    print(" trn is of type ", type(trn))
    print(" trade id = ", trn.id())
    print(" trade type is ", trn.tradeType())
    print(" trade notional is ", trn.notional())
    pgInst = trn.instrument()
    print(" inst type is ", type(pgInst))
    trnPv = pgInst.NPV()
    print(" instWrap pv = ", str(trnPv))
    #legPg = trn.legs()
    #print(" legsVec is of type ", type(legPg))

#pg end