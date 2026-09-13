import { searchProducts } from "@/lib/exercises";
import { TaskNav } from "@/components/task-nav";
import styles from "../task.module.css";

export const dynamic = "force-dynamic";

export default async function Task4Page({searchParams}: {searchParams: Promise<Record<string, string | string[] | undefined>>}) {
  const params=await searchParams;
  const keyword=typeof params.q==="string"?params.q:"";
  let items: Awaited<ReturnType<typeof searchProducts>>=[];
  let errorMessage:string|null=null;
  if(keyword) try { items=await searchProducts(keyword); } catch(error) { errorMessage=error instanceof Error?error.message:"検索できませんでした"; }
  return <main className={styles.page}><TaskNav/><h1>TODO 4：商品検索</h1><form className={styles.form}><input name="q" defaultValue={keyword} placeholder="商品名"/><button type="submit">検索</button></form>{errorMessage?<p className={styles.error}>{errorMessage}</p>:keyword?<><p>{items.length}件</p><div className={styles.grid}>{items.map(item=><article className={styles.card} key={item.id.toString()}><h2>{item.name}</h2><p>{item.price.toLocaleString("ja-JP")}円</p></article>)}</div></>:<p className={styles.status}>キーワードを入力してください</p>}</main>;
}
