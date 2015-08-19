# -*- coding: utf-8 -*-

import pyotherside
import requests

USER_AGENT = "XBMC Addon Radio"
BASE = "http://rad.io/info"

recomendedURL = "{0}/broadcast/editorialreccomendationsembedded".format(BASE)
top100URL = "{0}/menu/broadcastsofcategory".format(BASE)
mostWantedURL = "{0}/account/getmostwantedbroadcastlists".format(BASE)
searchURL = "{0}/index/searchembeddedbroadcast".format(BASE)
categoriesURL = "{0}/menu/valuesofcategory".format(BASE)
stationsByCategoriesURL = "{0}/menu/broadcastsofcategory".format(BASE)
stationByIdURL = "{0}/broadcast/getbroadcastembedded".format(BASE)

class Radio_API:
    def __init__(self):
        pass

    def getTopStations(self):
        params = {'category': '_top'}
        response = self.doRequest(top100URL, params)
        pyotherside.send('updateStationList', response)

    def getRecomendedStations(self):
        response = self.doRequest(recomendedURL)
        pyotherside.send('updateStationList', response)

    def getLocalStations(self):
        response = self.getMostWantedStations()
        pyotherside.send('updateStationList', response['localBroadcasts'])

    def getMostWantedStations(self):
        # Available lists from most wanted
        #   topBroadcasts, recommendedBroadcasts, localBroadcasts
        # Lists that could be used if impementing login
        #   historyBroadcasts, bookmarkedBroadcasts
        params = {'sizeoflists': '100'}
        return self.doRequest(mostWantedURL, params)


    def getCategories(self, category):
        # 'genre', 'topic', 'country', 'city', 'language'
        params = {"category": "_{0}".format(category)}
        pyotherside.send('log', "getCategories for: {}".format(params))
        response = self.doRequest(categoriesURL, params)
        pyotherside.send('updateCategories', response)

    def getStationsByCategory(self, category, value):
        params = {"category": "_{0}".format(category), "value": value}
        pyotherside.send('log', "getStationsByCategory params: {0}".format(params))
        response = self.doRequest(stationsByCategoriesURL, params)
        pyotherside.send('updateStationList', response)

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
