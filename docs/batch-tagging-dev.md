# batch tagging doc

## Function

在 contest 頁面（`/contests/:id`）提供按鈕讓 admin 對比賽底下的所有題目加入或刪除 tag。

## Code

| Component | File |
|---|---|
| Route | `config/routes.rb` — `contests` 的 member route `post 'batch_update_tags'` |
| Controller | `app/controllers/contests_controller.rb` → `#batch_update_tags` |
| View | `app/views/contests/show.html.erb` — `effective_admin?` |
| Model | `app/models/problem.rb` — `acts_as_taggable_on :tags, :solution_tags` |
| Test | `test/controllers/contests_controller_test.rb` |


## Requests

- `POST /contests/:id/batch_update_tags`（path helper：`batch_update_tags_contest_path`）
- Parameters:
  - `tag_name`
  - `operation`：`add` / `remove`。
- return `redirect_to contest_path(@contest)` with `flash[:notice]` / `flash[:alert]`

## Permissions

- In controller: `before_action :authenticate_admin!`

## Procedure

1. `before_action :set_tasks` load `@tasks` from `contest_problem_joints` 
2. if no `tag_name` -> `flash[:alert]`
3. call `tag_list.add` / `tag_list.remove` then `problem.save` for all tasks
4. `flash[:notice]` and redirect

## 注意事項

- 沒有包在 transaction 裡：若中途某題 `save` 失敗，前面已處理的操作不會回滾。

## Testing

```bash
bin/rails test test/controllers/contests_controller_test.rb
```
