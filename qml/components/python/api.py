# -*- coding: utf-8 -*-

import pyotherside
import threading
import time
import random
import requests

USER_AGENT = "XBMC Addon Radio"
BASE = "http://rad.io/info"

recomendedURL = "{0}/broadcast/editorialreccomendationsembedded".format(BASE)
top100URL = "{0}/menu/broadcastsofcategory".format(BASE)
searchURL = "{0}/index/searchembeddedbroadcast".format(BASE)
categoriesURL = "{0}/menu/valuesofcategory".format(BASE)
stationByIdURL = "{0}/broadcast/getbroadcastembedded".format(BASE)

class Radio_API:
    def __init__(self):
        pass

    def getTopStations(self):
        params = {'category': '_top'}
        response = self.doRequest(top100URL, params)
        pyotherside.send('updateStationList', response)

    def getRecomendedStations(self):
        response = self.doRequest(top100URL)
        pyotherside.send('updateStationList', response)

    def getCategories(self, params={"category": "language"}):
        # 'genre', 'topic', 'country', 'city', 'language'
        response = self.doRequest(categoriesURL, params)
        pyotherside.send('log', "Categories Response: {0}".format(response))
        #pyotherside.send('updateStationList', response)

    def getSearchResults(self, s):
        pyotherside.send('log', "Searching for: {}".format(s))
        params = {"q": s, "start": "0", "rows": "100",
            "streamcontentformats": "aac,mp3"}
        response = self.doRequest(searchURL, params)
        pyotherside.send('updateStationList', response)

    def getStationById(self, id):
        pyotherside.send('log', "Getting station: {}".format(id))
        params = {'broadcast': id}
        response = self.doRequest(stationByIdURL, params)
        pyotherside.send('gotStation', response)

    def doRequest(self, url, params=None):
        headers = {'user-agent': USER_AGENT}
        r = requests.get(url, params=params, headers=headers)
        return r.json()

radio = Radio_API();
