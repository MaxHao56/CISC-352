from loader import load_data
from transforms import apply_transformations
from plotter import plot_distributions

def main():
    df, feature_names = load_data()
    yeo_transformed, log_transformed, original = apply_transformations(df)

    plot_distributions(original, feature_names, "Original Distributions", "original.png")
    plot_distributions(yeo_transformed, feature_names, "Yeo-Johnson Transformed", "yeo_johnson.png")
    plot_distributions(log_transformed, feature_names, "-log(x) Transformed", "log_transform.png")

if __name__ == "__main__":
    main()
