# coding: utf-8
import requests

def my_sum(x, y):
    return x+y

class Rate:
    def __init__(self, format='value', diff=False):
        self.format = format
        self.diff = diff

    def exchange_rates(self):
        """
        Возвращает ответ сервиса с информацией о валютах в виде:

        {
            'AMD': {
                'CharCode': 'AMD',
                'ID': 'R01060',
                'Name': 'Армянских драмов',
                'Nominal': 100,
                'NumCode': '051',
                'Previous': 14.103,
                'Value': 14.0879
                },
            ...
        }
        """
        r = requests.get('https://www.cbr-xml-daily.ru/daily_json.js')
        return r.json()['Valute']

    def make_format(self, currency):
        """
        Возвращает информацию о валюте currency в двух вариантах:
        - полная информация о валюте при self.format = 'full':
        Rate('full').make_format('EUR')
        {
            'CharCode': 'EUR',
            'ID': 'R01239',
            'Name': 'Евро',
            'Nominal': 1,
            'NumCode': '978',
            'Previous': 79.6765,
            'Value': 79.4966
        }

        Rate('value').make_format('EUR')
        79.4966
        """
        response = self.exchange_rates()

        if currency in response:
            if self.format == 'full':
                return response[currency]

            if self.format == 'value':
                return response[currency]['Value']

        return 'Error'

    def name(self, currency: str = 'AUD') -> str:
        '''
        Returns the name of the currency and the maximum value for today and yesterday.

        currency:
        "AUD", "AZN", "GBP", "AMD", "BYN", "BGN", "BRL", "HUF", "HKD", "DKK", "USD", "EUR", "INR", "KZT", "CAD", "KGS",
        "CNY", "MDL", "NOK", "PLN", "RON", "XDR", "SGD", "TJS", "TRY", "TMT", "UZS", "UAH", "CZK", "SEK", "CHF", "ZAR",
        "KRW", "JPY"
        '''

        response = self.exchange_rates()[currency]

        name_key, value_key, previous_key = ['Name', 'Value', 'Previous']

        if name_key in response \
                and value_key in response \
                and previous_key in response:

            name = response[name_key]
            value = response[value_key]

            if value < response[previous_key]:
                value = response[previous_key]

            return '{}, max value: {}'.format(name, value)
        return 'Error'


    def fetch_currency(self, currency: str):
        response = self.exchange_rates()[currency]

        value = response['Value']
        if self.diff:
            value = response['Previous'] - value

        if self.format == 'full':
            return response

        if self.format == 'value':
            return value

        return response

    def eur(self):
        """Возвращает курс евро на сегодня в формате self.format"""
        return self.fetch_currency('EUR')

    def usd(self):
        """Возвращает курс доллара на сегодня в формате self.format"""
        return self.fetch_currency('USD')

    def AZN(self):
        """Возвращает курс азербайджанского маната на сегодня в формате self.format"""
        return self.fetch_currency('AZN')