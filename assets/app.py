from flask import Flask, jsonify
import pandas as pd
import numpy as np
from sklearn.ensemble import RandomForestRegressor
from sklearn.preprocessing import StandardScaler

app = Flask(__name__)

# Load the dataset
df = pd.read_csv('vendors.csv')

# One-hot encode the food type
df = pd.get_dummies(df, columns=['food_type'])

# Store vendor names
vendor_names = df['vendor_name']

# Drop vendor_name column for training
X = df.drop(columns=['vendor_name'])

# Scale features
scaler = StandardScaler()
X_scaled = scaler.fit_transform(X)

# Default user profile (used when visiting http://127.0.0.1:5000)
default_user_profile = {
    'vegan': 0,
    'gluten_free': 1,
    'lactose_free': 1,
    'spicy': 0,
    'health_sensitivity': 0.8,
    'prefers_high_hygiene': 1,
    'prefers_high_ingredient_quality': 1,
    'max_calories': 500,
    'food_type_preference': 'chaat'
}

# Suitability score function
def compute_suitability(row, user_profile):
    score = 0
    score += (1 - abs(user_profile['vegan'] - row['vegan'])) * 10
    score += (1 - abs(user_profile['gluten_free'] - row['gluten_free'])) * 10
    score += (1 - abs(user_profile['lactose_free'] - row['lactose_free'])) * 10
    score += (1 - abs(user_profile['spicy'] - row['spicy'])) * (10 * user_profile['health_sensitivity'])
    score += row['hygiene_score'] * user_profile['prefers_high_hygiene'] * 0.4
    score += row['ingredient_quality'] * user_profile['prefers_high_ingredient_quality'] * 0.4
    if row['calories'] > user_profile['max_calories']:
        score -= (row['calories'] - user_profile['max_calories']) * 0.05
    col = f"food_type_{user_profile['food_type_preference']}"
    if col in row:
        score += row[col] * 20
    return score

# Train model using a dummy target based on the default profile
y = df.apply(lambda row: compute_suitability(row, default_user_profile), axis=1)
model = RandomForestRegressor(n_estimators=100, random_state=42)
model.fit(X_scaled, y)

# Root route returns top 10 vendors
@app.route('/', methods=['GET'])
def index():
    # Predict suitability scores
    predictions = model.predict(X_scaled)
    results = pd.DataFrame({
        'vendor_name': vendor_names,
        'suitability_score': predictions
    }).sort_values(by='suitability_score', ascending=False)

    # Return top 10 as JSON
    return jsonify(results.head(10).to_dict(orient='records'))

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
