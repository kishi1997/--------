import { prisma } from "./prisma";
import type { Prisma, Product } from "@/generated/prisma/client";

export type ProductPageResult = {
  products: Product[];
  total: number;
  totalPages: number;
};

export type OrderWithItems = Prisma.OrderGetPayload<{
  include: { items: { include: { product: true } } };
}>;

export async function getProducts() {
  return prisma.product.findMany({
    where: {
      active: true,
      stock: {
        gt: 0,
      },
    },
    orderBy: [{ price: "asc" }, { id: "asc" }],
  });
}

export async function getProductPage(
  page: number,
  pageSize = 6,
): Promise<ProductPageResult> {
  const where = {
    active: true,
    stock: { gt: 0 },
  };
  // 変更内容：ページ数が不数にならないように最低ページ数が1になるように設定
  // 理由：skipに負数が渡されるとエラーが起きるため
  const safePage = Math.max(1, page);
  const total = await prisma.product.count({
    where,
  });
  const totalPages = Math.ceil(total / pageSize);
  const products = await prisma.product.findMany({
    where,
    skip: (safePage - 1) * pageSize,
    take: pageSize,
    orderBy: { id: "asc" },
  });
  return { products, total, totalPages };
  // TODO 2: pageからskipを計算し、商品と総件数を返す。
  void page;
  void pageSize;
  throw new Error("TODO 2: getProductPageを実装してください");
}

export async function getOrdersWithItems(): Promise<OrderWithItems[]> {
  // TODO 3: Order → items → productをincludeし、N+1を避ける。
  const ordersWithItems = await prisma.order.findMany({
    orderBy: { id: "asc" },
    include: {
      items: {
        orderBy: { id: "asc" },
        include: {
          product: true,
        },
      },
    },
  });
  return ordersWithItems;
}

export async function searchProducts(keyword: string): Promise<Product[]> {
  const normalizedKeyword = keyword.trim();
  if (!normalizedKeyword) return [];
  // TODO 4: nameにkeywordを含む商品を検索する。
  return prisma.product.findMany({
    where: {
      name: {
        contains: normalizedKeyword,
        mode: "insensitive",
      },
      active: true,
      stock: { gt: 0 },
    },
    orderBy: { id: "asc" },
  });
}

export async function purchaseProduct(
  productId: bigint,
  customerName: string,
): Promise<unknown> {
  return prisma.$transaction(async (tx) => {
    const result = await tx.product.updateMany({
      where: {
        id: productId,
        active: true,
        stock: {
          gt: 0,
        },
      },
      data: {
        stock: {
          decrement: 1,
        },
      },
    });
    console.log("===== 在庫更新結果 =====", result);
    if (result.count === 0)
      throw new Error("お探しの商品が存在しないか、在庫切れです");
    const product = await tx.product.findUniqueOrThrow({
      where: {
        id: productId,
      },
      select: {
        id: true,
        price: true,
        name: true,
      },
    });
    const createOrder = await tx.order.create({
      data: {
        customerName,
        items: {
          create: {
            productId,
            quantity: 1,
            unitPrice: product.price,
          },
        },
      },
      include: {
        items: {
          include: {
            product: true,
          },
        },
      },
    });
    console.log("===== 注文作成結果 =====");
    console.log(createOrder);
    return createOrder;
  });
  // TODO 5:
  // 1. prisma.$transactionを開始する。
  // 2. updateManyでid、active、stock > 0を条件にstockを1減らす。
  // 3. countが0なら在庫切れとしてthrowする。
  // 4. 商品価格を取得する。
  // 5. OrderとOrderItemを作成して返す。
}
