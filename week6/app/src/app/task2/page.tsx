import Link from "next/link";
import { getProductPage } from "@/lib/exercises";
import { TaskNav } from "@/components/task-nav";
import styles from "../task.module.css";

export const dynamic = "force-dynamic";

export default async function Task2Page({searchParams}: {searchParams: Promise<Record<string, string | string[] | undefined>>}) {
  const params = await searchParams;
  const page = Math.max(1, Number(params.page) || 1);
  let result: Awaited<ReturnType<typeof getProductPage>> | null = null;
  let errorMessage: string | null = null;
  try { result = await getProductPage(page); }
  catch(error) { errorMessage=error instanceof Error?error.message:"取得できませんでした"; }

  return <main className={styles.page}><TaskNav/><h1>TODO 2：ページネーション</h1>{errorMessage||!result?<p className={styles.error}>{errorMessage}</p>:<><p className={styles.lead}>getProductPage({page})の結果</p><p className={styles.status}>{result.total}件・全{result.totalPages}ページ</p><div className={styles.grid}>{result.products.map(item=><article className={styles.card} key={item.id.toString()}><h2>{item.name}</h2><p>{item.price.toLocaleString("ja-JP")}円・在庫 {item.stock}</p></article>)}</div><div className={styles.form}>{page>1&&<Link href={`/task2?page=${page-1}`}>← 前へ</Link>} {page<result.totalPages&&<Link href={`/task2?page=${page+1}`}>次へ →</Link>}</div></>}</main>;
}
