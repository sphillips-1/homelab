#!/usr/bin/env python3
import time
import logging

logging.basicConfig(level=logging.INFO, format='[player] %(message)s')

if __name__ == '__main__':
    logging.info('Starting audiobook player placeholder service')
    try:
        while True:
            time.sleep(10)
    except KeyboardInterrupt:
        logging.info('Stopping audiobook player placeholder service')
