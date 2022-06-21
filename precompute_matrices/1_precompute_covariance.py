from config import Config
from covariance import save_covariance_matrix
from sensorimotor_norms.config.config import Config as SMConfig; SMConfig(use_config_overrides_from_file=Config.path)
from sensorimotor_norms.sensorimotor_norms import SensorimotorNorms


def main():
    data_matrix = SensorimotorNorms().matrix().T
    save_covariance_matrix(data_matrix)


if __name__ == '__main__':
    main()
