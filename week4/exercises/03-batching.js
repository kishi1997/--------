const { performance } = require("node:perf_hooks");
const db = require("../lib/database");
const { printReport } = require("../lib/report");

// TODO: user_idの配列を使い、必要な投稿を1回でまとめて取得する。
// 返すカラム: id, user_id, title, published_at
const POSTS_SQL = "";

async function main() {
  if (!POSTS_SQL.trim()) {
    throw new Error("TODO: POSTS_SQLを完成させてください");
  }

  db.resetQueryCount();
  const startedAt = performance.now();
  const { rows: users } = await db.query(`
    select id, name, email
    from n1_users
    order by id
    limit 20
  `);

  const userIds = users.map((user) => user.id);
  const { rows: posts } = await db.query(POSTS_SQL, [userIds]);
  const postsByUserId = new Map();

  for (const post of posts) {
    const key = String(post.user_id);
    const group = postsByUserId.get(key) || [];
    group.push(post);
    postsByUserId.set(key, group);
  }

  for (const user of users) {
    user.posts = postsByUserId.get(String(user.id)) || [];
  }

  printReport({
    label: "Batching",
    users,
    queryCount: db.getQueryCount(),
    elapsedMs: performance.now() - startedAt,
  });
}

main()
  .catch((error) => {
    console.error(error.message);
    process.exitCode = 1;
  })
  .finally(() => db.close());
