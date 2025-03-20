import { serve } from "bun";
import { sql } from "./db";

serve({
  port: 3001,
  async fetch(req) {
    const url = new URL(req.url);
    
    if (req.method === "GET") {
      if (url.pathname === "/") {
        return new Response("Hello World");
      }
      
      if (url.pathname === "/status") {
        return new Response(JSON.stringify({
          status: "ok",
          timestamp: new Date().toISOString(),
          uptime: process.uptime()
        }), {
          headers: {
            "Content-Type": "application/json"
          }
        });
      }

      if (url.pathname === "/cars") {
        try {
          // Fetch cars from PostgreSQL
          const cars = await sql`SELECT * FROM cars`;
          
          return new Response(JSON.stringify(cars), {
            headers: {
              "Content-Type": "application/json"
            }
          });
        } catch (error: any) {
          console.error("Database error:", error);
          return new Response(JSON.stringify({ 
            error: "Failed to fetch cars data", 
            details: error.message 
          }), {
            status: 500,
            headers: {
              "Content-Type": "application/json"
            }
          });
        }
      }
    }
    
    return new Response("Not Found", { status: 404 });
  },
});