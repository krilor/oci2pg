import unittest
from .singleton import Singleton


class TheSingleton(metaclass=Singleton):
    pass


class NotSingleton:
    pass


class TestSingleton(unittest.TestCase):
    def test_singleton(self) -> None:
        a = TheSingleton()
        b = TheSingleton()
        self.assertEqual(a, b)

    # this is just here to verify that the singleton test makes sense
    def test_not_singleton(self) -> None:
        a = b = NotSingleton()
        c = NotSingleton()
        self.assertEqual(a, b)
        self.assertNotEqual(a, c)
