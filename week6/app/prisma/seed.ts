import "dotenv/config";
import { PrismaPg } from "@prisma/adapter-pg";
import { PrismaClient } from "../src/generated/prisma/client";

const prisma = new PrismaClient({
  adapter: new PrismaPg({ connectionString: process.env.DATABASE_URL! }),
  log: ["query", "error", "warn"],
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

  const products = await prisma.product.findMany({
    orderBy: { name: "asc" },
    take: 6,
  });

  await prisma.order.create({
    data: {
      customerName: "田中",
      items: {
        create: [
          {
            productId: products[0].id,
            quantity: 1,
            unitPrice: products[0].price,
          },
          {
            productId: products[1].id,
            quantity: 2,
            unitPrice: products[1].price,
          },
        ],
      },
    },
  });

  await prisma.order.create({
    data: {
      customerName: "佐藤",
      items: {
        create: [
          {
            productId: products[2].id,
            quantity: 1,
            unitPrice: products[2].price,
          },
          {
            productId: products[3].id,
            quantity: 1,
            unitPrice: products[3].price,
          },
          {
            productId: products[4].id,
            quantity: 3,
            unitPrice: products[4].price,
          },
        ],
      },
    },
  });

  await prisma.order.create({
    data: {
      customerName: "鈴木",
      items: {
        create: [
          {
            productId: products[0].id,
            quantity: 1,
            unitPrice: products[0].price,
          },
          {
            productId: products[5].id,
            quantity: 1,
            unitPrice: products[5].price,
          },
        ],
      },
    },
  });

  console.log("Seed complete: products=18, orders=3, orderItems=7");
}

main().finally(() => prisma.$disconnect());
