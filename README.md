Customer Segmentation with K-Means

This project demonstrates the application of K-Means clustering algorithm for customer segmentation based on demographic features such as age, income, and education level. Customer segmentation is a crucial strategy for businesses to target specific groups of customers effectively and allocate resources efficiently.

Objective
The main objective of this project is to utilize K-Means clustering to divide customers into distinct segments and derive actionable insights for targeted marketing strategies.

Project Structure
- Notebook: The project is implemented in a Jupyter Notebook, which includes detailed explanations, code, visualizations, and results.
- Dataset: The dataset used for this project is "Cust_Segmentation.csv", which contains customer demographic information (850 x 10).
- Requirements: The project utilizes Python libraries such as pandas, numpy, matplotlib, seaborn, and scikit-learn. These dependencies are specified in the requirements.txt file.
  
Steps Involved
1. Data Loading: The dataset is loaded into a pandas DataFrame.
2. Pre-processing: The "Address" column, which is categorical, is dropped from the dataset. Then, the data is normalized using StandardScaler.
3. Modeling: K-Means clustering algorithm is applied to the pre-processed data to segment customers into clusters. The optimal number of clusters is determined based on business requirements and silhouette score evaluation.
4. Insights Generation: The centroids of the clusters are analyzed to derive insights about each customer segment. Visualizations such as scatter plots and 3D plots are created to visualize the distribution of customers in each cluster.

Results
- Cluster Labels: Each customer is assigned a cluster label indicating the segment they belong to.
- Cluster Profiles: Three distinct customer segments are identified:
  - Cluster 0: Affluent, Educated, and Old Aged
  - Cluster 1: Middle Aged and Middle Income
  - Cluster 2: Young and Low Income
- Silhouette Score: The average silhouette score of 0.58 indicates reasonable separation between clusters.

Conclusion
Customer segmentation using K-Means clustering provides valuable insights for businesses to tailor their marketing strategies and enhance customer engagement. By understanding the distinct characteristics of each segment, companies can optimize their product offerings, pricing strategies, and marketing campaigns to meet the diverse needs of their customer base.

Future Enhancements
- Exploration of additional clustering algorithms for comparison and evaluation.
- Integration of additional features or datasets to improve segmentation accuracy and granularity.
- Deployment of the segmentation model into production for real-time customer segmentation and targeted marketing efforts.

Contributors
- Almujtba Suliman - Almujtbaizz98@outlook.com
