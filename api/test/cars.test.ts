import { expect, test, describe, beforeAll, afterAll } from "bun:test";
import { sql } from "../db";

// Define car type
interface Car {
  id: number;
  make: string;
  model: string;
  year: number;
  color: string;
  price: number;
  created_at: string;
}

describe("Cars API", () => {
  // Setup: Insert test data
  beforeAll(async () => {
    await sql`
      INSERT INTO cars (make, model, year, color, price)
      VALUES 
        ('Test Toyota', 'Test Camry', 2023, 'Silver', 25000.00),
        ('Test Honda', 'Test Civic', 2023, 'Blue', 22100.00)
    `;
  });

  // Cleanup: Remove test data
  afterAll(async () => {
    await sql`DELETE FROM cars WHERE make LIKE 'Test%'`;
  });

  test("GET /cars should return list of cars", async () => {
    const response = await fetch("http://localhost:3001/cars");
    expect(response.status).toBe(200);
    
    const cars = await response.json() as Car[];
    expect(Array.isArray(cars)).toBe(true);
    expect(cars.length).toBeGreaterThan(0);
    
    // Check structure of car objects
    const car = cars[0];
    expect(car).toHaveProperty("id");
    expect(car).toHaveProperty("make");
    expect(car).toHaveProperty("model");
    expect(car).toHaveProperty("year");
    expect(car).toHaveProperty("color");
    expect(car).toHaveProperty("price");
    expect(car).toHaveProperty("created_at");
  });

  test("GET /cars should include test cars", async () => {
    const response = await fetch("http://localhost:3001/cars");
    const cars = await response.json() as Car[];
    
    const testCars = cars.filter(car => car.make.startsWith("Test"));
    expect(testCars.length).toBeGreaterThanOrEqual(2);
    
    const testToyota = testCars.find(car => car.make === "Test Toyota");
    expect(testToyota).toBeDefined();
    expect(testToyota!.model).toBe("Test Camry");
    expect(Number(testToyota!.price)).toBe(25000.00);
  });
}); 