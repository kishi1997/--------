import "dotenv/config";
import { PrismaPg } from "@prisma/adapter-pg";
import { PrismaClient } from "../src/generated/prisma/client";

const prisma = new PrismaClient({
  adapter: new PrismaPg({ connectionString: process.env.DATABASE_URL! }),
});

async function main() {
  await prisma.orderItem.deleteMany();
  await prisma.order.deleteMany();
  await prisma.product.deleteMany();

  await prisma.product.createMany({
    data: Array.from({ length: 18 }, (_, index) => ({
      name: `学習商品 ${String(index + 1).padStart(2, "0")}`,
      price: 500 + index * 100,
      stock: index === 0 ? 1 : 3 + (index % 5),
    })),
  });
}

main().finally(() => prisma.$disconnect());
