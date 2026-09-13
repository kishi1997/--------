import Link from "next/link";
import styles from "./task-nav.module.css";

const links = [
  ["/", "TODO 1 商品一覧"],
  ["/task2", "TODO 2 ページネーション"],
  ["/task3", "TODO 3 注文履歴"],
  ["/task4", "TODO 4 検索"],
  ["/task5", "TODO 5 購入"],
];

export function TaskNav() {
  return <nav className={styles.nav}>{links.map(([href,label])=><Link href={href} key={href}>{label}</Link>)}</nav>;
}
