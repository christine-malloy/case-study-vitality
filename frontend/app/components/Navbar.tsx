import Link from "next/link";

export default function Navbar() {
  return (
    <nav className="w-full border-b border-black/[.08] dark:border-white/[.145]">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex justify-between h-16 items-center">
          <Link
            href="/"
            className="font-medium text-sm sm:text-base hover:text-gray-600 dark:hover:text-gray-300"
          >
            Home
          </Link>
        </div>
      </div>
    </nav>
  );
} 