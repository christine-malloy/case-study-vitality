import { serve } from "bun";
import sql from './db';

const port = Number(process.env.PORT) || 3001;

const server = serve({
  port,
  async fetch(req) {
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
      try {
        const cars = await sql`
          SELECT * FROM cars
          ORDER BY id ASC
        `;
        
        return new Response(JSON.stringify(cars), {
          headers: { "Content-Type": "application/json" },
        });
      } catch (error) {
        console.error('Database error:', error);
        return new Response(JSON.stringify({ error: "Failed to fetch cars" }), {
          status: 500,
          headers: { "Content-Type": "application/json" },
        });
      }
    }

    return new Response("Not Found", { status: 404 });
  },
});

console.log(`Server running at http://localhost:${server.port}`); 