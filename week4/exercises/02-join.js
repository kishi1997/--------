const { performance } = require("node:perf_hooks");
const db = require("../lib/database");
const { printReport } = require("../lib/report");

// TODO: n1_usersとn1_postsをLEFT JOINし、20人分を1回のSQLで取得する。
// ヒント: 先にLIMIT 20したユーザーをWITH句で作る。
// 必要な別名: user_id, user_name, user_email, post_id, post_title, published_at
const JOIN_SQL = `
with selected_users as (
    select id, name, email
    from n1_users
    order by id
    limit 20
)
select
    u.id as user_id,
    u.name as user_name,
    u.email as user_email,
    p.id as post_id,
    p.title as post_title,
    p.published_at
  from selected_users as u
left join n1_posts p on p.user_id = u.id
order by u.id, p.id
`;

function groupRows(rows) {
  const users = new Map();

  for (const row of rows) {
    if (!users.has(row.user_id)) {
      users.set(row.user_id, {
        id: row.user_id,
        name: row.user_name,
        email: row.user_email,
        posts: [],
      });
    }

    if (row.post_id !== null) {
      users.get(row.user_id).posts.push({
        id: row.post_id,
        user_id: row.user_id,
        title: row.post_title,
        published_at: row.published_at,
      });
    }
  }

  return [...users.values()];
}

async function main() {
  if (!JOIN_SQL.trim()) {
    throw new Error("TODO: JOIN_SQLを完成させてください");
  }

  db.resetQueryCount();
  const startedAt = performance.now();
  const { rows } = await db.query(JOIN_SQL);
  const users = groupRows(rows);

  printReport({
    label: "JOIN",
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
