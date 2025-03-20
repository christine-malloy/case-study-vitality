import Link from "next/link";

export default function Home() {
  return (
    <div className="min-h-screen p-8 flex items-center justify-center">
      <main className="flex flex-col gap-8 items-center">
        <h1 className="text-2xl font-bold">Welcome</h1>
        <Link
          href="/cars"
          className="rounded-full border border-solid border-black/[.08] dark:border-white/[.145] transition-colors flex items-center justify-center hover:bg-[#f2f2f2] dark:hover:bg-[#1a1a1a] hover:border-transparent font-medium text-sm sm:text-base h-10 sm:h-12 px-4 sm:px-5 w-full sm:w-auto"
        >
          View Cars
        </Link>
      </main>
    </div>
  );
}
