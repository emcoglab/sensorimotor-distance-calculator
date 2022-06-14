import struct
from pathlib import Path

import numpy

from config import Config
from covariance import cov_matrix_name
from sensorimotor_norms.config.config import Config as SMConfig; SMConfig(use_config_overrides_from_file=Config.path)
from tsne import valid_distance_names, SensorimotorTSNE


def convert_file(npy_path, bin_path):
    # Thanks to https://www.r-bloggers.com/2012/06/getting-numpy-data-into-r/

    # load from the file
    mat = numpy.load(npy_path)
    # create a binary file
    with open(bin_path, mode="wb") as bin_file:
        header = struct.pack('2I', mat.shape[0], mat.shape[1])
        bin_file.write(header)
        # then loop over columns and write each
        for i in range(mat.shape[1]):
            data = struct.pack('%id' % mat.shape[0], *mat[:, i])
            bin_file.write(data)


if __name__ == '__main__':
    # Covariance matrix
    npy_path = Path(Config().sensorimotor_app_data_location, cov_matrix_name).with_suffix('.npy')
    bin_path = npy_path.with_suffix('.bin')
    convert_file(npy_path.as_posix(), bin_path.as_posix())

    # t-SNE positions
    for distance in valid_distance_names:
        for dim in [2, 3]:
            npy_path = Path(SensorimotorTSNE.save_path_for(dims=dim, distance_name=distance))
            bin_path = npy_path.with_suffix('.bin')
            convert_file(npy_path, bin_path)
