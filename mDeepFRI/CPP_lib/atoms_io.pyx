cimport cython
from libc.stdlib cimport free, malloc
from libcpp cimport bool
from libcpp.string cimport string

import numpy as np

cimport numpy as cnp
from libc.math cimport sqrt

cnp.import_array()

## TODO: after connecting FoldComp remove bit files load from the function scope

cdef extern from "atoms_file_io.h" nogil:
    void SaveAtomsFile(float* positions,
                       size_t atom_count,
                       int* groups,
                       size_t chain_length,
                       string save_path)


@cython.wraparound(False)
@cython.boundscheck(False)
@cython.cdivision(True)
@cython.nonecheck(False)
def save_atoms_file(list positions_list,
                    list groups_list,
                    str save_path):

    # every atom has 3 coordinates (x, y & z)
    cdef:
        int atom_count = int(len(positions_list) / 3)
        int chain_length = int(len(groups_list))
        float * positions_array = <float *>malloc(atom_count * 3 * sizeof(float))
        int * groups_array = <int *>malloc(chain_length * sizeof(int))
        string save_path_bytes = save_path.encode('utf-8')
        int i

    # copy the lists to arrays
    for i in range(atom_count):
        positions_array[i * 3] = positions_list[i * 3]
        positions_array[i * 3 + 1] = positions_list[i * 3 + 1]
        positions_array[i * 3 + 2] = positions_list[i * 3 + 2]

    for i in range(chain_length):
        groups_array[i] = groups_list[i]

    # save the file
    with nogil:
        SaveAtomsFile(positions_array, atom_count,
                      groups_array, chain_length,
                      save_path_bytes)


cdef inline load_atoms_file(string filepath):
    cdef int chain_length = np.fromfile(filepath, count=1, dtype=np.int32)

    # offset 4 bytes because we read chain_length already
    cdef int[::1] groups = np.fromfile(filepath, count=chain_length, dtype=np.int32,
                                       offset=4, sep='')

    cdef int positions_offset = 4 * (1 + chain_length)

    cdef float[::1] positions = np.fromfile(filepath, count=groups[-1] * 3,
                                            dtype=np.float32, offset=positions_offset, sep='')

    chain_length = chain_length - 1

    return positions, groups, chain_length


@cython.boundscheck(False)
@cython.wraparound(False)
cdef inline float distance(float[::1] array, int i, int j, mode="squared") nogil:
    """
    Calculates the square distance between two atoms.
    Computationally efficient replacement for Euclidian
    distance, as sqrt() is computationally heavy.
    """

    cdef float x = array[i * 3] - array[j * 3]
    cdef float y = array[i * 3 + 1] - array[j * 3 + 1]
    cdef float z = array[i * 3 + 2] - array[j * 3 + 2]
    cdef float distance = x * x + y * y + z * z

    if mode == "euclidean":
        distance = sqrt(distance)
    return distance


@cython.boundscheck(False)
def load_contact_map(str filepath,
                     float angstrom_contact_threshold):

    cdef int chain_length
    cdef int[::1] groups
    cdef float[::1] positions
    positions, groups, chain_length = load_atoms_file(filepath.encode())

    cdef int i, group_a, group_b, atom_a, atom_b
    cdef bint connected
    # allocate calculations array
    cdef int[::1] contact_map = np.zeros(chain_length * chain_length, dtype=np.int32)
    cdef cnp.ndarray[ndim=2, dtype=cnp.int32_t] contact_map_2d

    # fill the array with false and diagonal with True
    with nogil:
        for i in range(chain_length):
            contact_map[i * chain_length + i] = 1

        for group_a in range(chain_length):
            contact_map[group_a * chain_length + group_a] = 1;

            for group_b in range(group_a + 1, chain_length):
                connected = 0
                for atom_a in range(groups[group_a], groups[group_a + 1]):
                    for atom_b in range(groups[group_b], groups[group_b + 1]):
                        if distance(positions, atom_a, atom_b, mode="euclidean") <= angstrom_contact_threshold:
                            connected = 1
                            # fill the diagonal using symmetry
                            # reduces computational complexity
                            contact_map[group_a * chain_length + group_b] = 1
                            contact_map[group_a + group_b * chain_length] = 1
                            break
                    if connected:
                        break

    # reshape into 2D array
    contact_map_2d = np.asarray(contact_map).reshape(chain_length, chain_length)

    return contact_map_2d
