import { getOrdersWithItems } from "@/lib/exercises";
import { TaskNav } from "@/components/task-nav";
import styles from "../task.module.css";

export const dynamic = "force-dynamic";

export default async function Task3Page() {
  let orders: Awaited<ReturnType<typeof getOrdersWithItems>>=[];
  let errorMessage:string|null=null;
  try { orders=await getOrdersWithItems(); }
  catch(error) { errorMessage=error instanceof Error?error.message:"取得できませんでした"; }
  return <main className={styles.page}><TaskNav/><h1>TODO 3：注文履歴</h1>{errorMessage?<p className={styles.error}>{errorMessage}</p>:<><p className={styles.lead}>{orders.length}件の注文</p>{orders.map(order=><article className={styles.order} key={order.id.toString()}><strong>注文 #{order.id.toString()}・{order.customerName}</strong><ul>{order.items.map(item=><li key={item.id.toString()}>{item.product.name} × {item.quantity}</li>)}</ul></article>)}</>}</main>;
}
