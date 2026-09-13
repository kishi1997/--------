import styles from "./page.module.css";

const tasks = [
  ["01", "商品一覧", "条件・並び順をPrismaで書く"],
  ["02", "ページネーション", "skip・take・countを組み合わせる"],
  ["03", "注文履歴", "関連取得でN+1を避ける"],
  ["04", "検索とIndex", "実行計画で効果を測る"],
  ["05", "購入Transaction", "最後の1個を安全に販売する"],
];

export default function Home() {
  return (
    <main className={styles.page}>
      <header>
        <p className={styles.eyebrow}>DATABASE LEARNING · WEEK 6</p>
        <h1>商品購入アプリを完成させる</h1>
        <p className={styles.lead}>Next.js → Prisma → PostgreSQLをつなぎ、これまで学んだDB設計をアプリの処理として実装します。</p>
      </header>
      <section className={styles.grid}>
        {tasks.map(([number, title, description]) => (
          <article className={styles.card} key={number}>
            <span>{number}</span><h2>{title}</h2><p>{description}</p>
          </article>
        ))}
      </section>
      <aside className={styles.next}><strong>最初の作業</strong><code>src/lib/exercises.ts の TODO 1</code></aside>
    </main>
  );
}
