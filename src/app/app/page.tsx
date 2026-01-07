import { getServerSession } from "next-auth";
import { redirect } from "next/navigation";

import { authOptions } from "@/lib/auth";

export default async function AppHomePage() {
  const session = await getServerSession(authOptions);

  if (!session?.user?.email) {
    redirect("/auth");
  }

  return (
    <div className="max-w-2xl">
      <h1 className="text-2xl font-semibold tracking-tight text-zinc-950">
        Săptămâna ta
      </h1>
      <p className="mt-2 text-sm leading-6 text-zinc-700">
        În MVP, aici va apărea lista de conexiuni (0–3) pentru săptămâna curentă.
      </p>

      <div className="mt-8 rounded-2xl border border-zinc-200 bg-white p-6">
        <p className="text-sm leading-6 text-zinc-700">
          Următoarele conexiuni: (de implementat)
        </p>
      </div>
    </div>
  );
}
