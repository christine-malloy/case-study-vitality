export default function CarsPage() {
  // Dummy car data
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
            {cars.map((car) => (
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