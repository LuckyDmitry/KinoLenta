#!/usr/bin/env python3

import os
import sys


API_KEY_PATH = os.path.join(os.path.dirname(__file__), '..', '..', 'api-key.txt')
GEN_PATH = os.path.join(os.path.dirname(__file__), '..', 'Generated', 'APIKey.swift')

TEMPLATE = """// File content is generated: don't modify it manually

enum APIKey {
    static let value = "{{API_KEY}}"
}
"""


def main():
    assert os.path.isfile(API_KEY_PATH), f'API key not found at {os.path.abspath(API_KEY_PATH)}'

    dir_path = os.path.dirname(GEN_PATH)
    if not os.path.isdir(dir_path):
        os.mkdir(dir_path)

    with open(API_KEY_PATH, 'rt') as api_key_file:
        api_key = api_key_file.read().strip()
        with open(GEN_PATH, 'wt') as generated_file:
            generated_file.write(TEMPLATE.replace('{{API_KEY}}', api_key))


if __name__ == '__main__':
    sys.exit(main())
