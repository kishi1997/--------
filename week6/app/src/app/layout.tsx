import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "Week 6 Database Lab",
  description: "Next.js・Prisma・PostgreSQL総合演習",
};

export default function RootLayout({ children }: LayoutProps<"/">) {
  return (
    <html lang="ja">
      <body>{children}</body>
    </html>
  );
}
