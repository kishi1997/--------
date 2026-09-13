import { TaskNav } from "@/components/task-nav";
import { getOrdersWithItems } from "@/lib/exercises";
import styles from "../task.module.css";

export const dynamic = "force-dynamic";

export default async function Task3Page() {
  let orders: Awaited<ReturnType<typeof getOrdersWithItems>> = [];
  let errorMessage: string | null = null;

  try {
    orders = await getOrdersWithItems();
  } catch (error) {
    errorMessage =
      error instanceof Error ? error.message : "取得できませんでした";
  }

  return (
    <main className={styles.page}>
      <TaskNav />
      <h1>TODO 3：注文履歴</h1>
      <p className={styles.lead}>
        Orderの中に複数のOrderItemがあり、各OrderItemが1つのProductを参照します。
      </p>

      <div className={styles.relationGuide}>
        <strong>Order（注文）</strong>
        <span>1</span><b>→</b><span>複数</span>
        <strong>OrderItem（注文明細）</strong>
        <span>複数</span><b>→</b><span>1</span>
        <strong>Product（商品）</strong>
      </div>

      {errorMessage ? (
        <p className={styles.error}>{errorMessage}</p>
      ) : (
        <>
          <p className={styles.status}>{orders.length}件の注文</p>
          {orders.map((order) => (
            <article className={styles.orderDetail} key={order.id.toString()}>
              <header className={styles.orderHeader}>
                <div>
                  <span className={styles.modelLabel}>Order・注文</span>
                  <h2>注文 #{order.id.toString()}</h2>
                </div>
                <dl>
                  <div><dt>購入者</dt><dd>{order.customerName}</dd></div>
                  <div><dt>注文日時</dt><dd>{order.createdAt.toLocaleString("ja-JP")}</dd></div>
                </dl>
              </header>

              <div className={styles.itemList}>
                {order.items.map((item) => (
                  <section className={styles.itemDetail} key={item.id.toString()}>
                    <div className={styles.itemData}>
                      <span className={styles.modelLabel}>OrderItem・注文明細</span>
                      <h3>明細 #{item.id.toString()}</h3>
                      <dl>
                        <div><dt>数量</dt><dd>{item.quantity}</dd></div>
                        <div><dt>購入時単価</dt><dd>{item.unitPrice.toLocaleString("ja-JP")}円</dd></div>
                        <div><dt>小計</dt><dd>{(item.unitPrice * item.quantity).toLocaleString("ja-JP")}円</dd></div>
                      </dl>
                    </div>

                    <div className={styles.productData}>
                      <span className={styles.modelLabel}>Product・商品</span>
                      <h3>{item.product.name}</h3>
                      <dl>
                        <div><dt>商品ID</dt><dd>{item.product.id.toString()}</dd></div>
                        <div><dt>現在価格</dt><dd>{item.product.price.toLocaleString("ja-JP")}円</dd></div>
                        <div><dt>現在庫</dt><dd>{item.product.stock}</dd></div>
                        <div><dt>販売状態</dt><dd>{item.product.active ? "販売中" : "停止中"}</dd></div>
                      </dl>
                    </div>
                  </section>
                ))}
              </div>
            </article>
          ))}
        </>
      )}
    </main>
  );
}
