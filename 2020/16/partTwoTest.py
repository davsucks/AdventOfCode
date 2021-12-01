import unittest
import partTwoHelpers


class TestValueIsWithinRange(unittest.TestCase):
    def test_value_is_out_of_single_range(self):
        value = 3
        ranges = [range(2, 4)]
        self.assertTrue(partTwoHelpers.value_is_within_range(value, ranges))


if __name__ == '__main__':
    unittest.main()
