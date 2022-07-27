from unittest import TestCase
from framework import AssemblyTest, print_coverage

"""
Coverage tests for project 2 is meant to make sure you understand
how to test RISC-V code based on function descriptions.
Before you attempt to write these tests, it might be helpful to read
unittests.py and framework.py.
Like project 1, you can see your coverage score by submitting to gradescope.
The coverage will be determined by how many lines of code your tests run,
so remember to test for the exceptions!
"""

"""
abs_loss
# =======================================================
# FUNCTION: Get the absolute difference of 2 int arrays,
#   store in the result array and compute the sum
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the length of the arrays
#   a3 (int*) is the pointer to the start of the result array

# Returns:
#   a0 (int)  is the sum of the absolute loss
# Exceptions:
# - If the length of the array is less than 1,
#   this function terminates the program with error code 36.
# =======================================================
"""


class TestAbsLoss(TestCase):
    def test_simple(self):
        # load the test for abs_loss.s
        t = AssemblyTest(self, "../coverage-src/abs_loss.s")

        # We have got TODOs done
        # raise NotImplementedError("TODO")

        # create array0 in the data section
        # TODO
        array0 = t.array([1, 2, 3, 4, 5, 6, 7, 8, 9])
        # load address of `array0` into register a0
        # TODO
        t.input_array("a0", array0)
        # create array1 in the data section
        # TODO
        array1 = t.array([1, 6, 1, 6, 1, 6, 1, 6, 1])
        # load address of `array1` into register a1
        # TODO
        t.input_array("a1", array1) 
        # set a2 to the length of the array
        # TODO
        t.input_scalar("a2", len(array1)) 
        # create a result array in the data section (fill values with -1)
        # TODO
        array2 = t.array([-1 for i in range(len(array0))])
        # load address of `array2` into register a3
        # TODO
        t.input_array("a3", array2)
        # call the `abs_loss` function
        # TODO
        t.call("abs_loss")
        # check that the result array contains the correct output
        # TODO
        correct_res_array = [0, 4, 2, 2, 4, 0, 6, 2, 8]
        t.check_array(array2, correct_res_array)
        # check that the register a0 contains the correct output
        # TODO
        t.check_scalar("a0", sum(correct_res_array))
        # generate the `assembly/TestAbsLoss_test_simple.s` file and run it through venus
        t.execute()

    # Add other test cases if neccesary
    def test_bad_length(self):
        # Load vectors correctly
        t = AssemblyTest(self, "../coverage-src/abs_loss.s")
        array0 = t.array([1, 2, 3, 4, 5, 6, 7, 8, 9])
        t.input_array("a0", array0)
        array1 = t.array([1, 6, 1, 6, 1, 6, 1, 6, 1])
        t.input_array("a1", array1) 
        array2 = t.array([-1 for i in range(len(array0))])
        t.input_array("a3", array2)
        # But we have wrong length
        t.input_scalar("a2", 0)
        # Call function and expect to see error code 36   
        t.call("abs_loss")
        t.execute(code=36)


    @classmethod
    def tearDownClass(cls):
        print_coverage("abs_loss.s", verbose=False)


"""
squared_loss
# =======================================================
# FUNCTION: Get the squared difference of 2 int arrays,
#   store in the result array and compute the sum
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the length of the arrays
#   a3 (int*) is the pointer to the start of the result array

# Returns:
#   a0 (int)  is the sum of the squared loss
# Exceptions:
# - If the length of the array is less than 1,
#   this function terminates the program with error code 36.
# =======================================================
"""


class TestSquaredLoss(TestCase):
    def test_simple(self):
        # load the test for squared_loss.s
        t = AssemblyTest(self, "../coverage-src/squared_loss.s")
        # create array0 in the data section
        array0 = t.array([1, 2, 3, 4, 5, 6, 7, 8, 9])
        # load address of `array0` into register a0
        t.input_array("a0", array0)
        # create array1 in the data section
        array1 = t.array([1, 6, 1, 6, 1, 6, 1, 6, 1])
        # load address of `array1` into register a1
        t.input_array("a1", array1) 
        # set a2 to the length of the array
        t.input_scalar("a2", len(array1)) 
        # create a result array in the data section (fill values with -1)
        array2 = t.array([-1 for i in range(len(array0))])
        # load address of `array2` into register a3
        t.input_array("a3", array2)
        # call the `abs_loss` function
        t.call("squared_loss")
        # check that the result array contains the correct output
        correct_res_array = [0, 16, 4, 4, 16, 0, 36, 4, 64]
        t.check_array(array2, correct_res_array)
        # check that the register a0 contains the correct output
        t.check_scalar("a0", sum(correct_res_array))
        # generate the `assembly/TestAbsLoss_test_simple.s` file and run it through venus
        t.execute()
    # Add other test cases if neccesary
    def test_bad_length(self):
        # Load vectors correctly
        t = AssemblyTest(self, "../coverage-src/squared_loss.s")
        array0 = t.array([1, 2, 3, 4, 5, 6, 7, 8, 9])
        t.input_array("a0", array0)
        array1 = t.array([1, 6, 1, 6, 1, 6, 1, 6, 1])
        t.input_array("a1", array1) 
        array2 = t.array([-1 for i in range(len(array0))])
        t.input_array("a3", array2)
        # But we have wrong length
        t.input_scalar("a2", 0)
        # Call function and expect to see error code 36   
        t.call("squared_loss")
        t.execute(code=36)

    @classmethod
    def tearDownClass(cls):
        print_coverage("squared_loss.s", verbose=False)


