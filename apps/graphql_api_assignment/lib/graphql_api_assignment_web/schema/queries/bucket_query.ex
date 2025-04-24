defmodule GraphqlApiAssignmentWeb.Schema.Queries.BucketQuery do
  use Absinthe.Schema.Notation

  alias GraphqlApiAssignmentWeb.Resolvers.BucketResolver

  object :resolver_queries do
    @desc "Get a resolver's total hits"
    field :resolver_hits, :integer do
      arg :key, :bucket_action

      middleware RequestCache.Middleware, ttl: :timer.seconds(60)

      resolve &BucketResolver.get_resolver_hits/3
    end
  end
end
