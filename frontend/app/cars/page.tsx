interface Car {
  id: number;
  make: string;
  model: string;
  year: number;
  color: string;
  price: number;
  created_at: string;
}

async function getCars(): Promise<Car[]> {
  const res = await fetch('http://localhost:3001/cars');
  if (!res.ok) throw new Error('Failed to fetch cars');
  return res.json();
}

export default async function CarsPage() {
  const cars = await getCars();

  return (
    <div className="p-8">
      <h1 className="text-2xl font-bold mb-6">Car Inventory</h1>
      <div className="overflow-x-auto">
        <table className="min-w-full bg-white border border-gray-300">
          <thead>
            <tr className="bg-gray-100">
              <th className="px-6 py-3 border-b text-left">Make</th>
              <th className="px-6 py-3 border-b text-left">Model</th>
              <th className="px-6 py-3 border-b text-left">Year</th>
              <th className="px-6 py-3 border-b text-left">Color</th>
              <th className="px-6 py-3 border-b text-left">Price</th>
            </tr>
          </thead>
          <tbody>
            {cars.map((car: Car) => (
              <tr key={car.id} className="hover:bg-gray-50">
                <td className="px-6 py-4 border-b">{car.make}</td>
                <td className="px-6 py-4 border-b">{car.model}</td>
                <td className="px-6 py-4 border-b">{car.year}</td>
                <td className="px-6 py-4 border-b">{car.color}</td>
                <td className="px-6 py-4 border-b">${car.price.toLocaleString()}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
} 