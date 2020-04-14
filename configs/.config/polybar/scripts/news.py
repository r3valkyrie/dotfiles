#!/usr/bin/python

import requests

with open('/home/valkyrie/.newsapi', 'r') as key:
    key = key.read().split('\n')[0]
    sources = 'ars-technica'
    url = 'http://newsapi.org/v2/top-headlines?' \
          f'sources={sources}&' \
          f'apiKey={key}'
    try:
        response = requests.get(url).json()

        source = response['articles'][0]['source']['name']
        title = response['articles'][0]['title']
        url = response['articles'][0]['url']

        print(source + ': ' + title)
    except Exception:
        raise Exception
