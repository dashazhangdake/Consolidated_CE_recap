int sum_array(int *my_arr, int size, int stride) {
    int sum = 0;
    for (int i = 0; i < size; i += stride) {
        sum += my_arr[i];
    }
    return sum;
}