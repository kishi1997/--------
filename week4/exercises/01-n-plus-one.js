const { performance } = require("node:perf_hooks");
const db = require("../lib/database");
const { printReport } = require("../lib/report");

async function main() {
  db.resetQueryCount();
  const startedAt = performance.now();

  const { rows: users } = await db.query(`
    select id, name, email
    from n1_users
    order by id
    limit 20
  `);

  // ORMで users.map(user => user.posts()) のように書くと起きやすいN+1を再現する。
  for (const user of users) {
    const { rows: posts } = await db.query(
      `select id, user_id, title, published_at
       from n1_posts
       where user_id = $1
       order by id`,
      [user.id],
    );
    user.posts = posts;
  }

  printReport({
    label: "N+1",
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
