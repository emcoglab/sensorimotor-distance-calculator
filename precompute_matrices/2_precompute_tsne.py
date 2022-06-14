from config import Config
from covariance import load_covariance_matrix

from sensorimotor_norms.config.config import Config as SMConfig; SMConfig(use_config_overrides_from_file=Config.path)
from tsne import valid_distance_names, SensorimotorTSNE

if __name__ == '__main__':
    for distance in valid_distance_names:
        for dim in [2, 3]:
            if distance == "Mahalanobis":
                SensorimotorTSNE(dim, distance, covariance_matrix=load_covariance_matrix())
            else:
                SensorimotorTSNE(dim, distance)
