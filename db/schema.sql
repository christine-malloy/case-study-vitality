CREATE TABLE IF NOT EXISTS cars (
    id SERIAL PRIMARY KEY,
    make VARCHAR(50) NOT NULL,
    model VARCHAR(50) NOT NULL,
    year INTEGER NOT NULL,
    color VARCHAR(50) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Insert some initial data
INSERT INTO cars (make, model, year, color, price) VALUES
    ('Toyota', 'Camry', 2023, 'Silver', 25000.00),
    ('Honda', 'Civic', 2023, 'Blue', 22100.00),
    ('Tesla', 'Model 3', 2023, 'Red', 45000.00); 