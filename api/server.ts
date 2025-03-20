import { serve } from "bun";

const cars = [
  {
    id: 1,
    make: "Toyota",
    model: "Camry",
    year: 2023,
    color: "Silver",
    price: 25000,
  },
  {
    id: 2,
    make: "Honda",
    model: "Civic",
    year: 2023,
    color: "Blue",
    price: 22000,
  },
  {
    id: 3,
    make: "Tesla",
    model: "Model 3",
    year: 2023,
    color: "Red",
    price: 45000,
  },
];

const server = serve({
  port: 3001,
  fetch(req) {
    const url = new URL(req.url);
    
    if (url.pathname === "/") {
      return new Response("Welcome to the API!");
    }
    
    if (url.pathname === "/hello-world") {
      return new Response(JSON.stringify({ message: "Hello from Bun!" }), {
        headers: { "Content-Type": "application/json" },
      });
    }

    if (url.pathname === "/cars") {
      return new Response(JSON.stringify(cars), {
        headers: { "Content-Type": "application/json" },
      });
    }

    return new Response("Not Found", { status: 404 });
  },
});

console.log(`Server running at http://localhost:${server.port}`); 