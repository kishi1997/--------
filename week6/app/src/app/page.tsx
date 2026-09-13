import { getProducts } from "@/lib/exercises";
import { TaskNav } from "@/components/task-nav";
import styles from "./page.module.css";

const tasks = [
  ["01", "商品一覧", "条件・並び順をPrismaで書く"],
  ["02", "ページネーション", "skip・take・countを組み合わせる"],
  ["03", "注文履歴", "関連取得でN+1を避ける"],
  ["04", "検索とIndex", "実行計画で効果を測る"],
  ["05", "購入Transaction", "最後の1個を安全に販売する"],
];

export const dynamic = "force-dynamic";

export default async function Home() {
  let items: Awaited<ReturnType<typeof getProducts>> = [];
  let loadError: string | null = null;

  try {
    items = await getProducts();
  } catch (error) {
    loadError = error instanceof Error ? error.message : "商品を取得できませんでした";
  }

  return (
    <main className={styles.page}>
      <TaskNav />
      <header>
        <p className={styles.eyebrow}>DATABASE LEARNING · WEEK 6</p>
        <h1>商品購入アプリを完成させる</h1>
        <p className={styles.lead}>
          Next.js → Prisma →
          PostgreSQLをつなぎ、これまで学んだDB設計をアプリの処理として実装します。
        </p>
      </header>
      <section className={styles.grid}>
        {tasks.map(([number, title, description]) => (
          <article className={styles.card} key={number}>
            <span>{number}</span>
            <h2>{title}</h2>
            <p>{description}</p>
          </article>
        ))}
      </section>
      <section className={styles.results}>
        <div className={styles.resultsHeader}>
          <div>
            <span className={styles.resultLabel}>TODO 1 実行結果</span>
            <h2>販売中の商品</h2>
          </div>
          {!loadError && <strong>{items.length}件</strong>}
        </div>

        {loadError ? (
          <p className={styles.error}>{loadError}</p>
        ) : items.length > 0 ? (
          <div className={styles.products}>
            {items.map((i) => (
              <article className={styles.product} key={i.id.toString()}>
                <span>{i.name}</span>
                <strong>{i.price.toLocaleString("ja-JP")}円</strong>
                <small>在庫 {i.stock}</small>
              </article>
            ))}
          </div>
        ) : (
          <p>アイテム無し</p>
        )}
      </section>
      <aside className={styles.next}>
        <strong>最初の作業</strong>
        <code>src/lib/exercises.ts の TODO 1</code>
      </aside>
    </main>
  );
}
