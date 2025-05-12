#!/usr/bin/env python3

import json
import requests
import sys

file_path = sys.argv[1]
response = requests.post("https://yandex.com/images/search", params={'rpt': 'imageview', 'format': 'json', 'request': '{"blocks":[{"block":"b-page_type_search-by-image__link"}]}'}, files={'upfile': ('blob', open(file_path, 'rb'), 'image/jpeg')})
query_string = json.loads(response.content)['blocks'][0]['params']['url']
img_search_url = 'https://yandex.com/images/search?' + query_string
print(img_search_url)