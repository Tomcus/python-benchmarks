from threading import Thread, Lock, Event
from dataclasses import dataclass
from typing import Union
import random

DATA_COUNT = 1_000
EVENT_COUNT = 10_000_000
THREAD_COUNT = 8
MIN_VALUE = -1_000_000_000
MAX_VALUE = 1_000_000_000

shared_data = [0 for _ in range(DATA_COUNT)]
shared_data_lock = Lock()
counter = 0


@dataclass
class SetValue(object):
    index: int
    value: int


@dataclass
class InDecrement(object):
    index: int
    value: int


def do_action(action: Union[SetValue, InDecrement]):
    global counter, shared_data, shared_data_lock
    with shared_data_lock:
        match action:
            case SetValue(index, value):
                shared_data[index] = value
            case InDecrement(index, value):
                shared_data[index] += value


start = Event()


def run():
    start.wait()
    for _ in range(EVENT_COUNT):
        event_id = random.randint(0, 1)
        match event_id:
            case 0:
                do_action(SetValue(random.randint(0, DATA_COUNT - 1), random.randint(MIN_VALUE, MAX_VALUE)))
            case 1:
                do_action(InDecrement(random.randint(0, DATA_COUNT - 1), random.randint(MIN_VALUE, MAX_VALUE)))


threads = []
for _ in range(THREAD_COUNT):
    threads.append(Thread(target=run))
    threads[-1].start()

start.set()

for thread in threads:
    thread.join()