"""
zero_one_loss
# =======================================================
# FUNCTION: Generates a 0-1 classifer array inplace in the result array,
#  where result[i] = (arr0[i] == arr1[i])
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the length of the arrays
#   a3 (int*) is the pointer to the start of the result array

# Returns:
#   NONE
# Exceptions:
# - If the length of the array is less than 1,
#   this function terminates the program with error code 36.
# =======================================================
"""


class TestZeroOneLoss(TestCase):
    def test_simple(self):
        # load the test for zero_one_loss.s
        a0 = [1, 2, 3, 4, 5, 6, 7, 8, 9]
        a1 = [1, 6, 1, 6, 1, 6, 1, 6, 1]
        t = AssemblyTest(self, "../coverage-src/zero_one_loss.s")
        array0 = t.array(a0)
        t.input_array("a0", array0)
        array1 = t.array(a1)
        t.input_array("a1", array1) 
        t.input_scalar("a2", len(array1)) 

        array2 = t.array([-1 for i in range(len(array0))])
        t.input_array("a3", array2)
        t.call("zero_one_loss")
        # check that the result array contains the correct output
        correct_res_array = [int(a0[i] == a1[i]) for i in range(len(array0))]
        t.check_array(array2, correct_res_array)
        # generate the `assembly/TestAbsLoss_test_simple.s` file and run it through venus
        t.execute()

    # Add other test cases if neccesary
    # Add other test cases if neccesary
    def test_bad_length(self):
        # Load vectors correctly
        t = AssemblyTest(self, "../coverage-src/zero_one_loss.s")
        array0 = t.array([1, 2, 3, 4, 5, 6, 7, 8, 9])
        t.input_array("a0", array0)
        array1 = t.array([1, 6, 1, 6, 1, 6, 1, 6, 1])
        t.input_array("a1", array1) 
        array2 = t.array([-1 for i in range(len(array0))])
        t.input_array("a3", array2)
        # But we have wrong length
        t.input_scalar("a2", 0)
        # Call function and expect to see error code 36   
        t.call("zero_one_loss")
        t.execute(code=36)

    @classmethod
    def tearDownClass(cls):
        print_coverage("zero_one_loss.s", verbose=False)


"""
initialize_zero
# =======================================================
# FUNCTION: Initialize a zero array with the given length
# Arguments:
#   a0 (int) size of the array

# Returns:
#   a0 (int*)  is the pointer to the zero array
# Exceptions:
# - If the length of the array is less than 1,
#   this function terminates the program with error code 36.
# - If malloc fails, this function terminates the program with exit code 26.
# =======================================================
"""


class TestInitializeZero(TestCase):
    def test_simple(self):
        t = AssemblyTest(self, "../coverage-src/initialize_zero.s")
        # raise NotImplementedError("TODO")
        # input the length of the desired array
        arr_len = 10
        t.input_scalar("a0", arr_len)
        # call the `initialize_zero` function
        # TODO
        t.call("initialize_zero")
        # check that the register a0 contains the correct array (hint: look at the check_array_pointer function in framework.py)
        # TODO
        t.check_array_pointer("a0", [0 for i in range(arr_len)])
        t.execute()

    # Add other test cases if neccesary
    def test_bad_length(self):
        t = AssemblyTest(self, "../coverage-src/initialize_zero.s")
        # input the length of the desired array
        arr_len = 0
        t.input_scalar("a0", arr_len)
        # call the `initialize_zero` function
        # TODO
        t.call("initialize_zero")
        t.execute(code=36)
    
    def test_failed_malloc(self):
        t = AssemblyTest(self, "../coverage-src/initialize_zero.s")
        # input the length of the desired array
        arr_len = 2**30 # Let array len be large enough to trigger malloc error
        t.input_scalar("a0", arr_len)
        # call the `initialize_zero` function
        # TODO
        t.call("initialize_zero")
        t.execute(code = 26)

    @classmethod
    def tearDownClass(cls):
        print_coverage("initialize_zero.s", verbose=False)
