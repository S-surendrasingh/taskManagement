module Pagination
  DEFAULT_PAGE = 1
  DEFAULT_PER_PAGE = 10
  MAX_PER_PAGE = 100

  private

  def pagination_params
    page = params[:page].to_i
    page = DEFAULT_PAGE if page < 1

    per_page = params[:per_page].to_i
    per_page = DEFAULT_PER_PAGE if per_page < 1
    per_page = [per_page, MAX_PER_PAGE].min

    [page, per_page]
  end
end
