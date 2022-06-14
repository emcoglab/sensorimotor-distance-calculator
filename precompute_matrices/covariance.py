from pathlib import Path

from numpy import array, cov, save, load
from scipy.io import mmwrite

from config import Config

cov_matrix_name = "covariance_matrix"


def _compute_covariance_matrix(input_matrix) -> array:
    return cov(input_matrix)


def save_covariance_matrix(input_matrix):
    """input_matrix.shape = (dims, observations)"""
    path = Path(Config().sensorimotor_app_data_location, cov_matrix_name).with_suffix('.npy')
    covariance_matrix = _compute_covariance_matrix(input_matrix)
    # Save as npz
    with path.open("wb") as f:
        save(f, covariance_matrix)
    # Save as mtx
    mtx_path = path.with_suffix('.mtx')
    with mtx_path.open("wb") as f:
        mmwrite(f, covariance_matrix,
                comment="Covariance matrix",
                field="real",
                symmetry="general")


def load_covariance_matrix() -> array:
    path = Path(Config().sensorimotor_app_data_location, cov_matrix_name).with_suffix('.npy')
    return load(path.as_posix())
