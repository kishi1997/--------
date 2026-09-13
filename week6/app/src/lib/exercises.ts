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
  // TODO 2: pageからskipを計算し、商品と総件数を返す。
  void page;
  void pageSize;
  throw new Error("TODO 2: getProductPageを実装してください");
}

export async function getOrdersWithItems(): Promise<OrderWithItems[]> {
  // TODO 3: Order → items → productをincludeし、N+1を避ける。
  throw new Error("TODO 3: getOrdersWithItemsを実装してください");
}

export async function searchProducts(keyword: string): Promise<Product[]> {
  // TODO 4: nameにkeywordを含む商品を検索する。
  void keyword;
  throw new Error("TODO 4: searchProductsを実装してください");
}

export async function purchaseProduct(
  productId: bigint,
  customerName: string,
): Promise<unknown> {
  // TODO 5:
  // 1. prisma.$transactionを開始する。
  // 2. updateManyでid、active、stock > 0を条件にstockを1減らす。
  // 3. countが0なら在庫切れとしてthrowする。
  // 4. 商品価格を取得する。
  // 5. OrderとOrderItemを作成して返す。
  void prisma;
  void productId;
  void customerName;
  throw new Error("TODO 5: purchaseProductを実装してください");
}
