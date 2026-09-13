import { redirect } from "next/navigation";
import { purchaseProduct } from "@/lib/exercises";
import { TaskNav } from "@/components/task-nav";
import styles from "../task.module.css";

export const dynamic = "force-dynamic";

async function purchase(formData: FormData) {
  "use server";
  const productId=String(formData.get("productId")??"");
  const customerName=String(formData.get("customerName")??"").trim();
  let status="購入成功";
  try {
    if(!/^\d+$/.test(productId)||!customerName) throw new Error("商品IDと購入者名を入力してください");
    await purchaseProduct(BigInt(productId),customerName);
  } catch(error) { status=error instanceof Error?error.message:"購入失敗"; }
  redirect(`/task5?status=${encodeURIComponent(status)}`);
}

export default async function Task5Page({searchParams}: {searchParams: Promise<Record<string, string | string[] | undefined>>}) {
  const params=await searchParams;
  const status=typeof params.status==="string"?params.status:null;
  return <main className={styles.page}><TaskNav/><h1>TODO 5：購入Transaction</h1><p className={styles.lead}>このページだけは、送信ボタンを押したときに関数を実行します。</p><form action={purchase} className={styles.form}><input name="productId" inputMode="numeric" placeholder="商品ID（例：1）"/><input name="customerName" placeholder="購入者名"/><button type="submit">購入する</button></form>{status&&<p className={styles.status}>{status}</p>}</main>;
}
