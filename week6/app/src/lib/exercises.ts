import { prisma } from "./prisma";

export async function getProducts() {
  // TODO 1: activeかつstock > 0の商品を、price昇順で取得する。
  throw new Error("TODO 1: getProductsを実装してください");
}

export async function getProductPage(page: number, pageSize = 6) {
  // TODO 2: pageからskipを計算し、商品と総件数を返す。
  void page;
  void pageSize;
  throw new Error("TODO 2: getProductPageを実装してください");
}

export async function getOrdersWithItems() {
  // TODO 3: Order → items → productをincludeし、N+1を避ける。
  throw new Error("TODO 3: getOrdersWithItemsを実装してください");
}

export async function searchProducts(keyword: string) {
  // TODO 4: nameにkeywordを含む商品を検索する。
  void keyword;
  throw new Error("TODO 4: searchProductsを実装してください");
}

export async function purchaseProduct(productId: bigint, customerName: string) {
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
