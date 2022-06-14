from functools import partial
from os import path
from typing import List

from numpy import array, load as np_load, save as np_save
from numpy.linalg import inv
from pandas import DataFrame
from scipy.spatial.distance import minkowski
from sklearn.manifold import TSNE

from config import Config
from sensorimotor_norms.sensorimotor_norms import SensorimotorNorms, DataColNames

valid_distance_names = ['correlation', 'cosine', 'Euclidean', 'Minkowski-3', "Mahalanobis"]


class SensorimotorTSNE(object):

    _sn = SensorimotorNorms()
    _all_words: List[str] = list(_sn.iter_words())

    # Unless otherwise stated, these are all the default values from sklearn.manifold.TSNE
    perplexity = 30.0
    n_iter = 1000
    learning_rate = 200.0
    method_id = 'barnes_hut'; method_name = "Barnes-Hut"

    def __init__(self, dims: int, distance_name: str, covariance_matrix: array = None):

        assert distance_name in valid_distance_names

        self.dims: int = dims
        self.distance_name = distance_name.lower()
        self.covariance_matrix: array = covariance_matrix

        if self._could_load():
            matrix: array = self._load()
        else:
            matrix: array = self._compute()
            self._save(matrix)

        self.data: DataFrame = self._build_dataframe(matrix)

        self.dominant_sensorimotor_options: List[str] = list(self._sn.data[DataColNames.dominant_sensorimotor].unique())
        self.dominant_perceptual_options: List[str]   = list(self._sn.data[DataColNames.dominant_perceptual].unique())
        self.dominant_action_options: List[str]       = list(self._sn.data[DataColNames.dominant_action].unique())

    @classmethod
    def save_path_for(cls, dims, distance_name):
        return(path.join(Config().sensorimotor_app_data_location, f't-SNE_{dims}_{distance_name}_cache.npy'))

    @property
    def description(self) -> str:
        return (f"t-SNE in {self.dims} dimensions "
                f"using the {self.method_name} method and "
                f"{self.method_name} metric. "
                f"Perplexity {self.perplexity}, "
                f"{self.n_iter} iterations, "
                f"learning rate {self.learning_rate}.")

    def _could_load(self) -> bool:
        return path.isfile(self.save_path_for(dims=self.dims, distance_name=self.distance_name))

    def _load(self) -> array:
        print(f"Loading t-SNE data for {self.dims} dimensions...")
        return np_load(self.save_path_for(dims=self.dims, distance_name=self.distance_name))

    def _save(self, matrix: array):
        print(f"Saving t-SNE data for {self.dims} dimensions...")
        np_save(self.save_path_for(dims=self.dims, distance_name=self.distance_name), matrix)

    def _compute(self) -> array:
        print(f"Computing t-SNE data for {self.dims} dimensions...")
        if self.distance_name in ['correlation', 'cosine', 'euclidean']:
            # pass metric name
            metric = self.distance_name
            metric_params = None
        elif self.distance_name == 'minkowski-3':
            # pass metric function
            metric = partial(minkowski, p=3)
            metric_params = None
        elif self.distance_name == "mahalanobis":
            metric = self.distance_name
            metric_params = {
                # Mahalanobis distance computed with inverse covariance matrix
                "VI": inv(self.covariance_matrix).T
            }
        else:
            raise NotImplementedError()
        return TSNE(
            n_components=self.dims,
            perplexity=self.perplexity,
            n_iter=self.n_iter,
            learning_rate=self.learning_rate,
            metric=metric,
            metric_params=metric_params,
            method=self.method_id,
        ).fit_transform(self._sn.matrix_for_words(self._all_words))

    def _build_dataframe(self, matrix: array) -> DataFrame:

        if self.dims == 2:
            coordinate_columns = list("xy")
        elif self.dims == 3:
            coordinate_columns = list("xyz")
        else:
            raise NotImplementedError()

        df = DataFrame(matrix, columns=coordinate_columns)

        df["label"] = self._all_words
        df[DataColNames.dominant_sensorimotor] = self._sn.data[DataColNames.dominant_sensorimotor].values
        df[DataColNames.dominant_perceptual]   = self._sn.data[DataColNames.dominant_perceptual].values
        df[DataColNames.dominant_action]       = self._sn.data[DataColNames.dominant_action].values

        return df
