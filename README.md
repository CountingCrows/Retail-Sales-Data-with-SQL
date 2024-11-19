# Retail-Sales-Data-with-SQL

The retail industry is known for its competitive ecosystem. Understanding sales trends and customer purchasing behavior is critical for optimizing operations and driving revenue. This analysis explores a retail sales dataset to uncover key insights, including peak sales periods, top-performing products, and customer purchasing patterns.

### Our analysis will address the following key questions:

When are peak sales periods?
What are the most popular products?
How do different segments behave?

**Analyzing Total Sales Over Time**

![image](https://github.com/user-attachments/assets/47489e32-ddc8-45bd-84d1-fa74b44483f6)

We can see from the chart that there is a seasonal trend starting from July. But, will it be more interesting to know how many customers made a transaction and the total number of products sold each month?

![image](https://github.com/user-attachments/assets/62e6b748-4192-459c-a3e4-7ca5fde67c74)

Having more detailed information on what month has the highest total transaction we can also see how many customers made transactions and the number of transactions that occurred in each month.

**Capitalize on High Sales Periods:**

- Offer targeted promotions or discounts leading up to August, October, and December to maximize revenue during these peak periods.
- Consider stocking high-demand products earlier to avoid supply shortages during these months.

**Boost Sales During Low Months:**

- Implement marketing campaigns in March and April to encourage purchases, such as discounts or special product bundles.
- Analyze customer feedback or seasonal preferences to understand why sales are lower during these months.

**Enhance Customer Engagement:**

- Increase engagement with loyalty programs or special rewards for repeat purchases, especially during high-demand months like August and December.
- Use insights from high-engagement months to replicate successful strategies (e.g., product bundles, festive offers).

**Customer Retention Strategy:**

- Develop personalized offers or post-purchase engagement strategies for customers active during peak months to encourage repeat transactions throughout the year.

Given the dataset originates from Pakistan, the sales peak in August and December is likely influenced by cultural factors, such as holidays and festivals that drive higher customer demand.
In summary, the data suggests strong sales performance in the second half of the year, with notable peaks in August, October, and December. Customer engagement and order quantities also rise significantly during these periods.

### Identifying Top-Selling Categories
Knowing which categories are top sellers lets us focus on high-demand items and ensure adequate stock levels.

![image](https://github.com/user-attachments/assets/eea4abe5-08a9-4406-b0c9-b72d91fbc5cc)

- The highest total transactions occurred in Mobiles & Tablets category for 918,451,576, followed by Entertainment for 365,344,148.9.
- The increase of amount in total transactions for the Mobiles & Tablets category and Entertainment points that there’s an increase usage of technology and digitalization, which can also be triggered by the need for devices for online education and online entertainment facilities at home since the COVID-19 pandemic between 2021 till 2022.

![image](https://github.com/user-attachments/assets/2286410b-bb0f-4d0f-bea3-8670f60f2ed7)

### Analyzing Category Shifts between 2021 and 2022

Identifying categories with increased transaction values can reveal areas of growth and opportunities to invest further, while understanding categories with decreased transaction values can help address potential issues, such as changing customer needs, pricing challenges, or seasonal factors.

![image](https://github.com/user-attachments/assets/a58a8d80-4b3e-4711-8b2e-f93b86261b55)

- The Mobiles & Tablets category experienced an increase of the highest total value transactions for 547,844,858. On the other hand, the category Others had a decrease in the total value of transactions for 18,723,869.-
- The increase in the category of Mobiles & Tablets is possibly due to the increase in the need for digital devices to facilitate online education since the COVID-19 pandemic.

Comparing transaction values reveals that some categories experienced growth, while others, like the “Other” category, saw a significant decline. This drop in the “Other” category stands out and needs further investigation.

**Others**

We’ll be using Inner Join to observe the difference in total products sold from each product between 2021 and 2022 in this categories.

![image](https://github.com/user-attachments/assets/608b4bca-a583-4281-8580-6c46730c63bf)

![image](https://github.com/user-attachments/assets/bf870331-e7d4-48c4-adee-b2da13085050)

From the query, we notice that the product RB Dettol Germ Busting Kit bf experienced the highest decrease and emart_Tyre Shape Air Compressor has the highest increase of sales.

### Comparing Brand Performance: Sorting Top 5 Brands by Total Transaction Value

Analyzing the total transaction value across major brands provides a clear picture of consumer spending patterns and brand performance. By sorting Samsung, Apple, Sony, Huawei, and Lenovo based on their transaction values, we can identify which brands are leading in terms of sales and customer demand.

![image](https://github.com/user-attachments/assets/b94218c6-c1b0-4a38-90fb-bc1112fd3b67)

Adding product names and also the total amount of items sold to see the bigger picture.

![image](https://github.com/user-attachments/assets/7a92639a-1b79-474e-a3b4-74263827048a)

Based on the provided data for different brands, here are some insights:

**Samsung Dominates the Market**: Samsung leads with the highest transaction value and the largest number of products sold. This indicates a strong foothold and high demand in the market.

**Apple’s Premium Pricing Power**: Despite selling fewer units, Apple has the second-highest transaction value, showcasing its dominance in the premium segment with higher-priced products.

Samsung dominates both in volume and value, while Apple excels in premium, high-value transactions. Huawei and Sony maintain mid-level performance, and Lenovo targets niche, budget-friendly consumers. These insights guide strategies for targeting different market segments effectively.

### Unpacking Payment Choices

Understanding the payment methods preferred by customers is essential for optimizing transaction processes and improving overall customer experience. By analyzing the top 5 payment methods used in 2022, this analysis provides valuable insights into customer behavior and preferences.

![image](https://github.com/user-attachments/assets/cf6be3a6-a3b9-4594-ba7e-9bc8d2b638eb)

- The most used payment method in 2022 is Cash On Delivery (cod) for 1809 transactions.
- The domination of this payment method shows us the customer’s preference to pay with cash when the product arrives at their doors.
- COD is considered a risky payment method, that is why we need to add an alternative payment method like bank transfer or other payment gateways that are used by our customers.
- Applying vouchers or discounts to the payment methods can help customers depend on using the COD payment method.

By diversifying payment options and incentivizing the use of safer, more efficient methods, businesses can not only reduce the risks associated with COD but also improve cash flow, streamline operations, and enhance the overall customer experience.

### Identifying and Quantifying Customer Churn to Improve Retention and Loyalty

This analysis aims to identify and quantify customers who have disengaged from the business over a 90-day period. Understanding churn is critical for addressing retention issues and developing strategies to enhance customer loyalty and reduce churn rates.

![image](https://github.com/user-attachments/assets/65bc5c0e-a469-4873-b9cc-2920565dd4ca)

Based on our customer churn count results:

- Active Customers: There are 1,134 active customers, which constitutes 28.44% of the total customer base.
- Churned Customers: There are 2,864 churned customers, making up 71.56% of the total customer base.

The findings reveal that a significant portion of the customer base (over 70%) has become inactive, indicating potential gaps in retention efforts. This high churn rate underscores the need for targeted strategies to re-engage inactive customers and foster stronger long-term relationships.

### Implementing cohort analysis for customers in 2021

Understanding customer churn is crucial for any business aiming to grow and maintain a loyal customer base. By analyzing the number of customers who have stopped engaging with the business over a 90-day period, this analysis helps uncover potential issues in customer retention.

![image](https://github.com/user-attachments/assets/02817a16-dfe0-459e-9ae6-7e2c7edf3a14)

There are some insights that we can find from the cohort analysis;

- **High Early Churn (Month 1)**: Retention drops sharply from 100% to 4%-7% within the first month across all cohorts, indicating significant churn immediately after signup. This suggests potential issues with onboarding, product experience, or unmet expectations.
- **Declining Retention After Month 2**: Retention continues to fall after Month 1, with only 2%-12% of users remaining by Month 3. This points to challenges in maintaining user engagement beyond the initial period.
- **Inconsistent Long-Term Retention**: Some cohorts, like January and March, show slight retention improvements around Month 6, but overall long-term engagement remains inconsistent, suggesting room for improvement in sustaining interest.
- **Mid-Term Retention Improvements (May-July)**: Cohorts from May to July show better retention at Month 5–6 (10%-12%), indicating some positive changes during these months, though these improvements are not enough to reverse the overall downward trend.

#### Actionable Takeaways

- **Improve Early Retention**: Focus on enhancing the onboarding process and understanding early churn drivers to keep users engaged during the critical first month.
- **Boost Engagement Beyond Month 2**: Implement strategies like personalized experiences or incentives to increase product value and keep users engaged longer.
- **Target Specific Cohorts for Interventions**: Focus on cohorts with the highest churn (e.g., February, March, October) with tailored campaigns or adjustments to improve retention.
- **Replicate Successful Strategies**: Analyze the cohorts with improved retention (e.g., May, June) to identify factors that contributed to better performance, and apply them to other months.

### Conclusions

From identifying seasonal sales peaks to understanding customer churn, the insights from this analysis are key to improving retention and driving revenue. By focusing on high-sales months, optimizing payment methods, and enhancing early customer engagement, businesses can boost both loyalty and profitability.

For me, this analysis highlights the importance of using data to make informed decisions — something I’m passionate about as I continue to explore the world of data analysis. These actionable strategies not only help businesses grow but also help me apply my learning to real-world challenges, bringing data-driven decisions to life.
